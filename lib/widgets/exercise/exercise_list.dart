import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../models/database.dart';
import '../../utils/colors.dart';
import '../plan/plan_list_tile.dart';

class ExerciseList extends StatelessWidget {
  final String planId;
  const ExerciseList({required this.planId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercises = Database().exercises(planId: planId);

    return FutureBuilder<QuerySnapshot>(
      future: exercises.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Terjadi kesalahan.');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          dynamic data = (snapshot.data! as dynamic).docs;

          return _buildTimeline(data);
        }

        return const Text("loading");
      },
    );
  }

  Widget _buildTimeline(dynamic data) {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder(
        indicatorBuilder: (_, index) => Indicator.outlined(
          key: ValueKey('timeline indicator ${data[index].id}'),
          position: 0,
          borderWidth: 1,
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text('${index + 1}'),
          ),
        ),
        endConnectorBuilder: (_, index) => index == data.length - 1
            ? null
            : Padding(
                key: ValueKey('timeline connector ${data[index].id}'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Connector.solidLine(thickness: 1, color: Colors.grey),
              ),
        contentsBuilder: (_, index) {
          return Padding(
            key: ValueKey('timeline content ${data[index].id}'),
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 10,
            ),
            child: PlanListTile(
              title: data[index]['name'],
            ),
          );
        },
        itemCount: data.length,
        contentsAlign: ContentsAlign.basic,
        nodePositionBuilder: (_, __) => 0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30),
    );
  }
}
