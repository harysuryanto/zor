import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeMobileAds();

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
      enabled: _isOnDesktopWeb,
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
      useInheritedMediaQuery: _isOnDesktopWeb,
      locale: _isOnDesktopWeb ? DevicePreview.locale(context) : null,
      builder: _isOnDesktopWeb ? DevicePreview.appBuilder : null,
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

final bool _isOnDesktopWeb = kIsWeb &&
    [
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ].contains(defaultTargetPlatform);

Future<void> initializeMobileAds() async {
  final List<String> testDeviceIds = [
    // My BlueStacks emulator
    '0CFD7285B3AC7B81A091D495F8C5F586',
    // My Redmi Note 7
    '7CBA92CE7C46B722EB64D3FA66AA3B73',
  ];

  MobileAds.instance.initialize();

  if (kDebugMode) {
    // Use test ads.
    MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testDeviceIds));
    log('Shows test ads.');
  }
}
