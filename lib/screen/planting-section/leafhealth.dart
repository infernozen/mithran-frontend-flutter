import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mithran/widgets/camera/camera.dart';

class LeafHealth extends StatefulWidget {
  _LeafHealthState createState() => _LeafHealthState();
}

class _LeafHealthState extends State<LeafHealth> {
  DateTime now = DateTime.now();
  String selectedField = "Bengaluru Urban Field";
  List<String> fields = [
    // "Bengaluru Urban Field",
    // "Karnataka Urban Field",
    // "Chennai Urban Field",
    // "Kerala Urban Field"
  ];

  void _showFieldSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          fields: fields,
          selectedField: selectedField,
          onFieldSelected: (String newValue) {
            setState(() {
              selectedField = newValue;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Nitro Lens",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // Text color
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey[600]!),
                    ),
                    elevation: 0, // No shadow
                  ),
                  onPressed: _showFieldSelectionBottomSheet,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          !fields.isEmpty ? selectedField : "Select Field",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: !fields.isEmpty
                                ? Colors.black
                                : Colors.grey[600]!,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/planting/leaf1.png",
                              height: 100, width: 100),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                          child: Text(
                        "Nitro Lens",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(height: 15.0),
                      Container(
                          padding: EdgeInsets.only(left: 35.0, right: 35.0),
                          child: Text(
                            "Analyze your Nitrogen Levels instantly with just an Image",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          )),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraComponent()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,
                                color: Color.fromARGB(255, 52, 154, 19)),
                            const SizedBox(width: 15.0),
                            const Text("New Reading",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 52, 154, 19),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Row(
                            children: [
                              Lottie.asset(
                                'assets/animations/Plant.json',
                              ),
                              const SizedBox(width: 20.0),
                              Container(
                                width: 195.0,
                                child: Text.rich(
                                  textAlign: TextAlign.start,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Regularly measuring ",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Nitrogen",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700, // Bold
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            " level helps to increase the yield by ",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "27%",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700, // Bold
                                        ),
                                      ),
                                      TextSpan(
                                        text: " and save cost up to ",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "43%",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700, // Bold
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
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: const Text("Past Readings",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    )),
              ),
              const SizedBox(height: 30.0),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        // color: Colors.blue,
                        child: Stack(
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return SweepGradient(
                                    startAngle: 0.0,
                                    endAngle: 2 * 3.14,
                                    stops: [0, 0.2, 0.4, 0.6, 0.8],
                                    center: Alignment.center,
                                    colors: [
                                      Colors.red,
                                      Colors.orange,
                                      Colors.yellow,
                                      Colors.green,
                                      Colors.white,
                                    ]).createShader(rect);
                              },
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.25),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.25),
                                ),
                                child: Center(
                                  child: Text(
                                    "4",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 25.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${now.year}-${now.month}-${now.day}, 10 Acre",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text("Your crop is deficient in Nitrogen.",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16.0,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  final List<String> fields;
  final String selectedField;
  final ValueChanged<String> onFieldSelected;

  BottomSheet({
    required this.fields,
    required this.selectedField,
    required this.onFieldSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.44 * MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text(
                'Select Field',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView(
                children: fields.map((String value) {
                  bool isSelected = value == selectedField;
                  return Container(
                    color: isSelected ? Color(0xffE5F3FE) : Colors.white,
                    child: ListTile(
                      title: Text(
                        value,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "Wheat",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check,
                              color: Color(0xff4A85D1), size: 30.0)
                          : null,
                      onTap: () {
                        onFieldSelected(value);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  Icon(Icons.add, size: 30.0, color: Colors.blue),
                  const SizedBox(width: 20.0),
                  const Text("Add field",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
//OOMBIRIYA ILLA VANTHU CHOPPU RIYA OTHA THEVIDIYA PAIYA ENNA MATCH ENNA POOLU NEY THERIYAMA