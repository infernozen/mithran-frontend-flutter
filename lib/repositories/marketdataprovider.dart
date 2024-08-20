import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import '../models/marketdata.dart';
import 'package:http/http.dart' as http;

class MarketDataProvider extends ChangeNotifier {
  List<MarketData> marketDataList = [];
  List<MarketData> originalMarketDataList = []; // To store the original data
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

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        originalMarketDataList =
            data.map((json) => MarketData.fromJson(json)).toList();
        marketDataList = List.from(
            originalMarketDataList); // Initialize with the original data
      } else {
        marketDataList.clear();
        originalMarketDataList.clear();
      }
    } catch (e) {
      marketDataList.clear();
      originalMarketDataList.clear();
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
