import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus {
    return auth.authStateChanges();
  }

  bool isLoggedIn = false;

  void loginAnonymously() async {
    isLoggedIn = true;
    // print('📥 Logged in');

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print('Exception: $e');
    }

    // notifyListeners();
  }

  void logout() async {
    isLoggedIn = false;
    // print('📤 Logged out');

    await FirebaseAuth.instance.signOut();

    // notifyListeners();
  }
}
