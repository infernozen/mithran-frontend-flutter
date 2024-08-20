import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:mithran/polygon_mapper.dart';
import 'package:mithran/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FieldLocatorForm extends StatefulWidget {
  String location;
  google_maps.LatLng currentLocation;
  FieldLocatorForm(
      {super.key, required this.location, required this.currentLocation});

  @override
  _FieldLocatorFormState createState() => _FieldLocatorFormState();
}

class _FieldLocatorFormState extends State<FieldLocatorForm> {
  TextEditingController fieldName = TextEditingController();
  TextEditingController fieldSize = TextEditingController();
  List<google_maps.LatLng> _polygonLatLngs = [];

  @override
  void initState() {
    super.initState();
  }

  List<List<double>> convertLatLngToCoordinates(
      List<google_maps.LatLng> latLngs) {
    if (latLngs.isNotEmpty && latLngs.first != latLngs.last) {
      latLngs.add(latLngs.first);
    }

    return latLngs
        .map((latLng) => [
              double.parse(latLng.longitude.toStringAsFixed(4)),
              double.parse(latLng.latitude.toStringAsFixed(4)),
            ])
        .toList();
  }

  void setMappingAndFieldSize(
      List<google_maps.LatLng> polygonLatLngs, String size) {
    setState(() {
      _polygonLatLngs = polygonLatLngs;
      fieldSize.text = size;
    });
  }

  Future<void> addField() async {
    if (fieldName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(buildCustomSnackBar(
          context: context,
          message: "Please Fill the Field name!!",
          type: SnackBarType.failure));
      return;
    }
    if (double.parse(fieldSize.text) > 2.5) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> polygonIds = prefs.getStringList('polygonIds') ?? [];
      Map<String, dynamic> polygonData = {
        'fieldName': fieldName.text,
        'fieldSize': fieldSize.text,
        'polygonLatLngs': _polygonLatLngs,
        'location': widget.location,
        'currentLocation': {
          'longitude': widget.currentLocation.longitude,
          'latitude': widget.currentLocation.latitude,
        },
        'Crop': ''
      };
      const baseUrl = "http://35.208.131.250:5000/soil/newPolyID";
      final encodedCoordinates = convertLatLngToCoordinates(_polygonLatLngs);
      final url =
          "$baseUrl?name=${Uri.encodeComponent(fieldName.text)}&coordinates=$encodedCoordinates";
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          Map<String, dynamic> res = jsonDecode(response.body);
          polygonIds.add(res['id']);
          print(polygonIds);
          await prefs.setStringList('polygonIds', polygonIds);
          String polygonDataString = jsonEncode(polygonData);
          await prefs.setString("Poly_${res['id']}", polygonDataString);
          print(polygonDataString);
        } else {
          print('Failed to load data: ${response.body}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(buildCustomSnackBar(
          context: context,
          message: "Area has to be atleast 2.5 acres!!",
          type: SnackBarType.failure));
    }
  }

  @override
  Widget build(context) {
    return (Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40),
              onPressed: () {
                _polygonLatLngs.clear();
                Navigator.pop(context);
              }),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Field Details",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              "Step 2 of 2",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  color: Color.fromRGBO(110, 110, 110, 1)),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 5,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: const Color.fromRGBO(246, 245, 243, 1),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color.fromRGBO(226, 225, 223, 1), width: 2)),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Field information",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            fieldSize.value.text == ""
                                ? Icons.error_outline_sharp
                                : Icons.check_circle_outline_sharp,
                            size: 18,
                            color: fieldSize.value.text == ""
                                ? const Color.fromRGBO(89, 89, 89, 1)
                                : const Color.fromRGBO(102, 151, 0, 1),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            fieldSize.value.text == ""
                                ? "Unverified"
                                : "Verifed",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: fieldSize.value.text == ""
                                  ? const Color.fromRGBO(135, 135, 135, 1)
                                  : const Color.fromRGBO(102, 151, 0, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fieldName,
                    decoration: InputDecoration(
                      labelText: "Field name",
                      labelStyle: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              89, 89, 89, 1), // Adjust color to match the image
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              89, 89, 89, 1), // Adjust color to match the image
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              89, 89, 89, 1), // Keep the same color on focus
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                    ),
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    initialValue: widget.location,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                    decoration: InputDecoration(
                      labelText: "Field location",
                      labelStyle: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      suffixIcon: const Icon(Icons.chevron_right,
                          color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              89, 89, 89, 1), // Adjust color to match the image
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              89, 89, 89, 1), // Adjust color to match the image
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              89, 89, 89, 1), // Keep the same color on focus
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                  if (fieldSize.value.text != "") const SizedBox(height: 16),
                  if (fieldSize.value.text != "")
                    Row(
                      children: [
                        SizedBox(
                          width: 230,
                          height: 55,
                          child: TextFormField(
                            controller: fieldSize,
                            readOnly: true,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                            decoration: InputDecoration(
                              labelText: "Field size",
                              labelStyle: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 89, 89,
                                      1), // Adjust color to match the image
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 89, 89,
                                      1), // Adjust color to match the image
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 89, 89,
                                      1), // Keep the same color on focus
                                  width: 1.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              menuWidth: 90,
                              value: "Acres",
                              isDense: true,
                              elevation: 0,
                              items: <String>['Acres', 'Hec', 'Sq M']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: SizedBox(
                                      width: 50,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(
                                                47, 110, 174, 1)),
                                      )),
                                );
                              }).toList(),
                              onChanged: (_) {},
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 26,
                                weight: 500,
                              ),
                              iconEnabledColor:
                                  const Color.fromRGBO(47, 110, 174, 1),
                              iconDisabledColor:
                                  const Color.fromRGBO(47, 110, 174, 1),
                            ),
                          ),
                        )
                      ],
                    ),
                  if (fieldSize.value.text == "") const SizedBox(height: 16),
                  if (fieldSize.value.text == "")
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Measure your field area accurately",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PolygonMap(
                                            currentLocation:
                                                widget.currentLocation,
                                            setMappingAndFieldSize:
                                                setMappingAndFieldSize,
                                          )),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100]!,
                                side: const BorderSide(color: Colors.black45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Start mapping",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        height: 90,
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Color.fromRGBO(226, 225, 223, 1)))),
        child: ElevatedButton(
          onPressed: () {
            addField();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: const Color.fromRGBO(0, 85, 184, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            "Add Field",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    ));
  }
}
