import 'package:flutter/material.dart';
import 'package:zor/screens/add_exercise_plan_screen.dart';
import 'package:zor/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zor',
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-exercise-plan': (context) => const AddExercisePlanScreen(),
      },
    );
  }
}
