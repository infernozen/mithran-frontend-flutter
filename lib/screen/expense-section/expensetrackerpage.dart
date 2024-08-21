import 'package:flutter/material.dart';
import 'package:mithran/screen/expense-section/cropexpensepage.dart';
import 'package:mithran/screen/market-section/marketplace.dart';
import 'package:mithran/widgets/charts/expensetrackerchart.dart';

class ExpenseTracker extends StatefulWidget {
  final void Function() onReset;
  const ExpenseTracker({super.key, required this.onReset});

  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  bool addPressed = false;
  List<String> crops = [
    "apple",
    "banana",
    "bean",
    "carrots",
    "coffee-beans",
    "corn",
    "cotton",
    "green-tea"
  ];
  double totalProfit = 0;
  List<double> cropProfits = [100, 200, 300, 350, 400, 100, 200, 300];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    calculateTotalProfit();
  }

  void addCropProfit(index, value) {
    setState(() {
      cropProfits[index] += value;
    });
  }

  void calculateTotalProfit() {
    double profit = 0;
    for (int i = 0; i < cropProfits.length; i++) {
      profit += cropProfits[i];
    }
    setState(() {
      totalProfit = profit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF6F5F3),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              widget.onReset();
            }),
        title: const Text(
          "Finances",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Market(onReset: () {
                                  widget.onReset();
                                  Navigator.pop(context);
                                })));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Image.asset(
                      "assets/homepage/Ayya1.png",
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD2D5DA),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: ExpenseTrackerChart(
                      values: cropProfits,
                      imagePaths: crops,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffD2D5DA),
                            width: 2.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          const Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 18.0, right: 5.0),
                                child: Text(
                                  "Estimated total profit",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                              Icon(Icons.info_outline),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                            ),
                            child: Text(
                              "₹$totalProfit",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 13.0),
                        ],
                      )),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD2D5DA),
                        width: 2.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        const Row(
                          children: [
                            SizedBox(width: 17),
                            Text("Calculate profit",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                )),
                            Spacer(),
                            Icon(Icons.more_vert_outlined),
                            SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            const SizedBox(width: 17.0),
                            const Text("Your Crops",
                                style: TextStyle(
                                  color: Color(0xff4F4F4F),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                )),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    addPressed = true;
                                  });
                                },
                                child: const Icon(Icons.add,
                                    color: Color(0xff0155CF))),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  addPressed = true;
                                });
                              },
                              child: const Text("Add",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff0155CF),
                                  )),
                            ),
                            const SizedBox(width: 19.0),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          height: crops.length * 50,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: crops.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CropExpense(
                                                  cropProfits: cropProfits,
                                                  calculateTotalProfit:
                                                      calculateTotalProfit,
                                                  addCropProfit: addCropProfit,
                                                  index: index,
                                                  cropName: crops[index][0]
                                                          .toUpperCase() +
                                                      crops[index]
                                                          .substring(1))));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 13.0, top: 13.0),
                                      child: Row(children: [
                                        const SizedBox(width: 12.0),
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F5F3),
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          child: Image.asset(
                                              "assets/cropimages/${crops[index]}.png",
                                              height: 20.0,
                                              width: 20.0),
                                        ),
                                        const SizedBox(width: 15.0),
                                        Text(
                                          crops[index][0].toUpperCase() +
                                              crops[index].substring(1),
                                          style: const TextStyle(
                                            color: Color(0xff4F4F4F),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "₹${cropProfits[index]}",
                                          style: const TextStyle(
                                            color: Color(0xff4F4F4F),
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Icon(Icons.chevron_right),
                                        const SizedBox(width: 12.0),
                                      ]),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  index != crops.length - 1
                                      ? const Divider(height: 0.5)
                                      : const SizedBox(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100.0),
              ],
            ),
            addPressed
                ? Positioned(
                    left: 15,
                    right: 15,
                    top: 10,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.3), // Shadow color
                              offset: const Offset(5, 5), // Shadow offset
                              spreadRadius: 450, // Spread radius
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text("Select your crop",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  )),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: TextField(
                                controller: searchController,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  hintText: 'Search',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              color: const Color.fromARGB(183, 240, 240, 240),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0),
                                  const Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text("Your Crops",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.0,
                                        )),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, bottom: 200.0),
                                    child: Wrap(
                                        spacing: 20.0,
                                        runSpacing: 30.0,
                                        children: List.generate(crops.length,
                                            (index) {
                                          return Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          400.0),
                                                ),
                                                child: Image.asset(
                                                    'assets/cropimages/${crops[index]}.png',
                                                    height: 50.0,
                                                    width: 50.0),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Text(
                                                crops[index][0].toUpperCase() +
                                                    crops[index].substring(1),
                                                style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          );
                                        })),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        addPressed = false;
                                      });
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1861BE),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )
                : const Positioned(child: SizedBox()),
          ]),
        ),
      ),
    );
  }
}
