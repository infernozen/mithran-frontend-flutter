import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  failure,
  warning,
  networkError
}

SnackBar buildCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.success,
  Color iconColor = Colors.green,
  Color backgroundColor = Colors.black,
  Duration duration = const Duration(seconds: 3),
}) {
  IconData iconData;
  switch (type) {
    case SnackBarType.success:
      iconData = Icons.check_circle;
      break;
    case SnackBarType.failure:
      iconData = Icons.remove_circle_outline_rounded;
      iconColor = Colors.red;
      break;
    case SnackBarType.warning:
      iconData = Icons.error_outline;
      iconColor = Colors.yellowAccent[700]!;
      break;
    case SnackBarType.networkError:
      iconData = Icons.network_check_sharp;
      iconColor = Colors.green;
      break;
  }

  return SnackBar(
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    duration: duration,
    content: Row(
      children: [
        Icon(iconData, color: iconColor),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}
