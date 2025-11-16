import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/sensor_service.dart';
import 'services/calendar_service.dart';
import 'providers/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set app to fullscreen (for Raspberry Pi kiosk mode)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider(create: (_) => SensorService()),
        Provider(create: (_) => CalendarService()),
      ],
      child: MaterialApp(
        title: 'RaPiBot - Pomodoro Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1e1e2e),
          fontFamily: 'Orbitron',
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

