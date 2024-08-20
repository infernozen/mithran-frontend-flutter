import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:developer' as dev;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile>? _mediaFileList;
  RecognizedText? _recognizedText;
  final textRecognizer = TextRecognizer();

  final maxWidth = 393.7272727272727;
  double _scale = 1.0;
  String text = "";
  final ValueNotifier<bool> _isSelecting = ValueNotifier<bool>(false);

  Future<Size> _getImageResolution(XFile imageFile) {
    final File file = File(imageFile.path);
    final img = Image.file(file);
    final ImageStream stream = img.image.resolve(ImageConfiguration.empty);
    final Completer<Size> completer = Completer<Size>();

    stream.addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      completer.complete(Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      ));
    }));

    return completer.future;
  }

  void _setImageFileListFromFile(XFile? value) async {
    _mediaFileList = value == null ? null : <XFile>[value];
    if (_mediaFileList != null) {
      final image = _mediaFileList![0];
      final size = await _getImageResolution(image);
      setState(() {
        _scale = maxWidth / size.width;
      });
    }
  }

  Future<RecognizedText> _processImage(XFile? pickedFile) async {
    final image = pickedFile == null ? null : File(pickedFile.path);
    final inputImage = InputImage.fromFile(image!);
    final recognizedText = await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final String text = block.text;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      dev.log("rect: $rect");
      dev.log("text: $text");
      dev.log("cornerPoints: $cornerPoints");
    }

    return recognizedText;
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        final text = await _processImage(pickedFile);
        setState(() {
          _setImageFileListFromFile(pickedFile);
          _recognizedText = text;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  void dispose() {
    _isSelecting.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
                label: 'image_picker_example_picked_image',
                child: SelectionArea(
                  child: Column(
                    children: [
                      Stack(children: [
                        kIsWeb
                            ? Image.network(_mediaFileList![index].path)
                            : Image.file(
                                File(_mediaFileList![index].path),
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return const Center(
                                      child: Text(
                                          'This image type is not supported'));
                                },
                              ),
                        CustomPaint(
                          painter: TextBlocksPainter(
                              _recognizedText!.blocks, _scale),
                        ),
                      ]),
                      Text(
                        _recognizedText!.text,
                      ),
                    ],
                  ),
                ));
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    _isSelecting.value = true;
    for (var block in _recognizedText!.blocks) {
      final String text = block.text;
      final List<Point<int>> cornerPoints = block.cornerPoints;

      // Create a Path from the corner points
      final path = Path()
        ..moveTo(cornerPoints.first.x.toDouble() * _scale,
            cornerPoints.first.y.toDouble() * _scale);
      for (var i = 1; i < cornerPoints.length; i++) {
        path.lineTo(cornerPoints[i].x.toDouble() * _scale,
            cornerPoints[i].y.toDouble() * _scale);
      }
      path.close();

      // Check if the event position is within the polygon
      if (path.contains(Offset(
          event.position.dx,
          event.position.dy -
              kToolbarHeight -
              MediaQuery.of(context).padding.top))) {
        dev.log("Position is inside the polygon.");
        dev.log("Text: $text");
        // setState(() {
        //   this.text = text;
        // });
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {}

  void _onPointerUp(PointerUpEvent event) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        child: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                ? FutureBuilder<void>(
                    future: retrieveLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        case ConnectionState.done:
                          return _handlePreview();
                        case ConnectionState.active:
                          if (snapshot.hasError) {
                            return Text(
                              'Pick image/video error: ${snapshot.error}}',
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const Text(
                              'You have not yet picked an image.',
                              textAlign: TextAlign.center,
                            );
                          }
                      }
                    },
                  )
                : _handlePreview(),
          );
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class TextBlocksPainter extends CustomPainter {
  final List<TextBlock> textBlocks;
  final double scale;

  TextBlocksPainter(this.textBlocks, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var block in textBlocks) {
      for (var line in block.lines) {
        for (var element in line.elements) {
          final path = Path()
            ..moveTo(element.cornerPoints[0].x.toDouble() * scale,
                element.cornerPoints[0].y.toDouble() * scale);

          for (var i = 1; i < element.cornerPoints.length; i++) {
            path.lineTo(element.cornerPoints[i].x.toDouble() * scale,
                element.cornerPoints[i].y.toDouble() * scale);
          }
          path.close();

          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
