import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

void main() {
  runApp(LeafColorChartApp());
}

class LeafColorChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaf Color Chart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LeafColorChartPage(),
    );
  }
}

class LeafColorChartPage extends StatefulWidget {
  @override
  _LeafColorChartPageState createState() => _LeafColorChartPageState();
}

class _LeafColorChartPageState extends State<LeafColorChartPage> {
  File? _image;
  List<Color> _colors = [];
  double _score = 0;
  bool _containsGreen = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(FileImage(imageFile));

      setState(() {
        _image = imageFile;
        _colors = paletteGenerator.colors.toList();
        _containsGreen = _colors.any((color) {
          final hue = HSVColor.fromColor(color).hue;
          return hue >= 60 && hue <= 180; // Detect green hues
        });
        if (_containsGreen) {
          _score = _calculateGreennessScore(_colors);
        } else {
          _score = 0;
        }
      });
    }
  }

  double _calculateGreennessScore(List<Color> colors) {
    double totalScore = 0;
    int greenCount = 0;

    for (Color color in colors) {
      final hsvColor = HSVColor.fromColor(color);
      final hue = hsvColor.hue;

      // Only calculate score for green hues
      if (hue >= 60 && hue <= 180) {
        greenCount++;
        if (hue >= 60 && hue < 100) {
          totalScore += 3; // Yellow-green
        } else if (hue >= 100 && hue < 140) {
          totalScore += 4; // Pure green
        } else if (hue >= 140 && hue <= 180) {
          totalScore += 2; // Blue-green
        }
      }
    }

    return greenCount > 0 ? totalScore / greenCount : 0;
  }

  Widget _buildColorChart() {
    return _containsGreen
        ? Wrap(
            spacing: 8.0,
            children: _colors
                .map(
                  (color) => Container(
                    width: 50,
                    height: 50,
                    color: color,
                  ),
                )
                .toList(),
          )
        : Text(
            'Expected a leaf image.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaf Color Chart'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? Text('No image selected.')
              : Image.file(_image!, height: 200),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Text('Take Photo'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Text('Choose from Gallery'),
          ),
          SizedBox(height: 20),
          _buildColorChart(),
          SizedBox(height: 20),
          _containsGreen
              ? Text(
                  'Greenness Score: ${_score.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : Container(),
        ],
      ),
    );
  }
}
