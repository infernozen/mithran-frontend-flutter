import 'package:flutter/material.dart';
import 'package:mithran/screen/plantix-section/camera.dart';

class InitScan extends StatelessWidget {
  InitScan({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              // Row for icons and text with flexible scaling
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceAround, // Change to spaceAround for even spacing
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center the icons and text
                children: [
                  _buildIconColumn("assets/homepage/dryleaf.png", "Take a pic"),
                  _buildArrow(),
                  _buildIconColumn(
                      "assets/homepage/tablet.png", "See\nDiagnosis"),
                  _buildArrow(),
                  _buildIconColumn(
                      "assets/homepage/fertilizer.png", "Get Meds"),
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
                  padding: EdgeInsets.symmetric(vertical: 7.0),
                  decoration: BoxDecoration(
                    color: Color(0xff3E84CA),
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
      },
    );
  }

  // Helper method to build an icon column
  Widget _buildIconColumn(String assetPath, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure it only takes necessary height
      children: [
        const SizedBox(height: 15.0),
        FittedBox(
          child: Image.asset(
            assetPath,
            height: 40.0,
            width: 40.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          text,
          textAlign: TextAlign.center, // Center align text
          style: TextStyle(
            color: Colors.grey,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper method to build the arrow icon
  Widget _buildArrow() {
    return FittedBox(
      child: Image.asset(
        "assets/homepage/arrow.png",
        height: 40.0,
        width: 40.0,
      ),
    );
  }
}
