import 'package:flutter/material.dart';
import '../../other/chat_bot.dart';
import 'youtube_player_screen.dart';

class HubPage extends StatefulWidget {
  final void Function() onReset;
  HubPage({super.key, required this.onReset});

  @override
  _HubPageState createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  List<String> farmingGuideImages = [
    "8flxUNp574ruVqd1",
    "oOwif5UqHAY68y20",
    "TYKWCGDostRell0b",
    "yuepQ8_Pnuneltgn"
  ];

  List<String> pestAndDiseaseImages = [
    "3W3OAlYIa7524vI7",
    "glGkjHz-9VEmylNz",
    "Gw3vtp40WOgdc-Wc",
    "VMGX_ABS7hTFzF2d"
  ];

  List<String> sustainableImages = [
    "9aS8ewn3pBFNsO46",
    "19FZxvu0UP3bGRcm",
    "fbp7e0QuU_E2stnu",
    "GIyhoDGIaQ0aGScA"
  ];

  List<String> SchemesImages = [
    "l5K3At5evoIZPE_C",
    "Tn8TOq2orT_2xStu",
    "WiTulMEwQWbVtLsM",
    "XCYJvCmqH__yQCkw"
  ];

  List<String> governmentSchemeImages = [
    "NCU",
    "NFSM",
    "PKMY",
    "PKSN",
    "RKVY",
    "SMAM",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hub",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              widget.onReset();
            }),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(247, 247, 247, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "FARMING GUIDES",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 180.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: farmingGuideImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                YouTubePlayerScreen(videoId: ''),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/Farming_Guides/${farmingGuideImages[index]}.jpg"),
                              fit: BoxFit.cover), // Adjust the fit as needed
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_outlined,
                            size: 50,
                            color: Color.fromARGB(151, 255, 255, 255),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "PEST AND DISEASE",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 180.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pestAndDiseaseImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                YouTubePlayerScreen(videoId: ''),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/Pest_and_Disease/${pestAndDiseaseImages[index]}.jpg"),
                              fit: BoxFit.cover), // Adjust the fit as needed
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_outlined,
                            size: 50,
                            color: Color.fromARGB(151, 255, 255, 255),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(ongetBack: () {
                                      Navigator.pop(context);
                                    })));
                      },
                      child: Image.asset("assets/botimage.png"))),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "SUSTAINABLE FARMING",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 180.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sustainableImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                YouTubePlayerScreen(videoId: ''),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/Sustainable_Farming/${sustainableImages[index]}.jpg"),
                              fit: BoxFit.cover), // Adjust the fit as needed
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_outlined,
                            size: 50,
                            color: Color.fromARGB(151, 255, 255, 255),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 35.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "SCHEMES AND SUBSIDIES",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 180.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: SchemesImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                YouTubePlayerScreen(videoId: ''),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/Schemes_and_Subsidies/${SchemesImages[index]}.jpg"),
                              fit: BoxFit.cover), // Adjust the fit as needed
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_outlined,
                            size: 50,
                            color: Color.fromARGB(151, 255, 255, 255),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 35.0),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "POPULAR GOVERNMENT SCHEMES",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: GridView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          // borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/GovtSchemes/${governmentSchemeImages[index]}.jpg"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
