import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String _currentPath = '';

  @override
  void initState() {
    super.initState();
    _currentPath = widget.videoPath;
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) {
        _controller.setLooping(true);
        _controller.play();
        debugPrint('[VideoPlayer] ✓ Video ready: ${widget.videoPath}');
      }
    }).catchError((error) {
      // Handle video initialization errors gracefully (e.g., GStreamer not installed on Linux)
      debugPrint('[VideoPlayer] ✗ Initialization failed: $error');
      debugPrint('[VideoPlayer] Note: On Linux, install GStreamer: sudo apt install gstreamer1.0-plugins-base gstreamer1.0-libav');
      // Re-throw to be caught by FutureBuilder
      throw error;
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      debugPrint('[VideoPlayer] Switching video: ${oldWidget.videoPath} → ${widget.videoPath}');
      _switchVideo(widget.videoPath);
    }
  }

  void _switchVideo(String newPath) {
    if (_currentPath == newPath) return;
    
    _currentPath = newPath;
    
    // Pause and dispose old controller
    if (_controller.value.isInitialized) {
      _controller.pause();
    }
    _controller.dispose();

    // Create new controller
    setState(() {
      _controller = VideoPlayerController.asset(newPath);
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        if (mounted) {
          _controller.setLooping(true);
          _controller.play();
          debugPrint('[VideoPlayer] ✓ Video ready: $newPath');
        }
      }).catchError((error) {
        // Handle video initialization errors gracefully
        debugPrint('[VideoPlayer] ✗ Failed to switch video: $error');
        throw error;
      });
    });
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.pause();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Error state - video player not available (e.g., GStreamer not installed on Linux)
            final error = snapshot.error;
            final isUnimplementedError = error.toString().contains('UnimplementedError') ||
                                        error.toString().contains('init() has not been implemented');
            
            // Only log non-expected errors
            if (!isUnimplementedError) {
              debugPrint('[VideoPlayer] ✗ Error: $error');
            }
            
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_off, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Video playback not available',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    if (isUnimplementedError)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Install GStreamer on Linux:\nsudo apt install gstreamer1.0-plugins-base gstreamer1.0-libav',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Text(
                        _currentPath.split('/').last,
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                  ],
                ),
              ),
            );
          }
          
          // Video is ready - display it
          debugPrint('[VideoPlayer] 🎥 Rendering: ${_currentPath.split('/').last}');
          return Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        } else {
          // Loading state
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Loading: ${_currentPath.split('/').last}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
