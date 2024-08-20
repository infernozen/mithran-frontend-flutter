import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:mithran/repositories/weatherprovider.dart';
import 'package:mithran/screen/home-section/weatherpage.dart';
import 'package:mithran/screen/market-section/marketplace.dart';
import 'package:mithran/widgets/initscan.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data.dart';
import '../../models/shopdata.dart';
import '../market-section/productpage.dart';

class HomePage extends StatefulWidget {
  final void Function() onReset;
  const HomePage({super.key, required this.onReset});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String latitude = '', longitude = '';
  List<ShopData> fertilizersDataList = [];
  int _currentIndex = 0;
  final Map<String, List<String>> weatherIcons = {
    'Chill': ['13d', '50d', '13n', '50n'],
    'Autumn': ['03d', '03n'],
    'Night': ['01n', '02n'],
    'Rainy': ['09n', '10n', '11n', '09d', '10d', '11d'],
    'Sunny': ['01d', '02d'],
    'Cloudy': ['04d', '04n'],
  };
  String weather = "";

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('latitude', '12.9118852'); // Save an integer
    await prefs.setString('longitude', '77.6163691'); // Save a string
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getString('latitude') ?? '0';
      longitude = prefs.getString('longitude') ?? '0';
    });
  }

  void decodeJson(data, shopList) {
    for (int i = 0; i < data.length; i++) {
      shopList.add(ShopData(data[i]['title'], data[i]['subtitle1'],
          data[i]['subtitle2'], data[i]['subtitle3'], data[i]['image']));
    }
  }

  @override
  void initState() {
    super.initState();
    decodeJson(fertilizersData, fertilizersDataList);
    saveData();
    loadData();
    print(latitude);
    print(longitude);
  }

  String getWeatherCategory(String iconCode) {
    for (var entry in weatherIcons.entries) {
      if (entry.value.contains(iconCode)) {
        return entry.key;
      }
    }
    return 'Sunny';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<WeatherProvider>(context);
    final iconCode = provider.currentData['weather'][0]['icon'];
    final weatherCategory = getWeatherCategory(iconCode);

    setState(() {
      weather = weatherCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    String date = DateFormat('dd').format(now);
    String month = DateFormat('MMMM').format(now);
    final dataProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        title: Image.asset(
          "assets/homepage/logo.png",
          width: 150.0,
        ),
        centerTitle: false,
        titleSpacing: -10.0,
        actions: [
          Image.asset("assets/homepage/bell.png", height: 25.0, width: 25.0),
          const SizedBox(width: 20.0),
          Image.asset("assets/homepage/shop.png", height: 25.0, width: 25.0),
          const SizedBox(width: 20.0),
        ],
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WeatherPage(
                                  provider: dataProvider,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 15.0),
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/homepage/weatherimages/${weather}.png',
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF313131), // #313131
                                const Color(0xFF616161).withOpacity(
                                    0.51), // rgba(97, 97, 97, 0.511667)
                                const Color(0xFF838383)
                                    .withOpacity(0.0), // rgba(131, 131, 131, 0)
                              ],
                              stops: const [0.0, 0.8, 0.9],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 25,
                        top: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                              "Vanakkam Rohith 🙏",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 25.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )),
                            const SizedBox(height: 5.0),
                            Text(
                              '${day}, ${date} ${month}',
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "${dataProvider.weatherData['temperature']} °C",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 45.0,
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20.0,
                        right: 20.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WeatherPage(
                                          provider: dataProvider,
                                          // isLoading: dataProvider.isLoading,
                                          // currentData: dataProvider.currentData,
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 22, 22, 75)
                                      .withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "View detailed",
                                  style: TextStyle(
                                    color: Color(0xff3E84CA),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "weather forecast",
                                  style: TextStyle(
                                    color: Color(0xff3E84CA),
                                    fontFamily: "Poppins",
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Heal Your Crop",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Get Things Fixed with Plantix's Magic Scan",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: InitScan(),
                ),
                Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 160.0,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: [
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
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Image.asset(
                              "assets/homepage/Ayya1.png",
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: Image.asset(
                            "assets/homepage/Ayya2.png",
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: Image.asset(
                            "assets/homepage/green1.png",
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: Image.asset(
                            "assets/homepage/green2.png",
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 20.0,
                      left: 175.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(right: 25.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                "Deals of the Day",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                "Best deals on essential agri products,just for you",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPage(onReset: widget.onReset)));
                          },
                          child: Text("See all",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              )),
                        ),
                      ]),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.only(left: 15.0),
                  height: 290.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fertilizersDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 13.0 : 8.0,
                            right: index == fertilizersDataList.length - 1
                                ? 13.0
                                : 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Set the desired border radius
                                  child: Image.network(
                                    fertilizersDataList[index]
                                        .image, // Your image URL or asset path
                                    width: 150.0,
                                    height: 150.0,
                                    fit: BoxFit
                                        .fill, // This adjusts the image to fit within the ClipRRect bounds
                                  ),
                                ),
                              ),
                              Container(
                                width: 160.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  fertilizersDataList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 180.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "by ",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: fertilizersDataList[index]
                                            .subtitle1,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "From  ${fertilizersDataList[index].subtitle2}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff2ABFAD),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  fertilizersDataList[index].subtitle3,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.only(left: 25.0, right: 20.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xffE9F6FF),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/homepage/man.png",
                              height: 140.0,
                              width: 130.0,
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Need Help?",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Container(
                                      width: 125.0,
                                      child: Text(
                                        "Whether it's a quick question or detailed guidance, we're here for you. Explore FAQs, chat with us, or get personalized support with Uzhavan",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.75,
                                          color: Colors.grey[600],
                                        ),
                                      )),
                                ]),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      "assets/homepage/message-question.png",
                                      height: 17.0,
                                      width: 17.0),
                                  const Text("Chat",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w200,
                                        fontSize: 12.0,
                                      )),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Image.asset("assets/homepage/book-saved.png",
                                      height: 17.0, width: 17.0),
                                  const Text("FAQ",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w200,
                                        fontSize: 12.0,
                                      )),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Image.asset(
                                      "assets/homepage/call-calling.png",
                                      height: 17.0,
                                      width: 17.0),
                                  const Text("Call",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w200,
                                        fontSize: 12.0,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100.0),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
