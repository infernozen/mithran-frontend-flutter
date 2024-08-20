import 'package:flutter/material.dart';
import 'package:mithran/other/calculatewidth.dart';
import 'package:mithran/other/gradient_border.dart';

// ignore: must_be_immutable
class UserWidget extends StatelessWidget {
  UserWidget({super.key, required this.text});
  String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double maxWidth =
                constraints.maxWidth * 0.7; // 70% of the available width
            return Container(
              width:
                  maxWidth != calculateContainerWidth(context, maxWidth, text!)
                      ? null
                      : maxWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: const GradientBorder(
                  borderGradient: LinearGradient(
                    colors: [
                        Color(0xFFAC4949),
                        Color(0xFFD95358),
                        Color(0xFFD35568),
                        Color(0xFFCA665E),
                        Color(0xFFDAD767),
                        Color(0xFF588DD3),
                        Color(0xFF525CD3),
                        Color(0xFFBB66CC),
                    ],
                    tileMode: TileMode.repeated,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.0005,
                      0.0534,
                      0.2153,
                      0.4051,
                      0.5749,
                      0.7497,
                      0.8346,
                      0.9995,
                    ],
                    transform: GradientRotation(0.0),
                  ),
                  width: 2.5,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                text!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
