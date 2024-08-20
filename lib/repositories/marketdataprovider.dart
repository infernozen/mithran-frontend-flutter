import 'package:flutter/material.dart';
import 'package:mithran/models/marketdata.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketDataProvider extends ChangeNotifier {
  List<MarketData> marketDataList = [];
  List<MarketData> originalMarketDataList = [];
  Map<String, List<double>> cityPriceMap = {};
  Map<String, double> cityMeanPriceMap = {};
  bool isLoading = true;

  Future<void> fetchData(String commodity, String state) async {
    isLoading = true;
    try {
      var response = await http.get(
          Uri.parse('http://35.208.131.250:5000/market/price')
              .replace(queryParameters: {
        'commodity': commodity,
        'state': state,
      }));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        originalMarketDataList =
            data.map((json) => MarketData.fromJson(json)).toList();
        marketDataList = List.from(originalMarketDataList);
        for (var entry in marketDataList) {
          String city = entry.city;
          double price = double.tryParse(entry.modelPrice) ?? 0.0;

          if (!cityPriceMap.containsKey(city)) {
            cityPriceMap[city] = [];
          }
          cityPriceMap[city]!.add(price);
        }
        cityPriceMap.forEach((city, prices) {
          double meanPrice = prices.reduce((a, b) => a + b) / prices.length;
          cityMeanPriceMap[city] = meanPrice;
        });
      } else {
        marketDataList.clear();
        originalMarketDataList.clear();
        cityMeanPriceMap.clear();
        cityPriceMap.clear();
      }
    } catch (e) {
      marketDataList.clear();
      originalMarketDataList.clear();
      cityMeanPriceMap.clear();
      cityPriceMap.clear();
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<MarketData> getFilteredDataByCity(String city) {
    String cleanedCity = _cleanString(city);
    return originalMarketDataList
        .where((item) => _cleanString(item.city) == cleanedCity)
        .toList();
  }

  String _cleanString(String value) {
    return value.replaceAll(RegExp(r'^_+|_+$'), '').trim();
  }
}
