import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/marketdata.dart';
import '../../repositories/marketdataprovider.dart';

class Market extends StatelessWidget {
  final void Function() onReset;
  Market({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MarketDataProvider(),
      child: MarketPlace(onReset: onReset),
    );
  }
}

class MarketPlace extends StatefulWidget {
  final void Function() onReset;
  MarketPlace({super.key, required this.onReset});
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  List<String> crop = [
    "Potato",
    "Apple",
    "Banana",
    "Cabbage",
    "Cherry",
    "Butter"
  ];
  List<String> cities = [
    "Bangalore",
    "Belgaum",
    "Mysore",
    "Salem",
    "Ranipet",
    "Sivaganga",
    "Krishnagiri",
    "Agra",
    "Hyderabad",
    "Ernakulam",
    "Kollam",
    "Kottayam"
  ];
  String selectedState = "";
  String selectedCrop = "";
  String selectedCity = "";

  void initState() {
    super.initState();
    selectedCity = cities.first;
    selectedCrop = crop.first;
    selectedState = states.first;
    final dataProvider =
        Provider.of<MarketDataProvider>(context, listen: false);
    dataProvider.fetchData(selectedCrop, selectedState);
  }

  void _fetchData(String selectedCrop, String selectedState) {
    final dataProvider =
        Provider.of<MarketDataProvider>(context, listen: false);
    dataProvider.fetchData(selectedCrop, selectedState);
  }

  void _filterByCity(String selectedCity) {
    final dataProvider =
        Provider.of<MarketDataProvider>(context, listen: false);
    List<MarketData> filteredData =
        dataProvider.getFilteredDataByCity(selectedCity);
    setState(() {
      dataProvider.marketDataList =
          filteredData; // Use filtered data for display
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<MarketDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
            onPressed: () {
              widget.onReset();
            },
          ),
        ),
        title: Text(
          "Market Place",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(children: [
              const Spacer(),
              DropdownMenu<String>(
                label: Text("State"),
                width: 120.0,
                dropdownMenuEntries:
                    states.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    selectedState = value!;
                    _fetchData(selectedCrop, selectedState);
                  });
                },
              ),
              const Spacer(),
              DropdownMenu<String>(
                label: Text("City"),
                width: 120.0,
                dropdownMenuEntries:
                    cities.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    selectedCity = value!;
                    _filterByCity(selectedCity); // Filter data by selected city
                  });
                },
              ),
              const Spacer(),
              DropdownMenu<String>(
                label: Text("Crop"),
                width: 120.0,
                dropdownMenuEntries:
                    crop.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    selectedCrop = value!;
                    _fetchData(selectedCrop, selectedState);
                  });
                },
              ),
              const Spacer(),
            ]),
          ),
          const SizedBox(height: 20),
          !dataProvider.isLoading
              ? !dataProvider.marketDataList.isEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: dataProvider.marketDataList.length,
                        itemBuilder: (context, index) {
                          double value1 = double.parse(dataProvider
                                  .marketDataList[index].modelPrice) -
                              double.parse(
                                  dataProvider.marketDataList[index].maxPrice);
                          double value2 = double.parse(dataProvider
                                  .marketDataList[index].modelPrice) -
                              double.parse(
                                  dataProvider.marketDataList[index].minPrice);
                          return Container(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: Container(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 15.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${selectedCrop}",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              )),
                                          const SizedBox(height: 5.0),
                                          Container(
                                            width: 225.0,
                                            child: Text(
                                                '${selectedState}(${dataProvider.marketDataList[index].city})',
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13.0,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹ ${dataProvider.marketDataList[index].modelPrice} / Q',
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 15.0),
                                      Text(
                                        "${dataProvider.marketDataList[index].date}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Icon(Icons.auto_graph, size: 25.0),
                                      const Spacer(),
                                      Container(
                                        width: index % 2 == 0
                                            ? value1 == 0
                                                ? 0.0
                                                : 125.0
                                            : value2 == 0
                                                ? 0.0
                                                : 125.0,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: index % 2 == 0
                                              ? value1 == 0
                                                  ? Colors.white
                                                  : Colors.red
                                              : value2 == 0
                                                  ? Colors.white
                                                  : Colors.green,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              index % 2 == 0
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              size: 20.0,
                                              color: index % 2 == 0
                                                  ? value1 == 0
                                                      ? Colors.transparent
                                                      : Colors.white
                                                  : value2 == 0
                                                      ? Colors.transparent
                                                      : Colors.white,
                                            ),
                                            const Spacer(),
                                            Text(
                                              index % 2 == 0
                                                  ? "₹ ${value1}"
                                                  : "₹ ${value2}",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text("No Results Found",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500)))
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
