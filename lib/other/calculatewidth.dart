import 'package:flutter/material.dart';

double calculateContainerWidth(
    BuildContext context, double maxWidth, String text) {
  // Get the text size
  TextSpan span = TextSpan(
    text: text,
    style: const TextStyle(fontSize: 17.0),
  );
  TextPainter tp = TextPainter(
    text: span,
    textDirection: TextDirection.ltr,
    maxLines: null,
  );
  tp.layout();

  double textWidth = tp.size.width;

  // Check if the text width exceeds the maximum width
  if (textWidth <= maxWidth) {
    return textWidth; // If within limits, return the text width
  } else {
    return maxWidth; // Otherwise, return the maximum width
  }
}
