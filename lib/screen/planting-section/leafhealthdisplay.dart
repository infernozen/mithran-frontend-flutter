import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:mithran/screen/init_page.dart';

class LeafHealthDisplay extends StatefulWidget {
  final Function(int value) addNewReading;
  final double greenScore;
  const LeafHealthDisplay(
      {super.key, required this.greenScore, required this.addNewReading});
  _LeafHealthDisplayState createState() => _LeafHealthDisplayState();
}

class _LeafHealthDisplayState extends State<LeafHealthDisplay> {
  List<Color> leafColorIndicator = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.green[400]!
  ];
  List<double> leafColorStops = [0.2, 0.4, 0.6, 0.8, 1.0];
  @override
  Widget build(BuildContext context) {
    print(widget.greenScore);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("Nitro Rating",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              )),
          elevation: 2,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          titleSpacing: 0,
        ),
        backgroundColor: Color(0xffF6F5F3),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: const Color(0xffD2D5DA),
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 160.0,
                        width: 160.0,
                        child: KdGaugeView(
                          minSpeed: 0,
                          maxSpeed: 5,
                          speed: widget.greenScore,
                          animate: true,
                          duration: Duration(seconds: 3),
                          fractionDigits: 1,
                          unitOfMeasurement: " ",
                          innerCirclePadding: 20.0,
                          subDivisionCircleColors: Colors.transparent,
                          divisionCircleColors: Colors.transparent,
                          baseGaugeColor: Colors.white,
                          minMaxTextStyle: TextStyle(color: Colors.white),
                          speedTextStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 40.0,
                          ),
                          alertColorArray: [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.lightGreen,
                            Colors.green,
                          ],
                          alertSpeedArray: [1, 2, 3, 4, 5],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Your crop has sufficient Nitrogen",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Please check again in 7 days.",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Crop Advice",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    )),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffD2D5DA),
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Image.asset(
                              "assets/cropexpense/Fertilizer.png",
                              height: 30.0,
                              width: 30.0,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Container(
                            width: 225.0,
                            child: Text(
                              "No nitrogen application is required.",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0),
                        child: Text(
                          "Recommended by IRRI",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () => {
                        widget.addNewReading(widget.greenScore.toInt()),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InitPage(index: 1),
                          ),
                        )
                      },
                  child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Color(0xff0055B8),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(
                              0xff0055B8), // Change to your desired border color
                          width: 1.5, // Change to your desired border width
                        ),
                      ),
                      child: Text(
                        "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700),
                      ))),
              const SizedBox(height: 10.0),
            ],
          ),
        ));
  }
}
