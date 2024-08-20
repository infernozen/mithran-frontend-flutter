import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mithran/models/leafreading.dart';
import 'package:mithran/widgets/camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeafHealth extends StatefulWidget {
  final String polygonId;
  LeafHealth({super.key, required this.polygonId});
  _LeafHealthState createState() => _LeafHealthState();
}

class _LeafHealthState extends State<LeafHealth> {
  DateTime now = DateTime.now();
  List<LeafReading> readings = [];

  @override
  void initState() {
    super.initState();
    loadReadings();
  }

  Future<void> loadReadings() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(widget.polygonId);

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      readings = jsonList.map((json) => LeafReading.fromJson(json)).toList();
      print("Loading State");
      for (int i = 0; i < readings.length; i++) {
        print(readings[i].greennessScore);
      }
    } else {
      // Initialize with an empty list if no readings are found for the polygonId
      readings = [];
      await saveReadings(); // Save this empty list to SharedPreferences
    }

    setState(() {}); // Refresh the UI
  }

  Future<void> saveReading(LeafReading reading) async {
    readings.add(reading);
    if (readings.length > 5) {
      readings.removeAt(0);
    } else {
      readings.add(reading);
    }
    print("Saving State");
    for (int i = 0; i < readings.length; i++) {
      print(readings[i].greennessScore);
    }

    await saveReadings();

    setState(() {}); // Refresh the UI
  }

  Future<void> saveReadings() async {
    List<Map<String, dynamic>> jsonList =
        readings.map((reading) => reading.toJson()).toList();
    String jsonString = jsonEncode(jsonList);
    print(jsonString);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.polygonId, jsonString);
  }

  void addNewReading(int greenScore) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("d'th' MMM yyyy").format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    LeafReading newReading = LeafReading(
      date: formattedDate,
      time: formattedTime,
      greennessScore: greenScore,
    );

    saveReading(newReading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: Text(
          "Leaf Health Monitor",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 2,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      backgroundColor: Color(0xffF6F5F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xffD2D5DA),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/planting/leaf1.png",
                            height: 100, width: 100),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                        child: Text(
                      "Nitro Lens",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    const SizedBox(height: 15.0),
                    Container(
                        padding: EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Text(
                          "Analyze your Nitrogen Levels instantly with just an Image",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraComponent(
                                    addNewReading: addNewReading)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add,
                              color: Color.fromARGB(255, 52, 154, 19)),
                          const SizedBox(width: 15.0),
                          const Text("New Reading",
                              style: TextStyle(
                                color: Color.fromARGB(255, 52, 154, 19),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Lottie.asset(
                                'assets/animations/Plant.json',
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Container(
                              width: 195.0,
                              child: Text.rich(
                                textAlign: TextAlign.start,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Regularly measuring ",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Nitrogen",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700, // Bold
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " level helps to increase the yield by ",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "27%",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700, // Bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: " and save cost up to ",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "43%",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700, // Bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            if (readings.length > 0)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: const Text("Past Readings",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    )),
              ),
            const SizedBox(height: 10.0),
            Container(
              height: 270,
              child: ListView.builder(
                  itemCount: readings.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              // color: Colors.blue,
                              child: Stack(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (rect) {
                                      return SweepGradient(
                                          startAngle: 0.0,
                                          endAngle: 2 * 3.14,
                                          stops: [0, 0.2, 0.4, 0.6, 0.8],
                                          center: Alignment.center,
                                          colors: [
                                            Colors.red,
                                            Colors.orange,
                                            Colors.yellow,
                                            Colors.green,
                                            Colors.white,
                                          ]).createShader(rect);
                                    },
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey, width: 0.25),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey, width: 0.25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${readings[index].greennessScore}",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 25.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${readings[index].date} , ${readings[index].time}",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text("Your crop is deficient in Nitrogen.",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
