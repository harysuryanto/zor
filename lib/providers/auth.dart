import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus {
    return auth.authStateChanges();
  }

  Future<bool> loginAnonymously() async {
    print('📥 Logged in');

    try {
      await auth.signInAnonymously();
      return true;
    } catch (e) {
      print('Exception: $e');
    }

    return false;
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('Something went wrong:\n$e');
    }

    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      /// TODO: Add a document containing user's [name]

      /// Send email verification
      await userCredential.user!.sendEmailVerification();

      /// Tell the user that we have sent verification email
      print('Verification email has been sent. Please verify your email.');

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Something went wrong:\n$e');
    }

    return false;
  }

  void logout() async {
    print('📤 Logged out');

    await auth.signOut();
  }
}
