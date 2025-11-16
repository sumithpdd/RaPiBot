import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingNotificationWidget extends StatelessWidget {
  final Map<String, dynamic> meeting;
  final VoidCallback onDismiss;

  const MeetingNotificationWidget({
    super.key,
    required this.meeting,
    required this.onDismiss,
  });

  String _formatTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final meetingName = meeting['summary'] ?? 'No Title';
    final startTime = _formatTime(meeting['start'] ?? '');

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Meeting Upcoming',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 40),
            Text(
              meetingName,
              style: const TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              startTime,
              style: const TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

