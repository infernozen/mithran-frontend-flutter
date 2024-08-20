// ignore_for_file: must_be_immutable

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = Provider.of<PlantixService>(context, listen: false);
      dataProvider.uploadImage(widget.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PlantixService>(context);
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
              "Diagnose results",
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
      body: dataProvider.isLoading ? 
        Container(
          height: size.height,
          width: size.width,
          color: const Color.fromRGBO(247, 247, 247, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/Loading.json', width: size.width * 0.8),
              const SizedBox(height: 50),
              SizedBox(
                      width: size.width * 0.75,
                      child: const Text(
                        "Mithran takes care of your crop like it's ours !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    )
            ],
          ),
        )
        : Container(
        height: size.height,
        width: size.width,
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              width: size.width * 0.9,
              height: size.height * 0.075,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(233, 241, 254, 1),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.info_outline,
                      color: Color.fromRGBO(54, 68, 138, 1), size: 32),
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
            ),
            const SizedBox(height: 20),
            if (!dataProvider.isLoading &&
                !dataProvider.isHealthy &&
                !dataProvider.isNotFound)
              Container(
                width: size.width * 0.9,
                height: size.height * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromRGBO(223, 221, 221, 0.957))),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    if (!dataProvider.isLoading)
                      SizedBox(
                        width: size.width * 0.81,
                        child: Text(
                          dataProvider.title,
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * 0.83,
                      height: size.height * 0.465,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: size.height * 0.04,
                            child: const Row(
                              children: [
                                Icon(Icons.energy_savings_leaf_outlined,
                                    size: 28),
                                SizedBox(width: 10),
                                Text(
                                  "Symptoms",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          if (!dataProvider.isLoading)
                            SizedBox(
                              width: double.infinity,
                              height: size.height * 0.22,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dataProvider.symptoms.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Row(
                                      children: [
                                        const Text(
                                          " •  ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.66,
                                          child: Text(
                                            dataProvider.symptoms[index],
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (!dataProvider.isLoading &&
                              !dataProvider.isNotFound &&
                              !dataProvider.isHealthy)
                            Container(
                                height: size.height * 0.19,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      child: SizedBox(
                                        height: double.infinity,
                                        child: Image.network(
                                          dataProvider.imageReferences[0],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20)),
                                          child: SizedBox(
                                            width: size.width * 0.4,
                                            height: size.height * 0.094,
                                            child: Image.network(
                                                dataProvider.imageReferences[1],
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(20)),
                                          child: SizedBox(
                                            width: size.width * 0.4,
                                            height: size.height * 0.094,
                                            child: Image.network(
                                                dataProvider.imageReferences[2],
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: size.width * 0.7,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TreatmentPage(
                                  title: dataProvider.title,
                                  pathogen: dataProvider.pathogen,
                                  chemicalTreatment:
                                      dataProvider.chemicalTreatment,
                                  organicTreatment:
                                      dataProvider.organicTreatment,
                                  refImg: dataProvider.imageReferences[0],
                                ),
                              ),
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
                            "see treatment",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 18),
                          )),
                    )
                  ],
                ),
              ),
            if (!dataProvider.isLoading &&
                dataProvider.isHealthy &&
                !dataProvider.isNotFound)
              Container(
                  width: size.width * 0.9,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromRGBO(223, 221, 221, 0.957))),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
                      child: Lottie.asset('assets/SeemsHealthy.json',
                          width: size.width * 0.75),
                    ),
                    SizedBox(
                      width: size.width * 0.75,
                      child: const Text(
                        "Everything looks great. No signs of pests or diseases detected. Keep up the good work!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ])),
            if (!dataProvider.isLoading && dataProvider.isNotFound)
              Container(
                  width: size.width * 0.9,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromRGBO(223, 221, 221, 0.957))),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
                      child: Lottie.asset('assets/Error404.json',
                          width: size.width * 0.75),
                    ),
                    SizedBox(
                      width: size.width * 0.75,
                      child: const Text(
                        "Unable to detect a plant 🌱\n Please verify the details and try again. If the issue persists, contact support.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ])),
            const SizedBox(height: 20),
            Container(
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
                  const Icon(Icons.info_outline, color: Colors.black, size: 32),
                  SizedBox(
                    width: size.width * 0.62,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Text(
                          "Cant't find the right result?",
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
                                text: "Uzhalavan",
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
            )
          ],
        ),
      ),
    );
  }
}
