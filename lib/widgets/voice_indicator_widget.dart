import 'package:flutter/material.dart';

/// Visual indicator for voice assistant state
class VoiceIndicatorWidget extends StatefulWidget {
  final bool isListening;
  final bool isSpeaking;
  
  const VoiceIndicatorWidget({
    super.key,
    required this.isListening,
    required this.isSpeaking,
  });
  
  @override
  State<VoiceIndicatorWidget> createState() => _VoiceIndicatorWidgetState();
}

class _VoiceIndicatorWidgetState extends State<VoiceIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: widget.isListening 
                    ? Colors.red.withOpacity(0.9)
                    : Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (widget.isListening ? Colors.red : Colors.blue)
                        .withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isListening ? Icons.mic : Icons.volume_up,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isListening ? 'Listening...' : 'Speaking...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

