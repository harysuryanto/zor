import 'package:flutter/material.dart';
import 'package:zor/widgets/exercise_list.dart';
import 'package:zor/widgets/news_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 60,
                  right: 30,
                  bottom: 30,
                  left: 30,
                ),
                child: Text(
                  'Hai Hary 👋',
                  style: TextStyle(fontSize: 18),
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
