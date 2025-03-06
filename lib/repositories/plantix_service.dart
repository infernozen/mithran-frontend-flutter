import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlantixService extends ChangeNotifier {
  final String _apiUrl = 'http://34.122.191.130:5000/plantix/detect-disease';
  String title = "";
  String pathogen = "";
  String chemicalTreatment = "";
  String organicTreatment = "";
  List<String> imageReferences = [];
  List<String> symptoms = [];
  bool isLoading = true;
  bool isHealthy = false;
  bool isNotFound = true;

  Future<void> uploadImage(XFile imageFile, String lang) async {
    isLoading = true;
    isHealthy = false;
    isNotFound = true;
    notifyListeners();
    final uri = Uri.parse(_apiUrl);
    final request = http.MultipartRequest('POST', uri);
    request.headers['accept-Language'] = lang;
    try {
      final file = File(imageFile.path);
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      // Send the request and get the response
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(responseData.body);
        // Navigate through the JSON structure
        final predictedDiagnoses =
            parsedData['predicted_diagnoses'] as List<dynamic>?;

        if (parsedData['crop_health'].compareTo("unknown") == 0) {
          isNotFound = true;
        } else {
          isNotFound = false;
        }

        if (predictedDiagnoses != null && predictedDiagnoses.isNotEmpty) {
          final firstDiagnosis = predictedDiagnoses[0] as Map<String, dynamic>;
          title = firstDiagnosis['common_name'];
          if (title.compareTo("Healthy") != 0) {
            pathogen = firstDiagnosis['pathogen_class'];
            chemicalTreatment = firstDiagnosis['treatment_chemical'];
            organicTreatment = firstDiagnosis['treatment_organic'];
            final imageRef = firstDiagnosis['image_references'];
            imageRef.forEach((item) {
              imageReferences.add(item);
            });
            final symptom = firstDiagnosis['symptoms_short'];
            symptoms.clear();
            symptom.forEach((element) {
              symptoms.add(element);
            });
            isHealthy = false;
          } else {
            if (isHealthy == false) {
              isHealthy = true;
            }
          }
        }
      } else {
        print(responseData.body);
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      print(imageReferences);
      isLoading = false;
      notifyListeners();
    }
  }
}
