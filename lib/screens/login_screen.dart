import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth.dart';
import '../utils/colors.dart';
import '../widgets/small/navigator_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = Auth();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoggingIn = false;
  bool _isLoggingInAnonimously = false;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                flex: 1,
                child: Center(
                  child: Text(
                    'Zor',
                    style: TextStyle(
                      fontSize: 96,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: Padding(
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
                            child: _isLoggingIn
                                ? const CircularProgressIndicator()
                                : const Text('Login'),
                            onPressed: () {
                              _login();
                            },
                          ),
                          TextButton(
                            child: _isLoggingInAnonimously
                                ? const CircularProgressIndicator()
                                : const Text('Lanjutkan secara anonim'),
                            onPressed: () {
                              _loginAnonimously();
                            },
                          ),
                          TextButton(
                            child: const Text('Belum memiliki akun? Register.'),
                            onPressed: () {
                              context.push('/register');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        await auth.login(email: _email, password: _password);
        context.go('/');
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
      await auth.loginAnonymously();
      context.go('/');
    } catch (e) {
      _showSnackbar('Terjadi kesalahan:\n$e');
    }

    setState(() => _isLoggingInAnonimously = false);
  }
}
