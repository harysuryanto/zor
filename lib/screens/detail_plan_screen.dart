import 'package:flutter/material.dart';

import '../widgets/big/exercise_list.dart';

class DetailPlanScreen extends StatelessWidget {
  final String planId;

  const DetailPlanScreen({
    required this.planId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pratinjau Olahraga')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Body section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: ExerciseList(planId: planId),
            ),
          ),

          /// Bottom section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '20 menit',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Estimasi waktu total',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    print('Mulai olahraga 🏃‍♂️');

                    // context.push('/exercising?myExercises=$myExercises');
                  },
                  child: Row(
                    children: const [
                      Text(
                        'Mulai olahraga',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.run_circle_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
