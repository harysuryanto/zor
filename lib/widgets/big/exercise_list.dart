import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../models/plans.dart';
import '../../utils/colors.dart';
import '../small/plan_list_tile.dart';

class ExerciseList extends StatelessWidget {
  final String planId;
  const ExerciseList({required this.planId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercises = Plans().exercises(planId: planId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: FutureBuilder<QuerySnapshot>(
          future: exercises.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Terjadi kesalahan.');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              dynamic data = (snapshot.data! as dynamic).docs;

              return Timeline.tileBuilder(
                builder: TimelineTileBuilder.fromStyle(
                  contentsBuilder: (context, index) => Padding(
                    key: ValueKey(data[index].id),
                    padding: const EdgeInsets.only(
                      left: 20,
                      bottom: 10,
                    ),
                    child: PlanListTile(
                      title: data[index]['name'],
                    ),
                  ),
                  itemCount: data.length,
                  nodePositionBuilder: (_, __) => 0,
                  contentsAlign: ContentsAlign.basic,
                  connectorStyle: ConnectorStyle.dashedLine,
                ),
                theme: TimelineThemeData(
                  connectorTheme:
                      const ConnectorThemeData(color: Colors.black12),
                  indicatorTheme: const IndicatorThemeData(color: primaryColor),
                ),
              );
            }

            return const Text("loading");
          }),
    );
  }
}
