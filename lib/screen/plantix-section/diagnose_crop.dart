// ignore_for_file: must_be_immutable

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mithran/other/chat_bot.dart';
import 'package:mithran/repositories/plantix_service.dart';
import 'package:mithran/screen/plantix-section/treatment_crop.dart';
import 'package:provider/provider.dart';

class DiagnosePage extends StatelessWidget {
  XFile image;
  DiagnosePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlantixService(),
      child: DiagnoseCrop(image: image),
    );
  }
}

class DiagnoseCrop extends StatefulWidget {
  XFile image;
  DiagnoseCrop({super.key, required this.image});

  @override
  _DiagnoseCropState createState() => _DiagnoseCropState();
}

class _DiagnoseCropState extends State<DiagnoseCrop> {
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = Provider.of<PlantixService>(context, listen: false);
      dataProvider.uploadImage(widget.image, 'en');
    });
  }

  void _showLanguageSelector(dataProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    lang = 'en';
                    dataProvider.uploadImage(widget.image, lang);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tamil'),
                onTap: () {
                  setState(() {
                    lang = 'ta';
                  });
                  Navigator.pop(context);
                  dataProvider.uploadImage(widget.image, lang);
                },
              ),
              ListTile(
                title: const Text('Hindi'),
                onTap: () {
                  setState(() {
                    lang = 'hi';
                    dataProvider.uploadImage(widget.image, lang);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PlantixService>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_frames, size: 28),
              onPressed: () {
                _showLanguageSelector(dataProvider);
              }),
          const SizedBox(width: 10)
        ],
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Diagnose results",
              style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      body: dataProvider.isLoading
          ? _buildLoadingScreen(size)
          : _buildResultScreen(context, dataProvider, size),
    );
  }

  Widget _buildLoadingScreen(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      color: const Color.fromRGBO(247, 247, 247, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/Loading.json', width: size.width * 0.8),
          const SizedBox(height: 50),
          SizedBox(
            width: size.width * 0.75,
            child: const Text(
              "Mithran takes care of your crop like it's ours!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, PlantixService dataProvider, Size size) {
    return Container(
      height: size.height,
      width: size.width,
      color: const Color.fromRGBO(247, 247, 247, 1),
      child: Column(
        children: [
          const SizedBox(height: 25),
          _buildInfoBanner(size),
          const SizedBox(height: 20),
          if (!dataProvider.isHealthy && !dataProvider.isNotFound)
            _buildDiseaseCard(context, dataProvider, size),
          if (dataProvider.isHealthy && !dataProvider.isNotFound)
            _buildHealthyCard(size),
          if (dataProvider.isNotFound)
            _buildNotFoundCard(size),
          const SizedBox(height: 20),
          _buildChatCard(context, size),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.075,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(233, 241, 254, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.info_outline, color: Color.fromRGBO(54, 68, 138, 1), size: 32),
          SizedBox(
            width: size.width * 0.75,
            child: const Text(
              "Please check if any of the below diseases match the damage on your crop",
              style: TextStyle(
                color: Color.fromRGBO(54, 68, 138, 1),
                fontFamily: "Poppins",
              ),
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(BuildContext context, PlantixService dataProvider, Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromRGBO(223, 221, 221, 0.957)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.81,
            child: Text(
              dataProvider.title,
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontFamily: "Poppins",
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.83,
            height: size.height * 0.465,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.energy_savings_leaf_outlined, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Symptoms",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.22,
                  child: ListView.builder(
                    itemCount: dataProvider.symptoms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            const Text(" • ", style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: size.width * 0.66,
                              child: Text(
                                dataProvider.symptoms[index],
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _buildImageGrid(dataProvider, size),
              ],
            ),
          ),
          const SizedBox(height: 5),
          _buildTreatmentButton(context, dataProvider, size),
        ],
      ),
    );
  }

  Widget _buildImageGrid(PlantixService dataProvider, Size size) {
    return Container(
      height: size.height * 0.19,
      width: double.infinity,
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          if (dataProvider.imageReferences.length > 0)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.network(
                dataProvider.imageReferences[0],
                fit: BoxFit.fill,
              ),
            ),
          if (dataProvider.imageReferences.length > 1)
            Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(20)),
                  child: Image.network(
                    dataProvider.imageReferences[1],
                    width: size.width * 0.4,
                    height: size.height * 0.094,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 3),
                if (dataProvider.imageReferences.length > 2)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                    child: Image.network(
                      dataProvider.imageReferences[2],
                      width: size.width * 0.4,
                      height: size.height * 0.094,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTreatmentButton(BuildContext context, PlantixService dataProvider, Size size) {
    return SizedBox(
      width: size.width * 0.7,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreatmentPage(
                title: dataProvider.title,
                pathogen: dataProvider.pathogen,
                chemicalTreatment: dataProvider.chemicalTreatment,
                organicTreatment: dataProvider.organicTreatment,
                refImg: dataProvider.imageReferences.isNotEmpty
                    ? dataProvider.imageReferences[0]
                    : '',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(1, 88, 219, 1),
        ),
        child: const Text(
          "See treatment",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHealthyCard(Size size) {
    return _buildMessageCard(
      size,
      animation: 'assets/SeemsHealthy.json',
      message:
      "Everything looks great. No signs of pests or diseases detected. Keep up the good work!",
    );
  }

  Widget _buildNotFoundCard(Size size) {
    return _buildMessageCard(
      size,
      animation: 'assets/Error404.json',
      message:
      "Unable to detect a plant 🌱\nPlease verify the details and try again. If the issue persists, contact support.",
    );
  }

  Widget _buildMessageCard(Size size, {required String animation, required String message}) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromRGBO(223, 221, 221, 0.957)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
            child: Lottie.asset(animation, width: size.width * 0.75),
          ),
          SizedBox(
            width: size.width * 0.75,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              ongetBack: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.11,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(204, 234, 232, 1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color.fromRGBO(223, 221, 221, 0.957)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.info_outline, color: Colors.black, size: 32),
            SizedBox(
              width: size.width * 0.62,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 5),
                  Text(
                    "Can't find the right result?",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Click here to ask Uzhavan, our personalized farm assistant to help",
                    maxLines: 2,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_sharp, color: Colors.black, size: 32),
          ],
        ),
      ),
    );
  }
}
