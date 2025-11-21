import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    String videoSource = widget.videoPath;
    
    if (kIsWeb) {
      // For web, use network URL
      // widget.videoPath is "assets/animations/blink.mp4"
      // Flutter web on Raspberry Pi copies to build/web/assets/assets/animations/ (double assets!)
      // So URL must be "/assets/assets/animations/blink.mp4" to match actual build output
      final baseUrl = Uri.base.origin;
      
      // Remove any leading slash from videoSource
      videoSource = videoSource.replaceFirst(RegExp(r'^/'), '');
      
      // Flutter web duplicates "assets/" prefix on some platforms
      // videoSource is "assets/animations/blink.mp4"
      // Build output is at: build/web/assets/assets/animations/blink.mp4
      // So URL needs: /assets/assets/animations/blink.mp4
      // We add an extra "assets/" prefix to match the build output
      final fullUrl = '$baseUrl/assets/$videoSource';
      
      debugPrint('[VideoPlayer] Web: Original path: ${widget.videoPath}');
      debugPrint('[VideoPlayer] Web: Base URL: $baseUrl');
      debugPrint('[VideoPlayer] Web: Video source: $videoSource');
      debugPrint('[VideoPlayer] Web: Using network URL: $fullUrl');
      debugPrint('[VideoPlayer] Web: Expected file location: build/web/assets/$videoSource');
      _controller = VideoPlayerController.networkUrl(Uri.parse(fullUrl));
    } else {
      // For native platforms, use asset controller
      debugPrint('[VideoPlayer] Native: Using asset controller for: ${widget.videoPath}');
      _controller = VideoPlayerController.asset(widget.videoPath);
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) {
        _controller.setLooping(true);
        _controller.play();
        debugPrint('[VideoPlayer] ✓ Video ready: ${widget.videoPath}');
      }
    }).catchError((error, stackTrace) {
      // Handle video initialization errors gracefully
      debugPrint('[VideoPlayer] ✗ Initialization failed: $error');
      debugPrint('[VideoPlayer] Stack trace: $stackTrace');
      debugPrint('[VideoPlayer] Video path: ${widget.videoPath}');
      debugPrint('[VideoPlayer] Platform: ${kIsWeb ? "Web" : "Native"}');
      
      if (kIsWeb) {
        final expectedUrl = '${Uri.base.origin}/${widget.videoPath}';
        debugPrint('[VideoPlayer] Web: Make sure video files are in build/web/assets/animations/');
        debugPrint('[VideoPlayer] Web: Check browser console for CORS or 404 errors');
        debugPrint('[VideoPlayer] Web: Expected URL: $expectedUrl');
        debugPrint('[VideoPlayer] Web: Actual URL used: ${Uri.base.origin}/${videoSource.replaceFirst(RegExp(r'^/'), '')}');
      } else {
        debugPrint('[VideoPlayer] Native: Check if video file exists in assets/animations/');
        debugPrint('[VideoPlayer] Native: On Linux, install GStreamer: sudo apt install gstreamer1.0-plugins-base gstreamer1.0-libav');
        debugPrint('[VideoPlayer] Native: On Windows, ensure video codecs are installed');
      }
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

    // Create new controller (handle web vs native)
    setState(() {
      String videoSource = newPath;
      
      if (kIsWeb) {
        // For web, use network URL (same logic as initialization)
        final baseUrl = Uri.base.origin;
        
        // Remove any leading slash from videoSource
        videoSource = videoSource.replaceFirst(RegExp(r'^/'), '');
        
        // Flutter web duplicates "assets/" prefix, so add it to match build output
        final fullUrl = '$baseUrl/assets/$videoSource';
        
        _controller = VideoPlayerController.networkUrl(Uri.parse(fullUrl));
      } else {
        _controller = VideoPlayerController.asset(newPath);
      }
      
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
                    if (kIsWeb)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Web: Ensure video files are in build/web/assets/animations/\nCheck browser console for errors',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (isUnimplementedError)
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
