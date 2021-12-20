import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'screens/add_plan_screen.dart';
import 'screens/detail_plan_screen.dart';
import 'screens/exercising_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zor',
      // The Mandy red, light theme.
      theme: FlexThemeData.light(scheme: FlexScheme.deepBlue),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepBlue),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail-plan': (context) => const DetailPlanScreen(),
        '/add-plan': (context) => AddPlanScreen(),
        '/exercising': (context) => ExercisingScreen(),
      },
    );
  }
}
