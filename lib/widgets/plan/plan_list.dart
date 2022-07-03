import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/exercise.dart';
import '../../models/plan.dart';
import '../../services/firestore_service.dart';
import 'add_plan.dart';
import 'plan_list_tile.dart';

class PlanList extends StatelessWidget {
  final int? limit;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  const PlanList({
    Key? key,
    this.limit,
    this.isScrollable = true,
    this.padding = const EdgeInsets.all(30),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context, listen: false);

    return StreamProvider<List<Plan>?>.value(
      value: db.streamPlans(limit: limit),
      initialData: null,
      builder: (BuildContext context, Widget? child) {
        final plans = Provider.of<List<Plan>?>(context);

        if (plans == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return plans.isEmpty
            ? const Center(child: Text('Tidak ada rencana.'))
            : ListView.separated(
                padding: padding,
                itemBuilder: (context, index) {
                  return StreamProvider<List<Exercise>>.value(
                    value: db.streamExercises(plans[index].id),
                    initialData: const [],
                    builder: (BuildContext context, Widget? child) {
                      final exercisesProvider =
                          Provider.of<List<Exercise>>(context);
                      String? exercisesName;
                      int? totalReps;
                      int? totalSets;
                      List<String>? schedules;

                      if (exercisesProvider.isNotEmpty) {
                        exercisesName = exercisesProvider
                            .map((exercise) => exercise.name)
                            .join(', ');
                        totalReps = exercisesProvider
                            .map((exercise) =>
                                exercise.repetitions * exercise.sets)
                            .reduce((a, b) => a + b);
                        totalSets = exercisesProvider
                            .map((exercise) => exercise.sets)
                            .reduce((a, b) => a + b);
                      }

                      schedules = plans[index].schedules.isNotEmpty
                          ? plans[index]
                              .schedules
                              .map((schedule) => (schedule[0].toUpperCase() +
                                      schedule.substring(1).toLowerCase())
                                  .toString())
                              .toList()
                          : null;

                      return PlanListTile(
                        key: ValueKey('plan list item ${plans[index].id}'),
                        title: plans[index].name,
                        subtitle: exercisesName,
                        schedules: schedules,
                        totalReps: totalReps,
                        totalSets: totalSets,
                        onTap: () => GoRouter.of(context)
                            .push('/detail-plan?planId=${plans[index].id}'),
                        onLongPress: () => onLongPress(
                          context,
                          db: db,
                          plan: plans[index],
                        ),
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
      },
    );
  }

  onLongPress(
    BuildContext context, {
    required FirestoreService db,
    required Plan plan,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                child: const Text('Ubah'),
                onPressed: () {
                  Navigator.pop(context);
                  showEditPlanDialog(context, plan);
                },
              ),
              TextButton(
                child: const Text('Hapus'),
                onPressed: () {
                  Navigator.pop(context);
                  showDeletePlanDialog(context, db, plan);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showEditPlanDialog(BuildContext context, Plan plan) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ubah Rencana Olahraga'),
          content: SizedBox(
            width: double.maxFinite,
            child: AddPlan(
              plan: plan,
              onFinish: () => Navigator.pop(context),
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeletePlanDialog(
    BuildContext context,
    FirestoreService db,
    Plan plan,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Yakin ingin menghapus rencana?'),
          actions: [
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                db.removePlan(plan.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dihapus')),
                );
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
