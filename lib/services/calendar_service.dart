import 'dart:async';
import 'dart:math';

class CalendarService {
  final Random _random = Random();
  
  /// Mock calendar service that simulates Google Calendar API
  /// Returns events that might be upcoming within the next 15 minutes
  Stream<List<Map<String, dynamic>>> getUpcomingEventsStream() {
    return Stream.periodic(const Duration(minutes: 1), (_) {
      return _getMockEvents();
    });
  }

  List<Map<String, dynamic>> _getMockEvents() {
    final now = DateTime.now();
    final events = <Map<String, dynamic>>[];

    // Randomly generate events (30% chance per check)
    if (_random.nextInt(100) < 30) {
      events.add(_generateMockEvent(now));
    }

    return events;
  }

  Map<String, dynamic> _generateMockEvent(DateTime now) {
    final eventNames = [
      'Team Standup',
      'Project Review',
      'Client Call',
      'Design Review',
      'Sprint Planning',
      'Code Review Session',
      '1:1 Meeting',
      'Product Demo',
      'Architecture Discussion',
      'Coffee Chat',
    ];

    // Generate event starting in 5-15 minutes
    final minutesUntilStart = 5 + _random.nextInt(11);
    final startTime = now.add(Duration(minutes: minutesUntilStart));
    final endTime = startTime.add(const Duration(minutes: 30));

    return {
      'summary': eventNames[_random.nextInt(eventNames.length)],
      'start': startTime.toIso8601String(),
      'end': endTime.toIso8601String(),
      'id': 'event_${startTime.millisecondsSinceEpoch}',
    };
  }

  /// Get events for testing
  Future<List<Map<String, dynamic>>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockEvents();
  }

  /// Check if an event is within the alert threshold (15 minutes)
  bool isEventUpcoming(Map<String, dynamic> event) {
    try {
      final now = DateTime.now();
      final startTime = DateTime.parse(event['start']);
      final alertThreshold = now.add(const Duration(minutes: 15));

      return now.isBefore(startTime) && startTime.isBefore(alertThreshold);
    } catch (e) {
      return false;
    }
  }

  /// Format event start time for display
  String formatEventTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return 'Unknown';
    }
  }
}

