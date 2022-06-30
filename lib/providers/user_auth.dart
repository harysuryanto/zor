import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  FirebaseAuth instance = FirebaseAuth.instance;

  Stream<User?>? get streamAuthStatus {
    return instance.authStateChanges();
  }

  Future<void> loginAnonymously() async {
    await instance.signInAnonymously();
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    UserCredential userCredential =
        await instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await userCredential.user!.updateDisplayName(displayName);

    return userCredential;
  }

  Future<void> signOut() async {
    await instance.signOut();
  }
}
