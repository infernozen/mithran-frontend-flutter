import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mithran/other/animated_gradient_box.dart';
import 'package:mithran/other/chatmodel.dart';
import 'package:mithran/other/google_api_service.dart';

class Chat extends StatefulWidget {
  final void Function() ongetBack;
  const Chat({super.key, required this.ongetBack});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ChatModel> list = <ChatModel>[];
  bool isUser = true;
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    String formattedDateTime = DateFormat('d MMM HH:mm').format(DateTime.now());
    list.add(
      ChatModel(
        date: formattedDateTime,
        isUser: isUser,
        type: 'show_date',
      ),
    );
    list.add(ChatModel(type: 'end_space', isUser: isUser));
    list.insert(
      list.length - 1,
      ChatModel(
        type: 'text_with_suggestions',
        isUser: false,
        list: list,
        index: list.length - 1,
        text:
            'Vanakkam! I’m Uzhavan 🌾 Your farming assistant is here. How can I assist you today?',
        suggestions: const [
          'Trend Analysis',
          'Farming Help',
          'Finance Tips',
          'Crop Health Advisory'
        ],
        onListChanged: onListChanged,
      ),
    );
  }

  Function(List<ChatModel>)? onListChanged(list) {
    setState(() {
      this.list = list;
    });
    return null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _getResponse(String text) async {
    final ChatModel response =
        await _apiService.queryDialogflow(messageController.text, '1234');
    response.list = list;
    response.index = list.length - 1;
    response.onListChanged = onListChanged;
    setState(() {
      list.insert(list.length - 1, response);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: Icon(Icons.chevron_left_sharp,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.045),
            onPressed: () {
              widget.ongetBack();
            },
          ),
        ),
        title: Row(
          children: [
            const Text(
              'Chat with Uzhavan',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.search,
              color: Colors.white,
              size: 34,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
            Icon(
              Icons.report_gmailerrorred,
              color: Colors.white,
              size: 34,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          ],
        ),
        elevation: 5,
        backgroundColor: Colors.black,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView.builder(
              itemCount: list.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return list[index];
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GradientBorderBox(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messageController,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.mic),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          hintText: "Ask Uzhavan",
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      color: Colors.grey[500]!,
                    ),
                    child: IconButton(
                      onPressed: () {
                        String message = messageController.text.trim();
                        if (message.isNotEmpty) {
                          setState(() {
                            list.insert(
                              list.length - 1,
                              ChatModel(
                                text: message,
                                isUser: true,
                                type: 'user_text',
                              ),
                            );
                          });
                          _getResponse(messageController.text);
                          messageController.text = "";
                        }
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
