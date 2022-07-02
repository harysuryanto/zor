import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/exercise.dart';
import '../../models/plan.dart';
import '../../services/firestore_service.dart';
import 'plan_reminder_list_tile.dart';

class PlanReminderList extends StatelessWidget {
  const PlanReminderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context, listen: false);

    final String todayInWeekday = DateFormat('EEEE').format(DateTime.now());

    // return _showTemplate();
    return StreamProvider<List<Plan>>.value(
      value: db.streamPlans(whereScheduleIs: todayInWeekday.toLowerCase()),
      initialData: const [],
      builder: (BuildContext context, Widget? child) {
        final plans = Provider.of<List<Plan>>(context);
        return plans.isEmpty
            ? const Center(child: Text('Tidak ada jadwal hari ini.'))
            : LimitedBox(
                maxHeight: 82,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return StreamProvider<List<Exercise>>.value(
                      value: db.streamExercises(plans[index].id),
                      initialData: const [],
                      builder: (BuildContext context, Widget? child) {
                        final exercisesProvider =
                            Provider.of<List<Exercise>>(context);
                        final exercisesCount = exercisesProvider.length;
                        final totalReps = exercisesProvider.isNotEmpty
                            ? exercisesProvider
                                .map((exercise) =>
                                    exercise.repetitions * exercise.sets)
                                .reduce((a, b) => a + b)
                            : 0;

                        return PlanReminderListTile(
                          key: ValueKey(
                              'plan reminder list item ${plans[index].id}'),
                          title: plans[index].name,
                          subTitle:
                              '$exercisesCount latihan | $totalReps rep total',
                          onTap: () => GoRouter.of(context)
                              .push('/detail-plan?planId=${plans[index].id}'),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 0),
                  itemCount: plans.length,
                ),
              );
      },
    );
  }

  Widget _showTemplate() => LimitedBox(
        maxHeight: 82,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
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
            )
          ],
        ),
      );
}
