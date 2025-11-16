import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;
  final VoidCallback onCancel;

  const TimerWidget({
    super.key,
    required this.seconds,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    return Container(
      color: const Color(0xFF1e1e2e),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timeString,
              style: const TextStyle(
                fontSize: 150,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.close),
              label: const Text('Cancel', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Press ESC to cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

