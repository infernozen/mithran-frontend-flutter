import 'package:flutter/material.dart';
import 'package:mithran/other/chat-responses/bot_text_response.dart';
import 'package:mithran/other/chat-responses/image_with_text.dart';
import 'package:mithran/other/chat-responses/response_suggestions.dart';
import 'package:mithran/other/chat-responses/user_text_response.dart';

// ignore: must_be_immutable
class ChatModel extends StatelessWidget {
  

  ChatModel({
    super.key,
    required this.type,
    required this.isUser,

    this.text,
    this.onListChanged,
    this.index,
    this.date,
    this.list,
    this.isImageText,
    this.name,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.buttontext,
    this.buttonurl,
    this.suggestions,
    this.product,
    this.destination
  });


  final String type;
  final bool isUser;
  bool isShimmer = false;
  int? index;
  List<ChatModel>? list;
  Function(List<ChatModel>)? onListChanged;
  String? destination;

  final Map<String, dynamic>? product;
  final List<String>? suggestions;
  final String? date;
  final String? text;
  final bool? isImageText;
  final String? name;
  final String? title, subtitle, imageUrl, buttontext, buttonurl;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "show_date":
        return Center(
        heightFactor: 1.5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            date!,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      );
 
      case "text_with_image":
        return ImageWithText(
          text: text,
          imageUrl: imageUrl!,
          index: index, 
          list: list, 
        );

      case "text_with_suggestions":
        return ResponseWithSuggestions(
          text: text,
          index: index,
          list: list,
          suggestions: suggestions, 
          onListChanged: onListChanged,
        );

      case "user_text":
        return UserWidget(
          text: text
        );

      case "end_space":
        return const SizedBox(height: 80);

      default:
        return BotWidget(
          text: text,
          index: index,
          list: list,
        );
    }
  }
}
