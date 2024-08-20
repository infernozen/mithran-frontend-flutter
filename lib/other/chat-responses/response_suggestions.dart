import 'package:flutter/material.dart';
import 'package:mithran/other/chatmodel.dart';
import 'package:mithran/other/google_api_service.dart';
import '../animated_box.dart';
import '../gradient_border.dart';

class ResponseWithSuggestions extends StatefulWidget {
  const ResponseWithSuggestions({
    super.key,
    required this.index,
    required this.text,
    required this.list,
    required this.onListChanged,
    required this.suggestions
  });

  final int? index;
  final String? text;
  final List<ChatModel>? list;
  final Function(List<ChatModel>)? onListChanged;
  final List<String>? suggestions;

  @override
  _ResponseWithSuggestionsState createState() =>
      _ResponseWithSuggestionsState();
}

class _ResponseWithSuggestionsState extends State<ResponseWithSuggestions> {
  bool _buttonsDisabled = false;
  final ApiService _apiService = ApiService();

  Future<void> _getResponse(String text)async {
    final ChatModel response = await _apiService.queryDialogflow(text , '1234');
    response.list = widget.list!;
    response.index = widget.list!.length-1;
    response.onListChanged = widget.onListChanged;
    widget.list!.insert(widget.list!.length-1 , response);
    widget.onListChanged!(widget.list!);
  }

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
                future: Future.delayed(
                  const Duration(seconds: 2),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AnimatedBox();
                  } else {
                    return Container(
                      width: maxWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF000000),
                            Color(0xFF575757),
                          ],
                        ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.text!,
                            style: const TextStyle(
                              color: Colors.white,
                              // wordSpacing: 2,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 51.0 * widget.suggestions!.length,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.suggestions!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _buttonsDisabled
                                        ? null
                                        : () {
                                            setState(() {
                                              _buttonsDisabled = true;
                                            });
                                            widget.list!.insert(widget.list!.length -1,
                                              ChatModel(
                                                type: 'user_text',
                                                text:
                                                    widget.suggestions![index],
                                                isUser: true,
                                              ),
                                            );
                                            if (widget.onListChanged !=
                                                null) {
                                              widget.onListChanged!(widget.list!);
                                              _getResponse(widget.suggestions![index]);
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                      fixedSize: Size.fromWidth(
                                        MediaQuery.of(context).size.width *
                                            0.2,
                                      ),
                                      backgroundColor: Colors.white,
                                      disabledBackgroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      widget.suggestions![index],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            } else {
              return Container(
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
                      transform: GradientRotation(0),
                    ),
                    width: 2.5,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.text!,
                      style: const TextStyle(
                        // wordSpacing: 2,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 51.0 * widget.suggestions!.length,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.suggestions!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                            ),
                            child: ElevatedButton(
                              onPressed: _buttonsDisabled
                                  ? null
                                  : () {
                                      setState(() {
                                        _buttonsDisabled = true;
                                      });
                                      widget.list!.insert(widget.list!.length -1,
                                        ChatModel(
                                          type: 'user_text',
                                          text: widget.suggestions![index],
                                          isUser: true
                                        ),
                                      );
                                      if (widget.onListChanged != null) {
                                        widget.onListChanged!(widget.list!);
                                        _getResponse(widget.suggestions![index]);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width * 0.2,
                                ),
                                backgroundColor: Colors.white,
                                disabledBackgroundColor: const Color.fromARGB(190, 255, 255, 255)
                              ),
                              child: Text(
                                widget.suggestions![index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
