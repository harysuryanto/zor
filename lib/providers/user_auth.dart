import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  FirebaseAuth instance = FirebaseAuth.instance;

  Stream<User?>? get streamAuthStatus {
    return instance.authStateChanges();
  }

  bool get isLoggedIn {
    return instance.currentUser != null;
  }

  Future<void> loginAnonymously() async {
    await instance.signInAnonymously();
  }

  Future<void> login({required String email, required String password}) async {
    await instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await instance.signOut();
  }
}
