import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommodityData {
  final String sNo;
  final String city;
  final String commodity;
  final String minPrice;
  final String maxPrice;
  final String modelPrice;
  final String date;

  CommodityData({
    required this.sNo,
    required this.city,
    required this.commodity,
    required this.minPrice,
    required this.maxPrice,
    required this.modelPrice,
    required this.date,
  });

  factory CommodityData.fromJson(Map<String, dynamic> json) {
    return CommodityData(
      sNo: json['S.No'],
      city: json['City'],
      commodity: json['Commodity'],
      minPrice: json['Min Prize'],
      maxPrice: json['Max Prize'],
      modelPrice: json['Model Prize'],
      date: json['Date'],
    );
  }
}

Future<List<CommodityData>> fetchCommodityData(
    String state, String commodity, String market) async {
  final response = await http.get(Uri.parse(
      'https://agmarknet.gov.in/default.aspx/request?state=$state&commodity=$commodity&market=$market'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => CommodityData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class CommodityList extends StatelessWidget {
  final String state;
  final String commodity;
  final String market;

  CommodityList(
      {required this.state, required this.commodity, required this.market});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commodity Prices'),
      ),
      body: FutureBuilder<List<CommodityData>>(
        future: fetchCommodityData(state, commodity, market),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return ListTile(
                  title: Text(data.commodity),
                  subtitle:
                      Text('${data.city}, ${data.minPrice} - ${data.maxPrice}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CommodityList(
      state: 'YourState',
      commodity: 'YourCommodity',
      market: 'YourMarket',
    ),
  ));
}
