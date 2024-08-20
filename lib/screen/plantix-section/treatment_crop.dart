// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mithran/screen/init_page.dart';

class TreatmentPage extends StatefulWidget {
  String title;
  String pathogen;
  String chemicalTreatment;
  String organicTreatment;
  String refImg;
  TreatmentPage(
      {super.key,
      required this.title,
      required this.pathogen,
      required this.chemicalTreatment,
      required this.organicTreatment,
      required this.refImg});

  @override
  _TreatmentPageState createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  FlutterTts flutterTts = FlutterTts();

  Future _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Treatment",
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 40),
              child: SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.22,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 5),
                        Icon(Icons.filter_1_sharp,
                            color: Color.fromRGBO(21, 110, 94, 1), size: 32),
                        SizedBox(width: 15),
                        SizedBox(
                          child: Text(
                            "Diagnosis Result",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          child: Text(
                            "Change",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Color.fromRGBO(18, 84, 184, 1),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: size.height * 0.12,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(226, 255, 255, 255),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Container(
                                  width: 80,
                                  height: 80,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image.network(widget.refImg,
                                      fit: BoxFit.fill)),
                            ),
                            const SizedBox(width: 15),
                            Center(
                              child: SizedBox(
                                width: size.width * 0.57,
                                height: 92,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      widget.pathogen,
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color.fromRGBO(94, 94, 94, 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        horizontalTitleGap: 0,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Color.fromRGBO(226, 226, 226, 1)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0),
              child: SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.29,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.filter_2_sharp,
                            color: Color.fromRGBO(21, 110, 94, 1), size: 32),
                        SizedBox(width: 15),
                        SizedBox(
                          child: Text(
                            "Recommendations",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(5, 148, 136, 0.4),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: const Color.fromRGBO(5, 148, 136, 1),
                          )),
                      child: SizedBox(
                        width: size.width * 0.9,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "We recommend following organic control methods in the early stages of a disease or when the crop is close to harversting. In more advanced stages of a disease, please follow chemical control measures.",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                ),
                                maxLines: 5,
                              ),
                              Text(
                                "Mixing or applying different products at the same time is not recommended.",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Poppins",
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Color.fromRGBO(226, 226, 226, 1)),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Column(children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        _speak(widget.organicTreatment);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.multitrack_audio_sharp,
                            color: Color.fromRGBO(4, 82, 193, 1),
                            size: 32,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Listen",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(4, 82, 193, 1),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.construction_outlined,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Organic Control",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.organicTreatment,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(57, 57, 57, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Color.fromRGBO(226, 226, 226, 1)),
                    const SizedBox(height: 10),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        _speak(widget.chemicalTreatment);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.multitrack_audio_sharp,
                            color: Color.fromRGBO(4, 82, 193, 1),
                            size: 32,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Listen",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(4, 82, 193, 1),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.construction_outlined,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Chemical Control",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.chemicalTreatment,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(57, 57, 57, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => InitPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .blueAccent; // Color when the button is pressed
                              }
                              return const Color.fromRGBO(1, 88, 219, 1);
                            },
                          ),
                        ),
                        child: const Text(
                          "Go Home",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 18),
                        )),
                    const SizedBox(height: 20),
                  ]),
                )),
          ],
        ),
      ),
    );
  }
}
