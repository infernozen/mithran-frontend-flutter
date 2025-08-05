import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage({super.key});

  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String _selectedMeasure = 'Acres';
  List<String> measures = ["Square Units", "Acres", "Hectares"];
  String _selectedCrop = 'Apple';
  List<String> crops = [
    "Apple",
    "Banana",
    "Bean",
    "Carrot",
    "Coffee Beans",
    "Corn",
    "Cotton",
    "Green Tea",
    "Onion",
    "Oil",
    "Potato",
    "Rice",
    "Soybean",
    "Sugar Cane",
    "Tomato",
    "Wheat"
  ];
  TextEditingController fieldNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text("Edit",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
              ))),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF6F5F3),
        ),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Field Information"),
                          const Spacer(),
                          Icon(Icons.verified_rounded,
                              color: Color(0xff659600)),
                          const Text("Verified",
                              style: TextStyle(
                                color: Color(0xff659600),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      TextField(
                        controller: fieldNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.mode_edit_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Field name',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text("Updated Location",
                          style: TextStyle(
                            color: Color(0xff7D7D7D),
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const Text(
                          "Bangalore Division,Bengaluru,Karnataka,Electirc Fractory",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Field Size",
                                  style: TextStyle(
                                    color: Color(0xff7D7D7D),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                  )),
                              const Text(
                                "1.08",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const Spacer(),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMeasure,
                              items: measures.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                      )),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMeasure = newValue!;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.blue, // Blue icon color
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffF6F5F3),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 5.0),
                              Container(
                                width: 215.0,
                                padding: EdgeInsets.only(right: 5.0),
                                child: Text(
                                  "Remap to edit your field location and size",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 10.0),
                              TextButton(
                                  onPressed: () => {},
                                  child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color(0xffF6F5F3),
                                        border: Border.all(
                                          color: Colors.grey[
                                              500]!, // Change to your desired border color
                                          width:
                                              1.5, // Change to your desired border width
                                        ),
                                      ),
                                      child: Text(
                                        "Re-map",
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700),
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    Text("Crop Information",
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600]!),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCrop,
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          items: crops
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCrop = newValue!;
                            });
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const SizedBox(width: 10.0),
                          TextButton(
                              onPressed: () => {},
                              child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Color(0xffB53244),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700),
                                  ))),
                          TextButton(
                              onPressed: () => {},
                              child: Container(
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  decoration: BoxDecoration(
                                    color: Color(0xff0055B8),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Color(
                                          0xff0055B8), // Change to your desired border color
                                      width:
                                          1.5, // Change to your desired border width
                                    ),
                                  ),
                                  child: Text(
                                    "Save",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700),
                                  )))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
