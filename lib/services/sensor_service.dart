import 'dart:async';
import 'dart:math';

class SensorService {
  final Random _random = Random();
  
  /// Mock sensor data that simulates ENS160 (CO2) and TEMT6000 (light) sensors
  Stream<Map<String, dynamic>> getSensorDataStream() {
    return Stream.periodic(const Duration(seconds: 15), (_) {
      return _getMockSensorData();
    });
  }

  Map<String, dynamic> _getMockSensorData() {
    // Simulate different CO2 levels
    // Normal: 400-500, Yellow alert: 500-750, Red alert: 750-1500
    int co2Level = _generateCO2Level();
    
    // Simulate light intensity
    // Dark: < 10, Normal: >= 10
    double lightIntensity = _generateLightIntensity();

    return {
      'eCO2': co2Level,
      'light_intensity': lightIntensity,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  int _generateCO2Level() {
    // Generate different CO2 levels with weights
    int scenario = _random.nextInt(100);
    
    if (scenario < 60) {
      // 60% chance: Normal (400-500 ppm)
      return 400 + _random.nextInt(100);
    } else if (scenario < 85) {
      // 25% chance: Yellow alert (500-750 ppm)
      return 500 + _random.nextInt(250);
    } else {
      // 15% chance: Red alert (750-1500 ppm)
      return 750 + _random.nextInt(750);
    }
  }

  double _generateLightIntensity() {
    int scenario = _random.nextInt(100);
    
    if (scenario < 85) {
      // 85% chance: Normal light (10-100)
      return 10.0 + _random.nextDouble() * 90.0;
    } else {
      // 15% chance: Dark (0-10)
      return _random.nextDouble() * 10.0;
    }
  }

  /// Get a single reading (for testing)
  Future<Map<String, dynamic>> getCurrentReading() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _getMockSensorData();
  }
}

