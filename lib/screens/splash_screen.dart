import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _videoPlayerController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();

    _timer = Timer(Duration(seconds: 4), _navigateToHome);
  }
  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.asset('assets/logo.mp4');

    _videoPlayerController.initialize().then((_) {
      setState(() {
        _videoPlayerController.play();
      });

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.isInitialized &&
            !_videoPlayerController.value.isPlaying &&
            !_videoPlayerController.value.isBuffering &&
            _videoPlayerController.value.position >=
                _videoPlayerController.value.duration) {
          _navigateToHome();
        }
      });
    }).catchError((error) {
      // Handle initialization error
      print("Error loading video: ${error.toString()}");
      _navigateToHome();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    if (mounted) {
      _timer.cancel(); // Cancel the timer if navigating successfully
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )
            : CircularProgressIndicator(), // Loading indicator while video initializes
      ),
    );
  }
}
