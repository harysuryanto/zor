import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/auth.dart';
import '../utils/colors.dart';
import '../widgets/small/navigator_wrapper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final auth = Auth();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    /// This NavigatorWrapper widget was made to solve an error
    /// where a TextField needs to be inside of MaterialApp() and not
    /// MaterialApp.router() or any other MaterialApp-like widget.
    /// I use MaterialApp.router() because go_router forced us to use it.
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
                      style: TextStyle(
                        fontSize: 96,
                      ),
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
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            child: _isRegistering
                                ? const CircularProgressIndicator()
                                : const Text('Register'),
                            onPressed: () {
                              _register();
                            },
                          ),
                          TextButton(
                            child: const Text('Sudah memiliki akun? Login.'),
                            onPressed: () {
                              context.pop();
                            },
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
            await auth.instance.createUserWithEmailAndPassword(
          email: _email.trim(),
          password: _password,
        );

        /// Update user's name
        await userCredential.user!.updateDisplayName(_name);

        context.go('/');
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
