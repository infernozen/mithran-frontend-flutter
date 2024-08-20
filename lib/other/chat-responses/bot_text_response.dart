import 'package:flutter/material.dart';
import 'package:mithran/other/calculatewidth.dart';
import 'package:mithran/other/chatmodel.dart';
import 'package:mithran/other/gradient_border.dart';
import '../animated_box.dart';

// ignore: must_be_immutable
class BotWidget extends StatelessWidget {
  BotWidget({
    super.key,
    required this.text,
    required this.index,
    required this.list,
  });
  String? text;
  bool showshimmer = false;
  int? index;
  List<ChatModel>? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth * 0.7;
            if (list![index!].isShimmer == false) {
              list![index!].isShimmer = true;
              return FutureBuilder<void>(
                future: Future.delayed(const Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AnimatedBox();
                  } else {
                    return Container(
                        width: maxWidth !=
                                calculateContainerWidth(
                                    context, maxWidth, text!)
                            ? null
                            : 350,
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
                        child: DynamicRichText(textContent: text!));
                  }
                },
              );
            } else {
              return Container(
                  width: maxWidth !=
                          calculateContainerWidth(context, maxWidth, text!)
                      ? null
                      : 350,
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
                  child: DynamicRichText(textContent: text!));
            }
          },
        ),
      ),
    );
  }
}

class DynamicRichText extends StatelessWidget {
  final String textContent;

  DynamicRichText({required this.textContent});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = parseTextToSpans(textContent);
    return RichText(
      text: TextSpan(
        style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
        children: textSpans,
      ),
    );
  }

  List<TextSpan> parseTextToSpans(String content) {
    List<TextSpan> spans = [];
    List<String> lines = content.split('\n');

    for (String line in lines) {
      line = line.trim();

      // Remove unnecessary symbols
      line = line.replaceAll('**', '');
      line = line.replaceAll('*', '•');

      // Handle headings and bold sections
      if (line.startsWith('1.') || line.startsWith('2.')) {
        spans.add(TextSpan(
          text: line + '\n\n',
          style: TextStyle(fontWeight: FontWeight.w700),
        ));
      } else if (line.contains(':')) {
        int colonIndex = line.indexOf(':');
        spans.add(TextSpan(
          text: line.substring(0, colonIndex + 1).trim(),
          style: TextStyle(fontWeight: FontWeight.w700),
        ));
        spans.add(TextSpan(
          text: ' ' + line.substring(colonIndex + 1).trim() + '\n\n',
        ));
      } else if (line.isNotEmpty) {
        spans.add(TextSpan(
          text: line + '\n\n',
        ));
      }
    }

    return spans;
  }
}
