import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mithran/helpers/soilhealthhelp.dart';
import 'package:mithran/models/weatherdata.dart';

class FarmProvider extends ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> farmData = {};
  Map<String, dynamic> vegetationData = {};
  Map<String, dynamic> weatherData = {}, dayData = {};
  List<WeatherData> weatherDataList = [];

  Future<void> fetchSoilData(
      String polygonId, String crop, String latitude, String longitude) async {
    isLoading = true;
    weatherDataList = [];
    try {
      var soilResponse = await http.get(
        Uri.parse('http://35.208.131.250:5000/soil/currentSoilData')
            .replace(queryParameters: {
          'polyid': polygonId,
        }),
      );

      var msCropResponse = await http.get(
        Uri.parse('http://35.208.131.250:5000/soil/mithranScoreForCrop')
            .replace(queryParameters: {
          'polyid': polygonId,
          'crop': crop,
        }),
      );

      var msResponse = await http.get(
        Uri.parse('http://35.208.131.250:5000/soil/mithranScore')
            .replace(queryParameters: {
          'polyid': polygonId,
        }),
      );

      var weatherResponse = await http.get(
          Uri.parse('http://35.208.131.250:5000/weather/currentWeather')
              .replace(queryParameters: {
        'lat': latitude,
        'lon': longitude,
      }));

      // print(soilResponse.statusCode);
      // print(polygonId);
      // print("polygonId");
      // print(soilResponse.body);
      // print(msCropResponse.statusCode);
      // print(msCropResponse.body);
      // print(msResponse.statusCode);
      // print(msResponse.body);
      // print("Weather Response");
      // print(weatherResponse.statusCode);
      // print(weatherResponse.body);
      if (soilResponse.statusCode == 200 &&
          msCropResponse.statusCode == 200 &&
          msResponse.statusCode == 200 &&
          weatherResponse.statusCode == 200) {
        // this is for soil Data
        var body = jsonDecode(soilResponse.body);
        int timestamp = body['dt'];
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        DateTime dateOnly =
            DateTime(dateTime.year, dateTime.month, dateTime.day);
        farmData = {
          't0': body['t0'],
          't10': body['t10'],
          'moisture': body['moisture'],
          'date': dateOnly,
        };
        //
        // this is for the vegetation data
        var msCropbody = jsonDecode(msCropResponse.body);
        var msBody = jsonDecode(msResponse.body);
        vegetationData = {
          'date': dateOnly,
          'mithranScore': msCropbody['mithranScore'],
          'ndvi': msBody['mithranScore'],
          'message': msBody['message'],
          'condition': getMithranScoreCondition(msBody['mithranScore'])
        };
        //
        // this is for the weather data
        var weatherBody = jsonDecode(weatherResponse.body);
        var daily = weatherBody['daily'];
        for (int i = 0; i < daily.length; i++) {
          timestamp = daily[i]['dt'];
          dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
          double? rain = daily[i]["rain"];
          double rainValue = rain ?? 2.24;
          // print(rainValue);

          // print({
          //   'rain': rainValue,
          //   'humidity': daily[i]["humidity"],
          //   'temp': daily[i]["temp"]["day"],
          //   'pressure': daily[i]['pressure'],
          // });
          // print(rainValue);
          // print(daily[i]["humidity"]);
          // print(daily[i]["temp"]["day"]);
          // print(daily[i]['pressure']);

          weatherDataList.add(WeatherData(
            date: dateOnly,
            temperature: daily[i]["temp"]["day"] + 0.0,
            humidity: daily[i]["humidity"],
            rain: rainValue,
            pressure: daily[i]["pressure"],
          ));
        }
        // print("rainValue");
        // print(weatherDataList[1].rain);
        dayData = {
          "dayTemp": daily[0]["temp"]["day"],
          "minTemp": daily[0]["temp"]["min"],
          "maxTemp": daily[0]["temp"]["max"],
          "nightTemp": daily[0]["temp"]["night"],
          "humidity": daily[0]["humidity"],
          "rain": daily[0]["rain"],
          "pressure": daily[0]["pressure"],
        };
        // print(dayData);
        var result = generateCropHealthInsight(dayData);
        // print("result");
        // print(result);
        weatherData = {
          "rain": daily[0]["rain"] ?? 2.44,
          "pressure": daily[0]["pressure"],
          "message": result["Insight"],
          "condition": result["Condition"],
        };
        print(weatherData);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
