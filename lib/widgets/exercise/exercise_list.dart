import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../databases/database.dart';
import '../../models/exercise.dart';
import '../../utils/colors.dart';
import '../global/dismissible_background.dart';
import '../plan/plan_list_tile.dart';

class ExerciseList extends StatelessWidget {
  final String planId;
  final EdgeInsetsGeometry? padding;

  const ExerciseList({
    Key? key,
    required this.planId,
    this.padding = const EdgeInsets.all(30),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User?>(context, listen: false);

    return StreamProvider<List<Exercise>>.value(
      value: db.streamExercises(user!, planId),
      initialData: const [],
      builder: (BuildContext context, Widget? child) {
        final exercises = Provider.of<List<Exercise>>(context);

        return exercises.isEmpty
            ? const Text('No exercises.')
            : _buildTimeline(context, db, user, exercises);
      },
    );
  }

  Widget _buildTimeline(
    BuildContext context,
    DatabaseService db,
    User user,
    List<Exercise> exercises,
  ) {
    return StreamProvider<List<Exercise>>.value(
      value: db.streamExercises(user, planId),
      initialData: const [],
      child: Timeline.tileBuilder(
        padding: padding,
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) => Indicator.outlined(
            key: ValueKey('timeline indicator ${exercises[index].id}'),
            position: 0,
            borderWidth: 1,
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text('${index + 1}'),
            ),
          ),
          endConnectorBuilder: (context, index) => index == exercises.length - 1
              ? null
              : Padding(
                  key: ValueKey('timeline connector ${exercises[index].id}'),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Connector.solidLine(thickness: 1, color: Colors.grey),
                ),
          contentsBuilder: (context, index) {
            return Dismissible(
              key: ValueKey('Dismissible Exercise ${exercises[index].id}'),
              direction: DismissDirection.endToStart,
              background: const DismissibleBackground(),
              onDismissed: (dismissDirection) {
                db.removeExercise(user, planId, exercises[index].id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dihapus')),
                );
              },
              child: Padding(
                key: ValueKey('timeline content ${exercises[index].id}'),
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: PlanListTile(
                  title: exercises[index].name,
                  schedules: [
                    'Rep: ${exercises[index].repetitions}',
                    'Set: ${exercises[index].sets}',
                  ],
                  totalReps:
                      exercises[index].repetitions * exercises[index].sets,
                ),
              ),
            );
          },
          itemCount: exercises.length,
          contentsAlign: ContentsAlign.basic,
          nodePositionBuilder: (_, __) => 0,
        ),
      ),
    );
  }
}
