import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_auth.dart';
import '../utils/colors.dart';
import '../widgets/global/navigator_wrapper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final _auth = UserAuth();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  bool _isRegistering = false;

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
                            onChanged: (value) => setState(() => _name = value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mohon isi nama.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (value) =>
                                setState(() => _email = value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                            child: _isRegistering
                                ? const CircularProgressIndicator()
                                : const Text('Register'),
                            onPressed: () => _register(),
                          ),
                          TextButton(
                            child: const Text('Sudah memiliki akun? Login.'),
                            onPressed: () => GoRouter.of(context).pop(),
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isRegistering = true);

      try {
        UserCredential userCredential =
            await _auth.instance.createUserWithEmailAndPassword(
          email: _email.trim(),
          password: _password,
        );

        /// Update user's name
        await userCredential.user!.updateDisplayName(_name);

        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showSnackbar('Password terlalu lemah');
        } else if (e.code == 'email-already-in-use') {
          _showSnackbar('Email sudah digunakan oleh akun lain.');
        }
      } catch (e) {
        _showSnackbar('Terjadi kesalahan:\n$e');
      }

      setState(() => _isRegistering = false);
    }
  }
}
