import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'providers/auth.dart';
import 'screens/add_plan_screen.dart';
import 'screens/detail_plan_screen.dart';
import 'screens/exercising_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // turn off the # in the URLs on the web
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/detail-plan',
        builder: (context, state) {
          final String myExercises = state.queryParams['myExercises']!;
          return DetailPlanScreen(myExercises: myExercises);
        },
      ),
      GoRoute(
        path: '/add-plan',
        builder: (context, state) => AddPlanScreen(),
      ),
      GoRoute(
        path: '/exercising',
        builder: (context, state) => const ExercisingScreen(),
      ),
    ],
    initialLocation: '/login',

    /// TODO: Fix this authorization
    /* navigatorBuilder: (context, state, child) {
      final currentUser = FirebaseAuth.instance.currentUser;

      // Tell the user to log in if has not
      if (currentUser == null) {
        return const LoginScreen();
      }

      return const HomeScreen();
    }, */
  );

  @override
  Widget build(BuildContext context) {
    final auth = Auth();

    return StreamBuilder<User?>(
      stream: auth.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // print(snapshot.data);

          return MaterialApp.router(
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            title: 'Zor',
            theme: FlexThemeData.light(scheme: FlexScheme.deepBlue).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            )),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepBlue),
            themeMode: ThemeMode.light,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
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
