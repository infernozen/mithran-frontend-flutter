import 'package:flutter/material.dart';
import 'package:mithran/models/cropstages.dart';
import 'package:mithran/models/cropstagesbag.dart';
import 'package:mithran/other/chat_bot.dart';
import 'package:mithran/screen/market-section/productpage.dart';
import '../../helpers/fertilizercalculatorhelp.dart';

class FertilizerCalculator extends StatefulWidget {
  final double fieldSize;
  final String sowedDate;
  final double targetYield;
  final String crop;
  FertilizerCalculator(
      {super.key,
      required this.fieldSize,
      required this.sowedDate,
      required this.crop,
      this.targetYield = 1000.0});
  _FertilizerCalculatorState createState() => _FertilizerCalculatorState();
}

class _FertilizerCalculatorState extends State<FertilizerCalculator> {
  List<String> stages = [
    "Harvest",
    "Vegetative",
    "Fruiting",
  ];
  int selectedOption = 0;
  bool active = false;
  List<CropStages> cropStagesList = [];
  List<CropStagesItems> cropStageItemsList = [];
  Map<String, String> totalItemQuantities = {};
  Map<String, String> totalItemBags = {};
  List<CropStagesBag> cropStagesBag = [];
  List<CropStagesItemsBag> cropStagesItemsBagList = [];
  bool switchToggled = false;
  void decodeJson(
      cropStages, cropStagesList, Map<String, String> totalItemQuantities) {
    var stages = cropStages;
    for (int i = 0; i < stages.length; i++) {
      var items = stages[i]['items'];
      List<CropStagesItems> cropStageItemsList =
          []; // Initialize a new list for each stage

      for (int j = 0; j < items.length; j++) {
        String itemName = items[j]['item'];
        String quantityStr = items[j]['quantity'];
        String type = items[j]['type'];

        // Extract the numerical part of the quantity
        double quantityValue = double.parse(quantityStr.split(' ')[0]);

        // Accumulate the quantity in the totalItemQuantities map as String
        if (totalItemQuantities.containsKey(itemName)) {
          double currentQuantity = double.parse(totalItemQuantities[itemName]!);
          totalItemQuantities[itemName] =
              (currentQuantity + quantityValue).toString();
        } else {
          totalItemQuantities[itemName] = quantityValue.toString();
        }

        // Add item to the list for this stage
        cropStageItemsList.add(CropStagesItems(itemName, quantityStr, type));
      }

      // Add the stage and its items to the cropStagesList
      cropStagesList.add(CropStages(stages[i]['stage'], cropStageItemsList));
    }

    // Example of printing the total quantities of each item
    print("Total quantities of each item:");
    totalItemQuantities.forEach((item, totalQuantity) {
      print("$item: $totalQuantity");
    });
  }

  void decodeJsonBag(
      cropStages, cropStagesBag, Map<String, String> totalItemBags) {
    var stages = cropStages;
    for (int i = 0; i < stages.length; i++) {
      var items = stages[i]['items'];
      List<CropStagesItemsBag> cropStageItemsBagList =
          []; // Initialize a new list for each stage

      for (int j = 0; j < items.length; j++) {
        String itemName = items[j]['item'];
        String quantityStr = items[j]['quantity'];
        String type = items[j]['type'];

        // Extract the numerical part of the quantity
        int quantityValue =
            (double.parse(quantityStr.split(' ')[0]) / 50.0).ceil();

        if (quantityStr.split(' ')[1].compareTo("kgs") == 0) {
          quantityStr = "${quantityValue} bags";
        } else {
          quantityStr = "${quantityValue} bottles";
        }

        // Accumulate the quantity in the totalItemBags map as String
        if (totalItemBags.containsKey(itemName)) {
          int currentQuantity = int.parse(totalItemBags[itemName]!);
          totalItemBags[itemName] =
              (currentQuantity + quantityValue).toString();
        } else {
          totalItemBags[itemName] = quantityValue.toString();
        }

        // Add item to the list for this stage
        cropStageItemsBagList
            .add(CropStagesItemsBag(itemName, quantityStr, type));
      }

      // Add the stage and its items to the cropStagesBag
      cropStagesBag
          .add(CropStagesBag(stages[i]['stage'], cropStageItemsBagList));
    }

    // Example of printing the total quantities of each item
    print("Total quantities of each item:");
    totalItemBags.forEach((item, totalQuantity) {
      print("$item: $totalQuantity");
    });
  }

  @override
  void initState() {
    Map<String, dynamic> fertilizerPlan = generateFertilizerPlan(
        widget.fieldSize, widget.crop, widget.targetYield);
    super.initState();
    decodeJson(fertilizerPlan["stages"], cropStagesList, totalItemQuantities);
    decodeJsonBag(fertilizerPlan["stages"], cropStagesBag, totalItemBags);
  }

  @override
  Widget build(BuildContext context) {
    print(switchToggled);
    final List<MapEntry<String, String>> entries =
        totalItemQuantities.entries.toList();
    final List<MapEntry<String, String>> entriesBag =
        totalItemBags.entries.toList();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        title: Text(
          "Fertilizer Calculator",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPage(
                              onReset: () {},
                            )));
              },
              child: Image.asset("assets/homepage/shop.png",
                  height: 25.0, width: 25.0)),
          const SizedBox(width: 20.0),
        ],
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF6F5F3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                color: Colors.white,
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
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          Text("${widget.fieldSize}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                                color: Colors.black,
                              )),
                          const Text(
                            "Field size",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Planted at 🌱",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      )),
                                  Text(
                                    "${widget.sowedDate}",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Target yield 🎯",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      )),
                                  Text(
                                    "${widget.targetYield} kgs",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff5D5D5D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20.0),
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
                          const SizedBox(height: 12.0),
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
                                      borderRadius: BorderRadius.circular(40.0),
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
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -7,
                      right: -7,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xfff6f5f3)),
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
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Container(
                width: 370,
                child: Row(
                  children: [
                    const SizedBox(width: 15.0),
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          selectedOption = 0;
                        })
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40.0),
                          decoration: BoxDecoration(
                            color: selectedOption == 0
                                ? Color(0xff0158DB)
                                : Colors.grey[100],
                            border: Border.all(
                                style: selectedOption == 0
                                    ? BorderStyle.none
                                    : BorderStyle.solid,
                                color: Color(0xff0158DB),
                                width: 2),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Text("Crop Stage",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: selectedOption == 0
                                    ? Colors.white
                                    : Colors.black,
                              ))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          selectedOption = 1;
                        })
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 60.0),
                          decoration: BoxDecoration(
                            color: selectedOption == 1
                                ? Color(0xff0158DB)
                                : Colors.grey[100],
                            border: Border.all(
                                style: selectedOption == 1
                                    ? BorderStyle.none
                                    : BorderStyle.solid,
                                color: Color(0xff0158DB),
                                width: 2),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Text("Total",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: selectedOption == 1
                                    ? Colors.white
                                    : Colors.black,
                              ))),
                    ),
                    const SizedBox(width: 15.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffD2D5DA),
                    width: 2.0,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Display in bags",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            )),
                        Text("Quantity will be converted into 50kg bags",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            )),
                      ],
                    ),
                    const Spacer(),
                    Column(children: [
                      Switch(
                          value: active,
                          activeColor: Color(0xff0158DB),
                          onChanged: (bool value) {
                            setState(() {
                              active = value;
                              switchToggled = !switchToggled;
                            });
                          })
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            selectedOption == 0
                ? Container(
                    height: 300.0,
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: ListView.builder(
                      itemCount: switchToggled
                          ? cropStagesBag.length
                          : cropStagesList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15.0, top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                  border: BorderDirectional(
                                      top: BorderSide(
                                        color: const Color(0xffD2D5DA),
                                        width: 2.0,
                                      ),
                                      start: BorderSide(
                                        color: const Color(0xffD2D5DA),
                                        width: 2.0,
                                      ),
                                      end: BorderSide(
                                        color: const Color(0xffD2D5DA),
                                        width: 2.0,
                                      )),
                                  color: Color(0xffE5F3FE),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${switchToggled ? cropStagesBag[index].stage : cropStagesList[index].stage}",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffD2D5DA),
                                    width: 2.0,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0))),
                              height: switchToggled
                                  ? cropStagesBag[index].items.length * 95.0
                                  : cropStagesList[index].items.length * 95.0,
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: switchToggled
                                      ? cropStagesBag[index].items.length
                                      : cropStagesList[index].items.length,
                                  itemBuilder: (context, indexs) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                            width: 1.0,
                                            color: indexs !=
                                                    cropStagesList[index]
                                                            .items
                                                            .length -
                                                        1
                                                ? Colors.grey[300]!
                                                : Colors.transparent),
                                      )),
                                      padding: EdgeInsets.only(
                                          top: 15.0, bottom: 15.0, left: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 150.0,
                                                child: Text(
                                                    "${switchToggled ? cropStagesBag[index].items[indexs].item : cropStagesList[index].items[indexs].item}",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                      color: Colors.grey[800],
                                                    )),
                                              ),
                                              Text(
                                                  "Type:${switchToggled ? cropStagesBag[index].items[indexs].type : cropStagesList[index].items[indexs].type}",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600],
                                                  )),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            children: [
                                              Text(
                                                  "${switchToggled ? cropStagesBag[index].items[indexs].quantity : cropStagesList[index].items[indexs].quantity}",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(width: 20.0),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                        height: 300.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffD2D5DA),
                            width: 2.0,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: switchToggled
                              ? entriesBag.length
                              : entries.length,
                          itemBuilder: (context, index) {
                            var item = entries[index];
                            var itemBag = entriesBag[index];
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 15.0, top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: index != entries.length - 1
                                          ? Colors.grey[300]!
                                          : Colors.transparent),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150.0,
                                    child: Text(
                                      "${item.key}",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    switchToggled
                                        ? "${itemBag.value}"
                                        : "${item.value}",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(ongetBack: () {
                              Navigator.pop(context);
                            })));
              },
              child: Container(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xff0158DB),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 275.0,
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Get more personalized suggestions from Uzhavan',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15.0,
                      ),
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
