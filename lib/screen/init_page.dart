import 'package:flutter/material.dart';
import 'package:mithran/screen/expense-section/expensetrackerpage.dart';
import 'package:mithran/screen/home-section/homepage.dart';
import 'package:mithran/screen/planting-section/soilhealth.dart';
import 'planting-section/leafhealth.dart';

class InitPage extends StatefulWidget {
  int? index;
  InitPage({super.key, this.index});
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late final List<Widget> _pages;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _initPages();
    setState(() {
      currentPageIndex = widget.index ?? 0;
    });
  }

  void _initPages() {
    _pages = [
      HomePage(onReset: onReset),
      Soil(onReset: onReset),
      LeafHealth(
        polygonId: '',
      ),
      ExpenseTracker(onReset: onReset),
    ];
  }

  void onReset() {
    setState(() {
      currentPageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              _pages[currentPageIndex],
              Positioned(
                bottom: 20.0,
                left: 10.0,
                right: 10.0,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPageIndex = 0;
                          });
                        },
                        child: Column(
                          children: [
                            currentPageIndex == 0
                                ? Container(
                                    height: 5.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Image.asset(
                                currentPageIndex == 0
                                    ? "assets/bottomnavbar/home-filled.png"
                                    : "assets/bottomnavbar/home.png",
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: const Text(
                                "Home",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPageIndex = 1;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            currentPageIndex == 1
                                ? Container(
                                    padding: EdgeInsets.only(right: 10.0),
                                    height: 5.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(height: 5.0),
                            Image.asset(
                                currentPageIndex == 1
                                    ? "assets/bottomnavbar/tree-filled.png"
                                    : "assets/bottomnavbar/tree.png",
                                height: 20.0,
                                width: 20.0),
                            const Text(
                              "Farm",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPageIndex = 2;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            currentPageIndex == 2
                                ? Container(
                                    padding: EdgeInsets.only(right: 10.0),
                                    height: 5.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(height: 5.0),
                            Image.asset(
                                currentPageIndex == 2
                                    ? "assets/bottomnavbar/hub-filled.png"
                                    : "assets/bottomnavbar/hub.png",
                                height: 20.0,
                                width: 20.0),
                            const Text(
                              "Hub",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPageIndex = 3;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            currentPageIndex == 3
                                ? Container(
                                    padding: EdgeInsets.only(right: 10.0),
                                    height: 5.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(height: 5.0),
                            Image.asset(
                                currentPageIndex == 3
                                    ? "assets/bottomnavbar/trend-up-filled.png"
                                    : "assets/bottomnavbar/trend-up.png",
                                height: 20.0,
                                width: 20.0),
                            const Text(
                              "Finances",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
