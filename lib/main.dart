import 'package:flutter/material.dart';
import 'package:pomodoro_app/provider/timer_provider.dart';
import 'package:pomodoro_app/screens/home_screen.dart';
import 'package:pomodoro_app/screens/setting_screen.dart';
import 'package:pomodoro_app/static/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home.name,
        routes: {
          Routes.home.name: (context) => const HomeScreen(),
          Routes.setting.name: (context) => const SettingScreen(),
        },
      ),
    );
  }
}
