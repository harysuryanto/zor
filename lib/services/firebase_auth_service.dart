import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user.dart';

class FirebaseAuthService {
  final _instance = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    return user == null
        ? null
        : User(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
          );
  }

  Stream<User?>? get streamAuthStatus {
    return _instance.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> loginAnonymously() async {
    final credential = await _instance.signInAnonymously();
    return _userFromFirebase(credential.user);
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user!.updateDisplayName(displayName);

    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _instance.signOut();
  }
}
