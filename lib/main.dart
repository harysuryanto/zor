import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/add_plan_screen.dart';
import 'screens/all_plans_screen.dart';
import 'screens/detail_plan_screen.dart';
import 'screens/exercising_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/firebase_auth_service.dart';
import 'utils/theme.dart';
import 'widgets/global/auth_wrapper.dart';
import 'widgets/global/custom_scroll_behavior.dart';

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
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService?>(
          create: (_) => FirebaseAuthService(),
        )
      ],
      child: AuthWrapper(
        signedInScreen: MaterialApp.router(
          scrollBehavior: CustomScrollBehavior().copyWith(scrollbars: false),
          title: 'Zor',
          themeMode: MyTheme.themeMode,
          theme: MyTheme.theme,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,

          // For DevicePreview purpose
          useInheritedMediaQuery: _isOnDesktopWeb,
          locale: _isOnDesktopWeb ? DevicePreview.locale(context) : null,
          builder: _isOnDesktopWeb ? DevicePreview.appBuilder : null,
        ),
        notSignedInScreen: MaterialApp(
          title: 'Zor - Authentication',
          themeMode: MyTheme.themeMode,
          theme: MyTheme.theme,
          home: const LoginScreen(),
        ),
      ),
    );
  }

  final _router = GoRouter(
    routes: [
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
