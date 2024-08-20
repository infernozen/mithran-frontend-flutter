import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class LeafHealthDisplay extends StatefulWidget {
  final double greenScore;
  const LeafHealthDisplay({super.key, required this.greenScore});
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
            icon: Icon(Icons.close), // Use the close icon
            onPressed: () {
              Navigator.of(context).pop(); // Go back or close the screen
            },
          ),
          title: Text("Digital Leaf Color Chart",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
              )),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Container(
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
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
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
                          const SizedBox(width: 30.0),
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
                      const SizedBox(height: 40.0),
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
                  onPressed: () => {},
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
