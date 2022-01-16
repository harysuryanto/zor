import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:zor/firebase_options.dart';

import 'providers/auth.dart';
import 'screens/add_plan_screen.dart';
import 'screens/detail_plan_screen.dart';
import 'screens/exercising_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Auth();

    return StreamBuilder<User?>(
      stream: auth.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // print(snapshot.data);

          return MaterialApp(
            key: UniqueKey(),
            title: 'Zor',
            theme: FlexThemeData.light(scheme: FlexScheme.deepBlue),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepBlue),
            themeMode: ThemeMode.light,
            initialRoute: snapshot.data != null &&
                    (snapshot.data!.emailVerified || snapshot.data!.isAnonymous)
                ? '/home'
                : '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/detail-plan': (context) => const DetailPlanScreen(),
              '/add-plan': (context) => AddPlanScreen(),
              '/exercising': (context) => const ExercisingScreen(),
            },
          );
        }

        return const LoadingScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
