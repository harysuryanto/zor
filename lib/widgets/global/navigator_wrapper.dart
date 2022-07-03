import 'package:flutter/material.dart';

/// This NavigatorWrapper widget was made to solve an error
/// where a TextField needs to be inside of MaterialApp() and not
/// MaterialApp.router() or any other MaterialApp-like widget.
/// I use MaterialApp.router() because go_router forced us to use it.
class NavigatorWrapper extends StatelessWidget {
  final Widget child;

  const NavigatorWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => child,
      ),
    );
  }
}
