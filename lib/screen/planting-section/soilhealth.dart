import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mithran/data/data.dart';
import 'package:mithran/field_locator.dart';
import 'package:mithran/models/cropfield.dart';
import 'package:mithran/models/trendingmodel.dart';
import 'package:mithran/screen/planting-section/digitaltwin.dart';
import 'package:mithran/screen/planting-section/fertilizercalculator.dart';
import 'package:mithran/screen/planting-section/leafhealth.dart';
import 'package:mithran/widgets/insights_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/insightmodel.dart';
import '../../models/soildata.dart';
import '../../models/vegetationdata.dart';
import '../../repositories/farmprovider.dart';
import '../../widgets/preview.dart';
import '../../helpers/soilhealthhelp.dart';

class Soil extends StatelessWidget {
  final void Function() onReset;
  Soil({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FarmProvider(),
      child: SoilHealth(onReset: onReset),
    );
  }
}

class SoilHealth extends StatefulWidget {
  final void Function() onReset;
  SoilHealth({super.key, required this.onReset});

  _SoilHealthState createState() => _SoilHealthState();
}

class _SoilHealthState extends State<SoilHealth> {
  List<String> crops = [];
  List<TrendData> trendData = [];
  List<Insight> insightList = [];
  InsightProvider insightProvider = InsightProvider(insightsList: []);
  Map<String, String> result = {};
  CropStage stage = CropStage('', DateTime.now());
  int _currentIndex = 0;
  int _selectedInsight = 0;
  String selectedField = "";
  String selectedCrop = "";
  int selectedIndex = 0;
  List<String> fields = [];
  List<CropField> cropFieldList = [];
  DateTime sowedDate =
      DateTime(2024, 5, 24); // sowed date should be from the data Rosan to do
  GlobalKey<FlipCardState> sowedCardKey = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> stageCardKey = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> harvestCardKey = GlobalKey<FlipCardState>();

  void trendingDecodeJson(trendData, trendingData) {
    var data = trendingData['trendData'];
    for (int i = 0; i < data.length; i++) {
      trendData.add(TrendData(
          date: data[i]['date'],
          mithranScore: data[i]['mithranScore'],
          message: data[i]['message']));
    }
    print(trendData[0].date);
  }

  void fieldDecodeJson(cropFieldList, fieldData) {
    for (int i = 0; i < fieldData.length; i++) {
      cropFieldList.add(CropField(
          polygonId: fieldData[i]['polygonId'],
          fieldName: fieldData[i]['fieldName'],
          fieldSize: double.parse(fieldData[i]['fieldSize']),
          location: fieldData[i]['location'],
          Crop: fieldData[i]['Crop'],
          latitude: fieldData[i]['currentLocation']['latitude'],
          longitude: fieldData[i]['currentLocation']['longitude'],
          sowedDate: DateTime.parse(fieldData[i]['sowedDate'])));
    }
  }

  void formFieldList() {
    for (int i = 0; i < cropFieldList.length; i++) {
      fields.add(cropFieldList[i].fieldName);
      crops.add(cropFieldList[i].Crop);
    }
    print(fields);
  }

  void _showFieldSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          fields: fields,
          crops: crops,
          selectedField: selectedField,
          onFieldSelected: (String field, String crop, int index) {
            setState(() {
              selectedField = field;
              selectedCrop = crop;
              selectedIndex = index;
              _selectedInsight = 0;
              fetchFarmData(
                  cropFieldList[selectedIndex].polygonId,
                  cropFieldList[selectedIndex].Crop,
                  cropFieldList[selectedIndex].latitude.toString(),
                  cropFieldList[selectedIndex].longitude.toString());
            });
          },
        );
      },
    );
  }

  static List<Map<String, dynamic>> fieldData = [
    {
      "polygonId": "66c1de28287b0e0f94fd16a9",
      "fieldName": "Rosan's Farm Field",
      "fieldSize": "6.34",
      "polygonLatLngs": [
        [12.753240558862867, 80.19547026604414],
        [12.753617595128063, 80.19684556871653],
        [12.752493351769175, 80.19731160253286],
        [12.75165425355935, 80.19599329680204],
        [12.753240558862867, 80.19547026604414]
      ],
      "location": "SSN Cricket Ground Road, Kalavakkam, Tamil Nadu, India",
      "currentLocation": {
        "longitude": 80.19634500145912,
        "latitude": 12.752739586998171
      },
      "Crop": "Wheat",
      "sowedDate": "2024-07-15",
    },
    {
      "polygonId": "66c57aed93997d119bbff7bd",
      "fieldName": "Resting Ground",
      "fieldSize": "3.75",
      "polygonLatLngs": [
        [27.019364245047697, 74.22480627894402],
        [27.02036183768475, 74.22499235719442],
        [27.020580470576324, 74.22630429267883],
        [27.019926960067338, 74.22672104090452],
        [27.019364245047697, 74.22480627894402]
      ],
      "location": "Unnamed Road, Nagaur, India",
      "currentLocation": {
        "longitude": 74.22576282173395,
        "latitude": 27.020771325990413
      },
      "Crop": "Tomato",
      "sowedDate": "2024-06-15",
    },
    {
      "polygonId": "66a13707402635077c2ecc1d",
      "fieldName": "Fertile Land",
      "fieldSize": "4.52",
      "polygonLatLngs": [
        [10.030366656318154, 77.93302059173584],
        [10.03119368508608, 77.93392583727837],
        [10.03055583314474, 77.9347700625658],
        [10.02947491554837, 77.93392583727837],
        [10.030366656318154, 77.93302059173584]
      ],
      "location": "Unnamed Road, Madurai, India",
      "currentLocation": {
        "longitude": 77.93423227965832,
        "latitude": 10.031848373427708
      },
      "Crop": "Wheat",
      "sowedDate": "2024-04-15",
    },
    {
      "polygonId": "66c5868293997d7031bff7bf",
      "fieldName": "Munaar Tea estate",
      "fieldSize": "4.00",
      "polygonLatLngs": [
        [10.087992788214203, 77.05236084759235],
        [10.087491707064084, 77.05230351537466],
        [10.087399280943309, 77.0538179576397],
        [10.088495849137962, 77.05432489514351],
        [10.087992788214203, 77.05236084759235]
      ],
      "location": "33Q4+C82, Munnar, India",
      "currentLocation": {
        "longitude": 77.05338075757027,
        "latitude": 10.087963740052883
      },
      "Crop": "Tea",
      "sowedDate": "2024-05-15",
    }
  ];

  Future<void> _initializeFieldData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing fieldDataList from SharedPreferences
    List<String>? savedFieldDataList = prefs.getStringList('fieldDataList');

    if (savedFieldDataList != null) {
      List savedFieldData = savedFieldDataList.map((jsonString) {
        return jsonDecode(jsonString);
      }).toList();

      setState(() {
        for (var newField in savedFieldData) {
          bool alreadyExists = fieldData
              .any((field) => field['polygonId'] == newField['polygonId']);
          if (!alreadyExists) {
            fieldData.add(newField);
            cropFieldList.clear();
            fieldDecodeJson(cropFieldList, fieldData);
            fields.clear();
            crops.clear();
            formFieldList();
          }
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFieldData();
  }

  String getCropStage(int daysSinceSowing, int harvestDays) {
    if (daysSinceSowing < harvestDays * 0.2) return "Germination";
    if (daysSinceSowing < harvestDays * 0.4) return "Vegetative";
    if (daysSinceSowing < harvestDays * 0.7) return "Flowering";
    if (daysSinceSowing < harvestDays) return "Fruiting";
    return "Harvest";
  }

  CropStage getCurrentStage(String crop, DateTime sowingDate) {
    final DateTime now = DateTime.now();
    final int harvestDays = cropHarvestDays[crop] ?? 100; // Default to 100 days
    final int daysSinceSowing = now.difference(sowingDate).inDays;

    String currentStage = getCropStage(daysSinceSowing, harvestDays);

    DateTime expectedHarvest = sowingDate.add(Duration(days: harvestDays));

    return CropStage(currentStage, expectedHarvest);
  }

  void updateActiveTab(String tabName) {
    switch (tabName) {
      case "Soil Health":
        setState(() {
          _selectedInsight = 0;
        });
      case "Vegetation":
        setState(() {
          _selectedInsight = 1;
        });
      case "Weather":
        setState(() {
          _selectedInsight = 2;
        });
    }
  }

  void formInsightList(soilInsights) {
    var insights = soilInsights["insights"];
    for (int i = 0; i < insights.length; i++) {
      insightList.add(Insight(
          condition: insights[i]["condition"],
          minSoilMoisture: insights[i]["soil_moisture_range"]["min"],
          maxSoilMoisture: insights[i]["soil_moisture_range"]["max"],
          minTemperatureGradient: insights[i]["temperature_gradient_range"]
              ["min"],
          maxTemperatureGradient: insights[i]["temperature_gradient_range"]
              ["max"],
          insight: insights[i]["insight"]));
    }
  }

  @override
  void initState() {
    super.initState();
    trendingDecodeJson(trendData, trendingData);
    print(fieldData);
    fieldDecodeJson(cropFieldList, fieldData);
    _initializeFieldData();
    formFieldList();
    formInsightList(soilInsights);
    selectedField = fields.first;
    selectedCrop = crops.first;
    stage =
        getCurrentStage(selectedCrop, cropFieldList[selectedIndex].sowedDate);
    print(stage);
    print(fieldData);
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!sowedCardKey.currentState!.isFront) {
        sowedCardKey.currentState!.toggleCard();
      }
      if (!stageCardKey.currentState!.isFront) {
        stageCardKey.currentState!.toggleCard();
      }
      if (!harvestCardKey.currentState!.isFront) {
        harvestCardKey.currentState!.toggleCard();
      }
    });
    final dataProvider = Provider.of<FarmProvider>(context, listen: false);
    dataProvider.fetchSoilData(
        cropFieldList[selectedIndex].polygonId,
        selectedCrop,
        cropFieldList[selectedIndex].latitude.toString(),
        cropFieldList[selectedIndex].longitude.toString());
  }

  void fetchFarmData(String polygonId, String selectedCrop, String latitude,
      String longitude) {
    final dataProvider = Provider.of<FarmProvider>(context, listen: false);
    dataProvider.fetchSoilData(polygonId, selectedCrop, latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<FarmProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40),
              onPressed: () {
                widget.onReset();
              }),
        ),
        titleSpacing: 0,
        title: Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              overlayColor: Colors.white,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0, // No shadow
            ),
            onPressed: _showFieldSelectionBottomSheet,
            child: Row(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        !fields.isEmpty ? selectedField : "Select Field",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                          color: !fields.isEmpty
                              ? Colors.black
                              : Colors.grey[600]!,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(selectedCrop,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FertilizerCalculator(
                        fieldSize: cropFieldList[selectedIndex].fieldSize,
                        sowedDate: DateFormat("d'th' MMM yyyy")
                            .format(cropFieldList[selectedIndex].sowedDate),
                        crop: cropFieldList[selectedIndex].Crop)),
              );
            },
            child: Image.asset("assets/cropexpense/Fertilizer.png",
                height: 20.0, width: 20.0),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DigitalTwinPage(
                          crop: selectedCrop,
                          currentStage: stage.stage,
                          expectedHarvestDate: DateFormat("d'th' MMM yyyy")
                              .format(stage.expectedHarvest),
                          sowedDate: DateFormat("d'th' MMM yyyy")
                              .format(cropFieldList[selectedIndex].sowedDate),
                        )),
              );
            },
            child: Image.asset("assets/planting/navbaricon1.png",
                height: 20.0, width: 20.0),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LeafHealth(
                          polygonId: "",
                        )),
              );
            },
            child: Image.asset("assets/planting/navbaricon2.png",
                height: 20.0, width: 20.0),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: Colors.grey[400]!, width: 1.25)),
                  child: Column(children: [
                    Container(
                        child: MapPreview(
                      latitude: cropFieldList[selectedIndex].latitude,
                      longitude: cropFieldList[selectedIndex].longitude,
                      place: cropFieldList[selectedIndex].location,
                    )),
                    const SizedBox(height: 15.0),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Virtual Farm",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Text(
                                "Unlock Precision Farming with Satellite Insights",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 10.0, top: 7.0, bottom: 7.0),
                            decoration: BoxDecoration(
                              color: Color(0xffFFCEF1),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Edit",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                    )),
                                const SizedBox(width: 10.0),
                                Image.asset("assets/planting/edit.png",
                                    height: 20.0, width: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffF0F2DD),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Image.asset("assets/planting/acres.png",
                                    height: 20.0, width: 20.0),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "${cropFieldList[selectedIndex].fieldSize} acres",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Container(
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffF0F2DD),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Image.asset("assets/planting/crop.png",
                                    height: 20.0, width: 20.0),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "${cropFieldList[selectedIndex].Crop}",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlipCard(
                            key: sowedCardKey,
                            direction: FlipDirection.HORIZONTAL,
                            front: Container(
                              width: 115.0,
                              height: 50.0,
                              padding: EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffFFC7B4),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  "Sowed at",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            back: Container(
                              width: 115.0,
                              height: 50.0,
                              padding: EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffFFC7B4),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "${DateFormat("d'th' MMM yyyy").format(cropFieldList[selectedIndex].sowedDate)}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                    color: Color(0xff5D5D5D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlipCard(
                            key: stageCardKey,
                            direction: FlipDirection.HORIZONTAL,
                            front: Container(
                              height: 50.0,
                              width: 115.0,
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffFFE9A2),
                              ),
                              child: const Text(
                                "Current Stage",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            back: Container(
                              width: 115.0,
                              height: 50.0,
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffFFE9A2),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "${stage.stage}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                    color: Color(0xff5D5D5D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlipCard(
                            key: harvestCardKey,
                            direction: FlipDirection.HORIZONTAL,
                            front: Container(
                              width: 115.0,
                              height: 50.0,
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffD2FFCE),
                              ),
                              child: const Text(
                                "Expected Harvest",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            back: Container(
                              width: 115.0,
                              height: 50.0,
                              padding: EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffD2FFCE),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "${DateFormat("d'th' MMM yyyy").format(stage.expectedHarvest)}",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                        color: Color(0xff5D5D5D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ]),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Farm Insights Today",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child:
                    Text("Track Soil, Weather, and Crop Growth in Real - Time",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        )),
              ),
              const SizedBox(height: 10.0),
              !dataProvider.isLoading
                  ? GraphComponent(
                      updateActiveTab: updateActiveTab,
                      soilData: SoilData(
                          date: dataProvider.farmData['date'],
                          moisture: dataProvider.farmData['moisture'],
                          temperatureGradient: calculateTemperatureGradient(
                              dataProvider.farmData['t0'],
                              dataProvider.farmData['t10'])),
                      vegetationData: VegetationData(
                          date: dataProvider.vegetationData['date'],
                          growthRate: dataProvider.vegetationData['ndvi'],
                          healthIndex:
                              dataProvider.vegetationData['mithranScore']),
                      weatherData: dataProvider.weatherDataList)
                  : Container(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Shimmer.fromColors(
                        highlightColor: Colors.grey[100]!,
                        baseColor: Colors.grey[300]!,
                        child: Container(
                          color: Colors.grey[100],
                          height: 300,
                        ),
                      ),
                    ),
              const SizedBox(height: 10.0),
              !dataProvider.isLoading
                  ? Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                        padding: EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffD2D5DA),
                            width: 2.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _selectedInsight == 0
                                    ? Color(0xffFFEBC6)
                                    : _selectedInsight == 1
                                        ? Color(0xffDEF9D3)
                                        : Color(0xffC7E6FF),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset("assets/planting/health.png",
                                        height: 25.0, width: 25.0),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Condition",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Container(
                                          width: 275.0,
                                          child: Text(
                                            _selectedInsight == 0
                                                ? "${insightProvider.findInsight(dataProvider.farmData['moisture'], calculateTemperatureGradient(dataProvider.farmData['t0'], dataProvider.farmData['t10']))["Condition"]}"
                                                : _selectedInsight == 1
                                                    ? "${dataProvider.vegetationData["condition"]}"
                                                    : "${dataProvider.weatherData["condition"]}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: _selectedInsight == 0
                                          ? Color(0xffFFEBC6)
                                          : _selectedInsight == 1
                                              ? Color(0xffDEF9D3)
                                              : Color(0xffC7E6FF),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                                "assets/planting/presention-chart.png",
                                                height: 25.0,
                                                width: 25.0),
                                          ],
                                        ),
                                        const SizedBox(width: 5.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Insights",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(
                                              width: 190.0,
                                              height: 117.0,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  _selectedInsight == 0
                                                      ? "${insightProvider.findInsight(dataProvider.farmData['moisture'], calculateTemperatureGradient(dataProvider.farmData['t0'], dataProvider.farmData['t10']))["Insight"]}"
                                                      : _selectedInsight == 1
                                                          ? "${dataProvider.vegetationData["message"]}"
                                                          : "${dataProvider.weatherData["message"]}",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100.0,
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: BoxDecoration(
                                          color: _selectedInsight == 0
                                              ? Color(0xffFFEBC6)
                                              : _selectedInsight == 1
                                                  ? Color(0xffDEF9D3)
                                                  : Color(0xffC7E6FF),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                _selectedInsight == 0
                                                    ? "assets/planting/moisture.png"
                                                    : _selectedInsight == 1
                                                        ? "assets/planting/mithranscore.png"
                                                        : "assets/planting/rain.png",
                                                height: 25.0,
                                                width: 25.0),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              _selectedInsight == 0
                                                  ? "Moisture"
                                                  : _selectedInsight == 1
                                                      ? "Mithran Score"
                                                      : "Rain",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              _selectedInsight == 0
                                                  ? "${double.parse(dataProvider.farmData['moisture'].toString()).toStringAsFixed(2)} m³/m³"
                                                  : _selectedInsight == 1
                                                      ? "${double.parse(dataProvider.vegetationData["mithranScore"].toString()).toStringAsFixed(2)}"
                                                      : double.parse(
                                                              dataProvider
                                                                  .weatherData[
                                                                      "rain"]
                                                                  .toString())
                                                          .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.0,
                                                color: _selectedInsight == 0
                                                    ? Color.fromARGB(
                                                        255, 232, 138, 6)
                                                    : _selectedInsight == 1
                                                        ? Color.fromARGB(
                                                            255, 0, 207, 21)
                                                        : Colors.blue,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Container(
                                        width: 100.0,
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: BoxDecoration(
                                          color: _selectedInsight == 0
                                              ? Color(0xffFFEBC6)
                                              : _selectedInsight == 1
                                                  ? Color(0xffDEF9D3)
                                                  : Color(0xffC7E6FF),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                _selectedInsight == 0
                                                    ? "assets/planting/temp.png"
                                                    : _selectedInsight == 1
                                                        ? "assets/planting/ndvi.png"
                                                        : "assets/planting/pressure.png",
                                                height: 25.0,
                                                width: 25.0),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              _selectedInsight == 0
                                                  ? "Temp Gradient"
                                                  : _selectedInsight == 1
                                                      ? "NDVI Aggre."
                                                      : "Pressure",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              _selectedInsight == 0
                                                  ? "${calculateTemperatureGradient(dataProvider.farmData['t0'], dataProvider.farmData['t10']).toStringAsFixed(2)}"
                                                  : _selectedInsight == 1
                                                      ? "${double.parse(dataProvider.vegetationData['ndvi'].toString()).toStringAsFixed(2)}"
                                                      : "${dataProvider.weatherData["pressure"]} hPa",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.0,
                                                color: _selectedInsight == 0
                                                    ? Color.fromARGB(
                                                        255, 230, 90, 35)
                                                    : _selectedInsight == 1
                                                        ? Color.fromARGB(
                                                            255, 8, 114, 12)
                                                        : Color.fromARGB(
                                                            255, 31, 179, 242),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Shimmer.fromColors(
                        highlightColor: Colors.grey[100]!,
                        baseColor: Colors.grey[300]!,
                        child: Container(
                          color: Colors.grey[100],
                          height: 300,
                        ),
                      ),
                    ),
              Stack(children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 160.0,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FertilizerCalculator(
                                      fieldSize: cropFieldList[selectedIndex]
                                          .fieldSize,
                                      sowedDate: DateFormat("d'th' MMM yyyy")
                                          .format(cropFieldList[selectedIndex]
                                              .sowedDate),
                                      crop: cropFieldList[selectedIndex].Crop,
                                    )));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Image.asset(
                          "assets/planting/carosuelimage1.png",
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DigitalTwinPage(
                                    crop: selectedCrop,
                                    currentStage: stage.stage,
                                    expectedHarvestDate:
                                        DateFormat("d'th' MMM yyyy")
                                            .format(stage.expectedHarvest),
                                    sowedDate: DateFormat("d'th' MMM yyyy")
                                        .format(cropFieldList[selectedIndex]
                                            .sowedDate),
                                  )),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Image.asset(
                          "assets/planting/carosuelimage2.png",
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LeafHealth(polygonId: "")));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Image.asset(
                          "assets/planting/carosuelimage3.png",
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20.0,
                  left: 185.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                )
              ]),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  final List<String> fields;
  final List<String> crops;
  final String selectedField;
  final void Function(String field, String crop, int index) onFieldSelected;

  BottomSheet({
    required this.fields,
    required this.crops,
    required this.selectedField,
    required this.onFieldSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.44 * MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text(
                'Select Field',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                  itemCount: fields.length,
                  itemBuilder: (context, index) {
                    String field = fields[index];
                    bool isSelected = field == selectedField;
                    return Container(
                      color: isSelected ? Color(0xffE5F3FE) : Colors.white,
                      child: ListTile(
                        title: Text(
                          fields[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          crops[index],
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check,
                                color: Color(0xff4A85D1), size: 30.0)
                            : null,
                        onTap: () {
                          onFieldSelected(fields[index], crops[index], index);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FieldLocator()),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.add, size: 30.0, color: Colors.blue),
                    const SizedBox(width: 20.0),
                    const Text("Add field",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
