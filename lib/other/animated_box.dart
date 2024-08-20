import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedBox extends StatefulWidget {
  @override
  _AnimatedBoxState createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  // Final width of the box (70% of the screen width)
  double finalWidth = 0.0;

  // Animation duration
  Duration animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        setState(() {
          finalWidth = MediaQuery.of(context).size.width * 0.6;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: animationDuration,
          width: finalWidth,
          height: 20, // Adjust height as needed
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Shimmer.fromColors(
            highlightColor: Colors.blue[200]!,
            baseColor: Colors.grey,
            child: Container(
              width: double.infinity,
              height: 20, // Adjust height as needed
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 10), // Adjust spacing between boxes
        _buildBotResponseShimmerEffect(
          duration: const Duration(milliseconds: 600),
          width: finalWidth,
        ),
        const SizedBox(height: 10), // Adjust spacing between boxes
        _buildBotResponseShimmerEffect(
          duration: const Duration(milliseconds: 800),
          width: finalWidth * 0.5,
        ),
        const SizedBox(height: 100)
      ],
    );
  }

  Widget _buildBotResponseShimmerEffect({
    required Duration duration,
    required double width,
  }) {
    // This FutureBuilder will only display the shimmering effect for bot responses
    return FutureBuilder(
      future: Future.delayed(duration),
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: animationDuration,
          width: width,
          height: 20, // Adjust height as needed
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Shimmer.fromColors(
            highlightColor: Colors.blue[200]!,
            baseColor: Colors.grey,
            child: Container(
              width: double.infinity,
              height: 20, // Adjust height as needed
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
