import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final bool _isAllowedToLoginAnonymously = false;

  String? _email;
  String? _password;
  bool _isLoggingIn = false;
  bool _isLoggingInAsGuest = false;
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
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Zor',
                          style: TextStyle(fontSize: 96),
                        ),
                        Text(
                          'Rencanakan olahragamu',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Theme(
                        data: _themeData(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              onChanged: (value) =>
                                  setState(() => _email = value),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
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
                              onPressed: () => _login(),
                              child: _isLoggingIn
                                  ? const _ProgressIndicator()
                                  : const Text('Login'),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => _loginAsGuest(),
                              child: _isLoggingInAsGuest
                                  ? const _ProgressIndicator()
                                  : const Text(
                                      'Login dengan akun demo',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                            ),
                            if (_isAllowedToLoginAnonymously)
                              TextButton(
                                onPressed: () => _loginAnonimously(),
                                child: _isLoggingInAnonimously
                                    ? const _ProgressIndicator()
                                    : const Text(
                                        'Login secara anonim',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                              ),
                            TextButton(
                              onPressed: () =>
                                  GoRouter.of(context).push('/register'),
                              child: const Text(
                                'Belum memiliki akun? Register di sini',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
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

  void _login({String? email, String? password}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoggingIn = true);

      try {
        await _auth.login(
            email: _email ?? email!, password: _password ?? password!);
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

  void _loginAsGuest() async {
    setState(() => _isLoggingInAsGuest = true);

    try {
      await _auth.login(email: 'demo@email.com', password: '123456');
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

    setState(() => _isLoggingInAsGuest = false);
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

  ThemeData _themeData(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      textTheme: GoogleFonts.poppinsTextTheme(),
      elevatedButtonTheme: Theme.of(context).elevatedButtonTheme,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: darkColor),
        errorStyle: TextStyle(color: darkColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: darkColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: blackColor),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 21,
      height: 21,
      child: CircularProgressIndicator(
        color: whiteColor,
        strokeWidth: 3,
      ),
    );
  }
}
