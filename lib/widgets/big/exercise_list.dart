import 'package:flutter/material.dart';
import 'package:zor/widgets/small/custom_list_tile.dart';
import 'package:zor/models/plans.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    const int myUserId = 1001;
    final List myPlans = plans.where((i) => i.userId == myUserId).toList();

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
                final String subtitle =
                    myPlans[index].exercises!.map((i) => i.name).join(', ');
                return CustomListTile(
                  key: UniqueKey(),
                  title: myPlans[index].name,
                  subtitle: subtitle,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail-plan',
                      arguments: {'myExercises': myPlans[index].exercises},
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemCount: myPlans.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              /// The children which are not visible will be disposed
              /// and garbage collected automatically
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
            ),
          ],
        ),
      ),
    );
  }
}
