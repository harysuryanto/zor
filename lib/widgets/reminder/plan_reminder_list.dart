import 'package:flutter/material.dart';

import 'plan_reminder_list_tile.dart';

class PlanReminderList extends StatelessWidget {
  const PlanReminderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: const [
            PlanReminderListTile(
              key: ValueKey('remider1'),
              title: 'Workout Upper Body',
              subTitle: '6 latihan | 30 rep total',
            ),
            PlanReminderListTile(
              key: ValueKey('remider2'),
              title: 'Workout Upper Body',
              subTitle: '6 latihan | 30 rep total',
            ),
            PlanReminderListTile(
              key: ValueKey('remider3'),
              title: 'Workout Lower Body',
              subTitle: '12 latihan | 48 rep total',
            ),
            PlanReminderListTile(
              key: ValueKey('remider4'),
              title: 'Workout Upper Body',
              subTitle: '6 latihan | 30 rep total',
            ),
            PlanReminderListTile(
              key: ValueKey('remider5'),
              title: 'Workout Lower Body',
              subTitle: '12 latihan | 48 rep total',
            ),
          ],
        ),
      ),
    );
  }
}
