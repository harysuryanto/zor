import 'package:flutter/material.dart';
import 'package:zor/providers/workouts.dart';
import 'package:zor/widgets/exercise_list_tile.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: LimitedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Latihanmu',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ListView.separated(
              itemBuilder: (context, index) {
                return ExerciseListTile(
                  key: UniqueKey(),
                  title: workouts[index].title,
                  subtitle: workouts[index].subtitle,
                  onTap: () {
                    Navigator.pushNamed(context, '/add-exercise-plan');
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: workouts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
