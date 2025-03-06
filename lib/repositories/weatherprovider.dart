import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:mithran/models/forecastmodel.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> data = {}, currentData = {};
  List<dynamic> list = [];
  String dailySummary= "";
  List<ForeCastModel> foreCastList = [];
  List<String> dailyForecastListIcons = [];
  List<Map<String, dynamic>> dailyForecastList = [];
  

  Future<void> fetchWeatherData(String latitude, String longitude) async {
    isLoading = true;
    try {
      var weatherResponse = await http.get(
          Uri.parse('http://34.122.191.130:5000/weather/currentWeather')
              .replace(queryParameters: {
        'lat': latitude,
        'lon': longitude,
      }));

      var forecastResponse = await http.get(
          Uri.parse('http://34.122.191.130:5000/weather/hourlyForecast')
              .replace(queryParameters: {
        'lat': latitude,
        'lon': longitude,
      }));

      var dailyForecastResponse = await http.get(
          Uri.parse('http://34.122.191.130:5000/weather/dailyForecast')
              .replace(queryParameters: {
        'lat': latitude,
        'lon': longitude,
      }));

      print(weatherResponse.statusCode);
      print(forecastResponse.statusCode);
      print(dailyForecastResponse.statusCode);
      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200 &&
          dailyForecastResponse.statusCode == 200) {
        // This is for Forecast Weather Data
        data = jsonDecode(forecastResponse.body);
        list = data['list'].take(6).toList();
        print(list);
        for (var element in list) {
          String dtTxt = element['dt_txt'];
          String time =
              dtTxt.split(' ')[1]; // Extract the time part ("22:00:00")
          String formattedTime =
              time.substring(0, 5); // Get "HH:mm" format ("22:00")
          String icon = element['weather'][0]['icon'];
          double temperature = element['main']['temp'].toDouble();
          foreCastList.add(ForeCastModel(
              time: formattedTime, icon: icon, temperature: temperature));
          // print('Time: $formattedTime, Icon: $icon');
        }
        // This is for Current Weather Data
        data = jsonDecode(weatherResponse.body);
        List daily = data['daily'];
        dailySummary = daily[0]['summary'];
        currentData = data['current'];
        weatherData = {
          'temperature': currentData['temp'],
          'minTemperature': currentData['temp'] - 2.0,
          'humidity': currentData['humidity'],
          'speed': currentData['wind_speed'],
          'rainPossibility': data['daily'][0]['pop'],
          'rainMeasure': data['daily'][0]['rain']
        };
        // This is for daily fore cast
        data = jsonDecode(dailyForecastResponse.body);
        list = data['list'];
        for (int i = 0; i < list.length; i++) {
          var weather = list[i]['weather'];
          dailyForecastListIcons.add(weather[0]['icon']);
          var weatherData = {
          'temperature': list[i]['temp']['day'],
          'minTemperature': list[i]['temp']['day'] - 2.0,
          'humidity': list[i]['humidity'],
          'speed': list[i]['speed'],
          'rainPossibility': list[i]['clouds'],
          'rainMeasure': list[i]['rain']
          };
          dailyForecastList.add(weatherData);
        }
      }
    } catch (e) {
      print("Error in fetching");
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
