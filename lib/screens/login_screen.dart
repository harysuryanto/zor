import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_auth.dart';
import '../utils/colors.dart';
import '../widgets/global/navigator_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = UserAuth();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoggingIn = false;
  bool _isLoggingInAnonimously = false;

  @override
  Widget build(BuildContext context) {
    return NavigatorWrapper(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Zor',
                      style: TextStyle(fontSize: 96),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            onChanged: (value) =>
                                setState(() => _email = value),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Mohon isi email yang valid.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (value) =>
                                setState(() => _password = value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mohon isi password yang valid.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            child: _isLoggingIn
                                ? const CircularProgressIndicator()
                                : const Text('Login'),
                            onPressed: () => _login(),
                          ),
                          TextButton(
                            child: _isLoggingInAnonimously
                                ? const CircularProgressIndicator()
                                : const Text('Lanjutkan secara anonim'),
                            onPressed: () => _loginAnonimously(),
                          ),
                          TextButton(
                            child: const Text('Belum memiliki akun? Register.'),
                            onPressed: () =>
                                GoRouter.of(context).push('/register'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoggingIn = true);

      try {
        await _auth.login(email: _email, password: _password);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showSnackbar('Tidak tersedia akun dengan email tersebut.');
        } else if (e.code == 'wrong-password') {
          _showSnackbar('Password salah.');
        }
      } catch (e) {
        _showSnackbar('Terjadi kesalahan:\n$e');
      }

      setState(() => _isLoggingIn = false);
    }
  }

  void _loginAnonimously() async {
    setState(() => _isLoggingInAnonimously = true);

    try {
      await _auth.loginAnonymously();
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go('/');
    } catch (e) {
      _showSnackbar('Terjadi kesalahan:\n$e');
    }

    setState(() => _isLoggingInAnonimously = false);
  }
}
