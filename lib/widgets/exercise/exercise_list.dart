import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../models/exercise.dart';
import '../../utils/colors.dart';
import '../plan/plan_list_tile.dart';

class ExerciseList extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const ExerciseList({
    Key? key,
    this.padding = const EdgeInsets.all(30),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<List<Exercise>>(context);

    return exercises.isEmpty
        ? const Text('No exercises.')
        : _buildTimeline(exercises);
  }

  Widget _buildTimeline(List<Exercise> exercises) {
    return Timeline.tileBuilder(
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
        endConnectorBuilder: (_, index) => index == exercises.length - 1
            ? null
            : Padding(
                key: ValueKey('timeline connector ${exercises[index].id}'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Connector.solidLine(thickness: 1, color: Colors.grey),
              ),
        contentsBuilder: (_, index) {
          return Padding(
            key: ValueKey('timeline content ${exercises[index].id}'),
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: PlanListTile(
              title: exercises[index].name,
              schedules: [
                'Rep: ${exercises[index].repetitions}',
                'Set: ${exercises[index].sets}',
              ],
              totalReps: exercises[index].repetitions * exercises[index].sets,
            ),
          );
        },
        itemCount: exercises.length,
        contentsAlign: ContentsAlign.basic,
        nodePositionBuilder: (_, __) => 0,
      ),
    );
  }
}
