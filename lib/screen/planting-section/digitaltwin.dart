import 'package:flutter/material.dart';
import 'package:mithran/other/chat_bot.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../helpers/digitaltwinhelper.dart';

class DigitalTwinPage extends StatelessWidget {
  final String crop;
  final String sowedDate;
  final String expectedHarvestDate;
  final String currentStage;

  DigitalTwinPage(
      {required this.crop,
      required this.sowedDate,
      required this.currentStage,
      required this.expectedHarvestDate});

  @override
  Widget build(BuildContext context) {
    Map<String, String> details = getStageDetails(crop, currentStage);
    String stageDescription = details["Description"]!;
    String actionableInsight = details["Actionable Insight"]!;

    return Scaffold(
      backgroundColor: Color(0xffF6F5F3),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digital Twin',
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              crop,
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: "Poppins",
                  color: Color.fromRGBO(110, 110, 110, 1)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 5,
      ),
      body: DigitalTwin(
        crop: crop,
        sowedDate: sowedDate,
        currentStage: currentStage,
        expectedHarvestDate: expectedHarvestDate,
        stageDescription: stageDescription,
        actionableInsight: actionableInsight,
      ),
    );
  }
}

class DigitalTwin extends StatelessWidget {
  final String crop;
  final String sowedDate;
  final String expectedHarvestDate;
  final String currentStage;
  final String actionableInsight;
  final String stageDescription;
  DigitalTwin({
    required this.crop,
    required this.sowedDate,
    required this.currentStage,
    required this.expectedHarvestDate,
    required this.actionableInsight,
    required this.stageDescription,
  });
  List<String> stages = [
    "Harvest",
    "Vegetative",
    "Fruiting",
  ];

  @override
  Widget build(BuildContext context) {
    print("CurrentStage");
    print(currentStage);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffD2D5DA),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xFFFFFF),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10.0),
                              const Text("Twin name",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  )),
                              const Text(
                                "Deviamal",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff5D5D5D),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Planted at 🌱",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          )),
                                      Text(
                                        "${sowedDate}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff5D5D5D),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Expected Harvest 🌾",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          )),
                                      Text(
                                        "${expectedHarvestDate}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff5D5D5D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              const Text("Stages to remind",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  )),
                              const SizedBox(height: 10.0),
                              Container(
                                height: 25.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: stages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffd9d9d9),
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Text("${stages[index]}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10.0,
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -7,
                          right: -7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(7.0),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color(0xffE4F2FF),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Edit twin info",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 7.0),
                                  Image.asset("assets/planting/magicpen.png",
                                      height: 20.0, width: 20.0),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 300,
                    child: ModelViewer(
                      backgroundColor: Colors.transparent,
                      src: 'assets/model/cropmodels/${currentStage}.glb',
                      alt: 'A 3D model of a crop at the current stage',
                      ar: true,
                      autoRotate: true,
                      disableZoom: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffF6F5F3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffD2D5DA))),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Icon(Icons.info_outline,
                              color: Theme.of(context).iconTheme.color),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stage Description',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0,
                                  )),
                              SizedBox(height: 5),
                              Text(
                                stageDescription,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Color(0xff5D5D5D),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ActionableInsights(
                    actionableInsight: actionableInsight,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle tap action here, e.g., navigate to personalized suggestions
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(ongetBack: () {
                              Navigator.pop(context);
                            })),
                  );
                },
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.11,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(204, 234, 232, 1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromRGBO(223, 221, 221, 0.957))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.black, size: 32),
                      SizedBox(
                        width: size.width * 0.62,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            const Text(
                              "Can't find the right result?",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors
                                      .black, // Specify the default color for the text
                                ),
                                children: [
                                  TextSpan(
                                    text: "Click here to ask ",
                                  ),
                                  TextSpan(
                                    text: "Uzhavan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        " our personalized farm assistant to help",
                                  ),
                                ],
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_sharp,
                          color: Colors.black, size: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionableInsights extends StatelessWidget {
  final String actionableInsight;

  ActionableInsights({required this.actionableInsight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xffD1EEFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff5D5D5D))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: Theme.of(context).iconTheme.color),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'Actionable Insights',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              actionableInsight,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                color: Color(0xff5D5D5D),
              ),
              overflow: TextOverflow
                  .visible, // Ensure text wraps within the container
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
