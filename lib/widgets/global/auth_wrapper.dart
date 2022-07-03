import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/theme.dart';

/// Shows which screen according to the user authentication
class AuthWrapper extends StatelessWidget {
  /// Shows this screen if user is signed in
  final Widget signedInScreen;

  /// Shows this screen if user is not signed in
  final Widget notSignedInScreen;

  const AuthWrapper({
    Key? key,
    required this.signedInScreen,
    required this.notSignedInScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.streamAuthStatus,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          // if signed in, return GoRouter
          if (user != null) {
            return MultiProvider(
              providers: [
                Provider<User>.value(value: user),
                Provider<FirestoreService>(
                  create: (_) => FirestoreService(uid: user.uid),
                ),
              ],
              child: signedInScreen,
            );
          }

          return notSignedInScreen;
        }

        return MaterialApp(
          title: 'Zor',
          themeMode: MyTheme.themeMode,
          theme: MyTheme.theme,
          home: const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
