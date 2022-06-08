import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../databases/database.dart';
import '../../models/exercise.dart';
import '../../models/plan.dart';
import 'plan_list_tile.dart';

class PlanList extends StatelessWidget {
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  const PlanList({
    Key? key,
    this.isScrollable = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User?>(context, listen: false);
    final plans = Provider.of<List<Plan>>(context);

    return plans.isEmpty
        ? const Text('No plans.')
        : ListView.separated(
            padding: padding,
            itemBuilder: (context, index) {
              return StreamProvider<List<Exercise>>.value(
                value: db.streamExercises(user!, plans[index].id),
                initialData: const [],
                builder: (BuildContext context, Widget? child) {
                  final exercisesProvider =
                      Provider.of<List<Exercise>>(context);
                  final exercisesName = exercisesProvider.isNotEmpty
                      ? exercisesProvider
                          .map((exercise) => exercise.name)
                          .join(', ')
                      : null;
                  final totalReps = exercisesProvider.isNotEmpty
                      ? exercisesProvider
                          .map((exercise) =>
                              exercise.repetitions * exercise.sets)
                          .reduce((a, b) => a + b)
                      : null;
                  final totalSets = exercisesProvider.isNotEmpty
                      ? exercisesProvider
                          .map((exercise) => exercise.sets)
                          .reduce((a, b) => a + b)
                      : null;

                  final schedules = plans[index].schedules.isNotEmpty
                      ? plans[index]
                          .schedules
                          .map((schedule) => (schedule[0].toUpperCase() +
                                  schedule.substring(1).toLowerCase())
                              .toString())
                          .toList()
                      : null;

                  return PlanListTile(
                    key: ValueKey(plans[index].id),
                    title: plans[index].name,
                    subtitle: exercisesName,
                    schedules: schedules,
                    totalReps: totalReps,
                    totalSets: totalSets,
                    onTap: () =>
                        context.push('/detail-plan?planId=${plans[index].id}'),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemCount: plans.length,
            shrinkWrap: !isScrollable,
            physics: isScrollable
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),

            /// The children which are not visible will be disposed
            /// and garbage collected automatically
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
          );
  }
}
