import 'package:flutter/material.dart';
import 'package:zor/providers/workouts.dart';
import 'package:zor/widgets/custom_list_tile.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latihanmu',
                  style: TextStyle(fontSize: 18),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pushNamed(context, '/add-plan');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Buat baru',
                          style: TextStyle(fontSize: 12),
                        ),
                        Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.separated(
              itemBuilder: (context, index) {
                return CustomListTile(
                  key: UniqueKey(),
                  title: workouts[index].title,
                  subtitle: workouts[index].subtitle,
                  onTap: () {
                    Navigator.pushNamed(context, '/detail-plan');
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 20),
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
