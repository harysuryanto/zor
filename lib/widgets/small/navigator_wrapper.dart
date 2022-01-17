import 'package:flutter/material.dart';

class NavigatorWrapper extends StatefulWidget {
  /// This NavigatorWrapper widget was made to solve an error
  /// where a TextField needs to be inside of MaterialApp() and not
  /// MaterialApp.router() or any other MaterialApp-like widget.
  /// I use MaterialApp.router() because go_router forced us to use it.

  final Widget child;

  const NavigatorWrapper({required this.child, Key? key}) : super(key: key);

  @override
  State<NavigatorWrapper> createState() => _NavigatorWrapperState();
}

class _NavigatorWrapperState extends State<NavigatorWrapper> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => widget.child,
      ),
    );
  }
}
