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
      theme: FlexThemeData.light(scheme: FlexScheme.deepBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepBlue),
      themeMode: ThemeMode.light,
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail-plan': (context) => const DetailPlanScreen(),
        '/add-plan': (context) => AddPlanScreen(),
        '/exercising': (context) => const ExercisingScreen(),
      },
    );
  }
}
