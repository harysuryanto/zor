import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth.dart';
import '../widgets/big/exercise_list.dart';
import '../widgets/big/news_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String get _displayName {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return currentUser.displayName ?? currentUser.email ?? currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Auth();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                  right: 30,
                  bottom: 30,
                  left: 30,
                ),
                child: Text(
                  '👋 Hai, $_displayName',
                  style: const TextStyle(fontSize: 18),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: () {
                    auth.logout();

                    context.go('/login');
                  },
                  child: const Text('Logout'),
                ),
              ),

              /// News Carousel
              NewsCarousel(key: UniqueKey()),

              const SizedBox(height: 30),

              /// List of Exercise
              const ExerciseList(),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
