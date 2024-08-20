import 'package:flutter/material.dart';
import 'package:mithran/other/chatmodel.dart';
import 'package:mithran/other/gradient_border.dart';

import '../animated_box.dart';

// ignore: must_be_immutable
class ImageWithText extends StatefulWidget {
  const ImageWithText({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.index,
    required this.list,
  });

  final String? text;
  final int? index;
  final List<ChatModel>? list;
  final String? imageUrl;

  @override
  _ImageWithTextState createState() =>
      _ImageWithTextState();
}

class _ImageWithTextState extends State<ImageWithText> {
  bool _isFullScreen = false;
  bool isShimmer = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth * 0.7;
            if (widget.list![widget.index!].isShimmer == false) {
              widget.list![widget.index!].isShimmer = true;
              return FutureBuilder<void>(
                future: Future.delayed(const Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      isShimmer) {
                    return AnimatedBox();
                  } else {
                    return Stack(
                      children: [
                        Container(
                          width: maxWidth,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF000000),
                                Color(0xFF575757),
                              ],
                            ),
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
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                widget.text!,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: _isFullScreen
                                      ? Colors.transparent
                                      : Colors.white,
                                  //wordSpacing: 2,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), 
                                    child: AspectRatio(
                                      aspectRatio: 16 / 10,
                                      child: !_isFullScreen
                                          ? Image.network(
                                              widget.imageUrl!,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: Colors.black.withOpacity(
                                                    0.5), 
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    right: 0.0,
                                    child: IconButton(
                                      icon: const Icon(Icons.zoom_out_map),
                                      onPressed: () {
                                        setState(() {
                                          _isFullScreen = !_isFullScreen;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        if (_isFullScreen)
                          Padding(
                            padding: const EdgeInsets.only(top: 40, left: 25),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10.0),
                                      child: AspectRatio(
                                        aspectRatio: 16 /
                                            10, 
                                        child: Image.network(
                                          widget.imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.zoom_in_map_outlined),
                                        onPressed: () {
                                          setState(() {
                                            _isFullScreen = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
              );
            } else {
              return Stack(
                children: [
                  Container(
                    width: maxWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF000000),
                          Color(0xFF575757),
                        ],
                      ),
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
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          widget.text!,
                          style: TextStyle(
                            color: _isFullScreen
                                ? Colors.transparent
                                : Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            //wordSpacing: 2,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: !_isFullScreen
                                    ? Image.network(
                                        widget.imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.black.withOpacity(
                                              0.5), 
                                        ),
                                      ),
                              ),
                            ),
                            if (!_isFullScreen)
                              Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: IconButton(
                                  icon: const Icon(Icons.zoom_out_map),
                                  onPressed: () {
                                    setState(() {
                                      _isFullScreen = !_isFullScreen;
                                    });
                                  },
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (_isFullScreen)
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 25),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10.0),
                                child: AspectRatio(
                                  aspectRatio:
                                      16 / 10, 
                                  child: Image.network(
                                    widget.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.zoom_in_map_outlined),
                                  onPressed: () {
                                    setState(() {
                                      _isFullScreen = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
