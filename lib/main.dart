import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/user_auth.dart';
import 'screens/add_plan_screen.dart';
import 'screens/all_plans_screen.dart';
import 'screens/detail_plan_screen.dart';
import 'screens/exercising_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'utils/theme.dart';

bool isOnDesktopWeb = kIsWeb &&
    [
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ].contains(defaultTargetPlatform);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase configurations from FlutterFire CLI,
  /// visit https://firebase.flutter.dev/docs/cli
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Turn off the # in the URLs on the web
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  runApp(
    DevicePreview(
      defaultDevice: Devices.android.samsungGalaxyS20,
      backgroundColor: Colors.black87,
      isToolbarVisible: false,
      enabled: isOnDesktopWeb,
      builder: (context) => MultiProvider(
        providers: [
          StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(),
            initialData: null,
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zor',
      themeMode: MyTheme.themeMode,
      theme: MyTheme.theme,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,

      // For DevicePreview purpose
      useInheritedMediaQuery: isOnDesktopWeb,
      locale: isOnDesktopWeb ? DevicePreview.locale(context) : null,
      builder: isOnDesktopWeb ? DevicePreview.appBuilder : null,
    );
  }

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
        path: '/all-plans',
        builder: (context, state) {
          return const AllPlansScreen();
        },
      ),
      GoRoute(
        path: '/detail-plan',
        builder: (context, state) {
          final String planId = state.queryParams['planId']!;
          return DetailPlanScreen(planId: planId);
        },
      ),
      GoRoute(
        path: '/add-plan',
        builder: (context, state) => const AddPlanScreen(),
      ),
      GoRoute(
        path: '/exercising',
        builder: (context, state) {
          final String planId = state.queryParams['planId']!;
          return ExercisingScreen(planId: planId);
        },
      ),
    ],
    redirect: (state) {
      final auth = UserAuth();

      /// Check wheter the user has logged in or not
      final loggedIn = auth.isLoggedIn;

      /// Check wheter the user in in login screen or register screen
      final loggingIn = state.subloc == '/login' || state.subloc == '/register';

      /// Will redirect to login screen if the user is not logged in
      /// and is not in login screen or register screen
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      /// Will redirect to home screen if the user has logged in
      /// and is in login screen or register screen
      if (loggedIn && loggingIn) {
        return '/';
      }

      return null;
    },
  );
}
