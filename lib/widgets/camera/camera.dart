// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:medizen/screen/planting-section/leafhealthdisplay.dart';

// class CameraComponent extends StatefulWidget {
//   const CameraComponent({super.key});

//   @override
//   _CameraComponentState createState() => _CameraComponentState();
// }

// class _CameraComponentState extends State<CameraComponent> {
//   CameraController? controller;
//   List<CameraDescription>? cameras;
//   late CameraDescription firstCamera;
//   ImagePicker picker = ImagePicker();
//   bool isCameraReady = false;
//   bool isFlashOn = false;
//   XFile? imageFile;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   Future<void> initializeCamera() async {
//     cameras = await availableCameras();
//     firstCamera = cameras!.first;

//     controller = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );

//     await controller!.initialize();
//     controller!.setFlashMode(FlashMode.off);
//     setState(() {
//       isCameraReady = true;
//     });
//   }

//   Future<void> pickImageFromGallery() async {
//     imageFile = await picker.pickImage(source: ImageSource.gallery);
//     if (imageFile != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LeafHealthDisplay(imageFile: imageFile),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   Future<void> takePicture() async {
//     if (!controller!.value.isInitialized) {
//       return;
//     }

//     if (controller!.value.isTakingPicture) {
//       return;
//     }

//     try {
//       imageFile = await controller!.takePicture();
//       setState(() {});
//       if (imageFile != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LeafHealthDisplay(imageFile: imageFile!),
//           ),
//         );
//       }
//     } catch (e) {
//       print(e);
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: isCameraReady
//           ? Container(
//               height: size.height,
//               color: Colors.black,
//               child: Column(
//                 children: [
//                   SafeArea(
//                     child: SizedBox(
//                       height: 60,
//                       width: size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: IconButton(
//                                 onPressed: () {},
//                                 icon: const Icon(Icons.arrow_back_ios_new,
//                                     color: Colors.white)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     isFlashOn = !isFlashOn;
//                                     if (isFlashOn) {
//                                       controller!.setFlashMode(FlashMode.torch);
//                                     } else {
//                                       controller!.setFlashMode(FlashMode.off);
//                                     }
//                                   });
//                                 },
//                                 icon: isFlashOn
//                                     ? const Icon(Icons.flash_on,
//                                         color: Colors.white)
//                                     : const Icon(Icons.flash_off,
//                                         color: Colors.white)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: size.width,
//                     height: size.height * 0.72,
//                     child: CameraPreview(
//                       controller!,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 40),
//                         child: Image.asset('assets/camera/camera_area.png',
//                             height: 50),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height * 0.15,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                             onPressed: pickImageFromGallery,
//                             icon: const Icon(Icons.photo_outlined,
//                                 size: 40, color: Colors.white)),
//                         InkWell(
//                             onTap: takePicture,
//                             child: Image.asset('assets/camera/capture.png',
//                                 height: 160, width: 160)),
//                         IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.help_outline,
//                                 size: 40, color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:camera/camera.dart';

import '../../screen/planting-section/leafhealthdisplay.dart';

class CameraComponent extends StatefulWidget {
  final Function(int value) addNewReading;
  CameraComponent({super.key, required this.addNewReading});

  @override
  _CameraComponentState createState() => _CameraComponentState();
}

class _CameraComponentState extends State<CameraComponent> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  late CameraDescription firstCamera;
  ImagePicker picker = ImagePicker();
  bool isCameraReady = false;
  bool isFlashOn = false;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras!.first;

    controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await controller!.initialize();
    controller!.setFlashMode(FlashMode.off);
    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> pickImageFromGallery() async {
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      double greenScore = await _calculateGreenScore(File(imageFile!.path));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeafHealthDisplay(
            greenScore: greenScore,
            addNewReading: (int value) => widget.addNewReading(value),
          ),
        ),
      );
    }
  }

  Future<void> takePicture() async {
    if (!controller!.value.isInitialized) {
      return;
    }

    if (controller!.value.isTakingPicture) {
      return;
    }

    try {
      imageFile = await controller!.takePicture();
      if (imageFile != null) {
        double greenScore = await _calculateGreenScore(File(imageFile!.path));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeafHealthDisplay(
              greenScore: greenScore,
              addNewReading: (int value) => widget.addNewReading(value),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<double> _calculateGreenScore(File imageFile) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(FileImage(imageFile));

    List<Color> colors = paletteGenerator.colors.toList();
    bool containsGreen = colors.any((color) {
      final hue = HSVColor.fromColor(color).hue;
      return hue >= 60 && hue <= 180; // Detect green hues
    });

    if (containsGreen) {
      double totalScore = 0;
      int greenCount = 0;

      for (Color color in colors) {
        final hsvColor = HSVColor.fromColor(color);
        final hue = hsvColor.hue;

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
    } else {
      return 0;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: isCameraReady
          ? Container(
              height: size.height,
              color: Colors.black,
              child: Column(
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: 60,
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFlashOn = !isFlashOn;
                                    if (isFlashOn) {
                                      controller!.setFlashMode(FlashMode.torch);
                                    } else {
                                      controller!.setFlashMode(FlashMode.off);
                                    }
                                  });
                                },
                                icon: isFlashOn
                                    ? const Icon(Icons.flash_on,
                                        color: Colors.white)
                                    : const Icon(Icons.flash_off,
                                        color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.72,
                    child: CameraPreview(
                      controller!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset('assets/camera/camera_area.png',
                            height: 50),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: pickImageFromGallery,
                            icon: const Icon(Icons.photo_outlined,
                                size: 40, color: Colors.white)),
                        InkWell(
                            onTap: takePicture,
                            child: Image.asset('assets/camera/capture.png',
                                height: 160, width: 160)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.help_outline,
                                size: 40, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}
