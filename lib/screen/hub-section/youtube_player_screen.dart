import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({super.key, required this.videoId});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  bool isFullScreen = false;
  bool videoLike = false;
  bool videoSound = false;
  bool bookmark = false;
  late String authorName = '';
  late String title = '';
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    try {
      // Use a sample video URL that works with video_player
      // You can replace this with your actual video URLs
      String videoUrl =
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

      _videoPlayerController = VideoPlayerController.network(videoUrl);

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey[300]!,
        ),
        placeholder: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading Video...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Video Unavailable',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error initializing video player: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load video: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
            const Spacer(),
            IconButton(
              onPressed: () =>
                  Share.share('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      color: Colors.black,
                      child: _isLoading
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading Video...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _hasError
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Video Unavailable',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        _errorMessage,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLoading = true;
                                            _hasError = false;
                                            _errorMessage = '';
                                          });
                                          _initializeVideoPlayer();
                                        },
                                        child: Text('Retry'),
                                      ),
                                    ],
                                  ),
                                )
                              : _chewieController != null
                                  ? Chewie(controller: _chewieController!)
                                  : Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Text(
                                          'Video not available',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
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
                                icon: Icon(
                                  bookmark
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoSound = !videoSound;
                                  });
                                  if (videoSound) {
                                    _videoPlayerController.setVolume(0.0);
                                  } else {
                                    _videoPlayerController.setVolume(1.0);
                                  }
                                },
                                icon: Icon(
                                  videoSound
                                      ? Icons.volume_off
                                      : Icons.volume_up,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoLike = !videoLike;
                                  });
                                },
                                icon: Icon(
                                  videoLike
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: videoLike ? Colors.red : Colors.white,
                                  size: 28,
                                ),
                              )
                            ],
                          ),
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
