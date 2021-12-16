import 'package:flutter/material.dart';
import 'package:zor/widgets/small/custom_button.dart';

class ExercisingScreen extends StatelessWidget {
  const ExercisingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 60,
                right: 30,
                bottom: 20,
                left: 30,
              ),
              child: Text(
                'Workout Senin (Exercising Screen)',
                style: TextStyle(fontSize: 18),
              ),
            ),

            /// List of exercises
            /// TODO: finish it
            const Spacer(),

            /// Bottom section
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 30,
                bottom: 30,
                left: 30,
              ),
              child: CustomButton(
                title: 'Selesai',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
