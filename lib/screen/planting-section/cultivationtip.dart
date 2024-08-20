import 'package:flutter/material.dart';

class CultivationTip extends StatefulWidget {
  @override
  _CultivationTipState createState() => _CultivationTipState();
}

class _CultivationTipState extends State<CultivationTip> {
  List<String> options = ["By Task", "By Staging"];
  List<String> tasks = [
    "Plant Selection",
    "Planting",
    "Monitoring",
    "Site Selection",
    "Field Preparation",
    "Weeding",
    "Irrigation",
    "Fertilization Chemical",
    "Preventive Measure",
    "Plant protection Chemical",
    "Harvesting",
    "Post Harvest"
  ];
  List<String> crops = [
    "apple",
    "banana",
    "bean",
    "carrots",
    "coffee-beans",
    "corn",
    "cotton",
    "green-tea",
    "oil",
    "onion",
    "potato",
    "rice"
  ];
  int selectedOption = 0;
  String? selectedCrop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cultivation Tips",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Row(
            children: [
              const SizedBox(width: 15.0),
              const Text("See relevant information on",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  )),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCrop,
                    hint: Text("Select Crop",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        )),
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: crops.map((String crop) {
                      return DropdownMenuItem<String>(
                        value: crop,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/cropimages/$crop.png",
                              height: 24.0,
                              width: 24.0,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              crop,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCrop = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
            ],
          ),
          const SizedBox(height: 30.0),
          Container(
            decoration: BoxDecoration(),
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
                          vertical: 10.0, horizontal: 60.0),
                      decoration: BoxDecoration(
                        color: selectedOption == 0
                            ? Color(0xff0158DB)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Text("By Task",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: selectedOption == 0
                                ? Colors.white
                                : Colors.black,
                          ))),
                ),
                const Spacer(),
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
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Text("By Staging",
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
          SizedBox(height: selectedOption == 0 ? 20.0 : 40.0),
          selectedOption == 0
              ? Expanded(
                  child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            const SizedBox(width: 20.0),
                            Container(
                                padding: EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: Color(0xffE5F1FF),
                                ),
                                child: Icon(Icons.shopping_bag)),
                            const SizedBox(width: 10.0),
                            Text(
                              tasks[index],
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.keyboard_arrow_right, size: 25.0),
                            const SizedBox(width: 20.0),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        index != tasks.length - 1
                            ? Divider(height: 2.0)
                            : SizedBox(),
                      ],
                    );
                  },
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/planting/calendar.png",
                        height: 120.0, width: 120.0),
                    const SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 17.0, right: 17.0),
                      child: const Text(
                          "Choose the date your sowing was done or planned.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          )),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Color(0xff0158DB),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                const SizedBox(width: 10.0),
                                const Text("Add sowing date to start",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                                const SizedBox(width: 5.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
