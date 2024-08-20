import 'package:flutter/material.dart';
import 'package:mithran/screen/plantix-section/camera.dart';

class InitScan extends StatelessWidget {
  InitScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  const SizedBox(height: 15.0),
                  Image.asset("assets/homepage/dryleaf.png",
                      height: 40.0, width: 40.0),
                  const SizedBox(height: 10.0),
                  Text(
                    "Take a pic",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Image.asset("assets/homepage/arrow.png",
                  alignment: Alignment.topCenter, height: 40.0, width: 40.0),
              Column(
                children: [
                  const SizedBox(height: 15.0),
                  Image.asset("assets/homepage/tablet.png",
                      height: 40.0, width: 40.0),
                  const SizedBox(height: 10.0),
                  Text(
                    "See Diagnosis",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Image.asset("assets/homepage/arrow.png",
                  alignment: Alignment.topCenter, height: 40.0, width: 40.0),
              Column(
                children: [
                  const SizedBox(height: 15.0),
                  Image.asset("assets/homepage/fertilizer.png",
                      height: 40.0, width: 40.0),
                  const SizedBox(height: 10.0),
                  Text(
                    "Get Meds",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraComponent()),
              );
            },
            child: Container(
              width: 255.0,
              padding: EdgeInsets.only(
                top: 7.0,
                bottom: 7.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xff0158DB),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text(
                "Initiate Scan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 13.0),
                child: Text("Powered by",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 11,
                    )),
              ),
              const SizedBox(width: 10.0),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Image.asset("assets/homepage/plantix.png",
                    height: 30.0, width: 30.0),
              ),
              const SizedBox(width: 10.0),
            ],
          ),
        ],
      ),
    );
  }
}
