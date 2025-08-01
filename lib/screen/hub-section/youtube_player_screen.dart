import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pod_player/pod_player.dart';
import 'package:share_plus/share_plus.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({super.key, required this.videoId});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late PodPlayerController _controller;
  bool isFullScreen = false;
  bool videoLike = false;
  bool videoSound = false;
  bool bookmark = false;
  late String authorName = '';
  late String title = '';

  @override
  void initState() {
    super.initState();
    _controller = PodPlayerController(
        playVideoFrom:
            PlayVideoFrom.youtube('https://www.youtube.com/shorts/Soj8QxH-bto'),
        podPlayerConfig: const PodPlayerConfig(
            autoPlay: true, isLooping: false, videoQualityPriority: [720, 360]))
      ..initialise()
      ..addListener(() {
        if (_controller.videoPlayerValue?.hasError == true) {
          print(
              'Video Player Error: ${_controller.videoPlayerValue?.errorDescription}');
        }
      });

    // _loadVideoMetaData();

    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted &&
        _controller.videoPlayerValue != null &&
        _controller.videoPlayerValue!.isCompleted) {
      _controller.removeListener(_onControllerUpdate);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  // Future<void> _loadVideoMetaData() async {
  //   await _communityService.getVideoMetaData(widget.videoId);
  //   setState(() {
  //     authorName = _communityService.videoMetaData['author_name'] ?? 'Author Name';
  //     title = _communityService.videoMetaData['title'] ?? 'Author Name';
  //   });
  // }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.black,
        shadowColor: Colors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            // Text(
            //   authorName,
            //   style: const TextStyle(
            //     color: Colors.white,
            //     fontFamily: 'Poppins',
            //     fontSize: 20,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            const Spacer(),
            IconButton(
              onPressed: () =>
                  Share.share('https://www.youtube.com/shorts/Soj8QxH-bto'),
              icon: Icon(
                Icons.share,
                size: MediaQuery.of(context).size.height * 0.0325,
                color: Colors.white,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          ],
        ),
        leading: Center(
          child: IconButton(
            icon: Icon(Icons.chevron_left_sharp,
                size: MediaQuery.of(context).size.height * 0.045,
                color: Colors.white),
            onPressed: () {
              // Navigate back when pressed
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black, // Background color
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    PodVideoPlayer(
                      controller: _controller,
                      frameAspectRatio: isFullScreen ? 16 / 9 : 9 / 16,
                      videoAspectRatio: isFullScreen ? 16 / 9 : 9 / 16,
                      alwaysShowProgressBar: true,
                      onToggleFullScreen: (isFullScreen) async {
                        setState(() {
                          this.isFullScreen = isFullScreen;
                        });
                      },
                      podProgressBarConfig: const PodProgressBarConfig(
                          height: 2, curveRadius: 0, circleHandlerRadius: 0),
                      // videoThumbnail: DecorationImage(
                      //   image: NetworkImage(
                      //       'assets/Farming_Guides/${widget.videoId}.jpg'),
                      // ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0.5,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    bookmark = !bookmark;
                                  });
                                },
                                icon: SvgPicture.asset(
                                  bookmark
                                      ? 'assets/icons/Saved_post.svg'
                                      : 'assets/icons/Saved_pre.svg',
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoSound = !videoSound;
                                  });
                                  if (videoSound) {
                                    _controller.mute();
                                  } else {
                                    _controller.unMute();
                                  }
                                },
                                icon: SvgPicture.asset(
                                  videoSound
                                      ? 'assets/icons/Speaker_post.svg'
                                      : 'assets/icons/Speaker_pre.svg',
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoLike = !videoLike;
                                  });
                                },
                                icon: SvgPicture.asset(
                                  videoLike
                                      ? 'assets/icons/Like_post.svg'
                                      : 'assets/icons/Like_pre.svg',
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  fit: BoxFit.contain,
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 100,
                          //   child: ClipRect(
                          //     child: BackdropFilter(
                          //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          //       child: Container(
                          //         padding: const EdgeInsets.only(
                          //             left: 6, right: 10.0, top: 6),
                          //         color: Colors.transparent,
                          //         child: SingleChildScrollView(
                          //           child: Text(
                          //             title,
                          //             style: const TextStyle(
                          //               color: Colors.white,
                          //               fontFamily: 'Poppins',
                          //               fontSize: 20,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //             maxLines: 3,
                          //             overflow: TextOverflow.ellipsis,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}