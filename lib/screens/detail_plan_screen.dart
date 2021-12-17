import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../providers/workouts.dart';
import '../widgets/small/custom_list_tile.dart';

class DetailPlanScreen extends StatelessWidget {
  const DetailPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Get arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    print(arguments['data_index']);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 60,
                      right: 30,
                      bottom: 20,
                      left: 30,
                    ),
                    child: Text(
                      'Workout Senin (detail screen)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  /// List of exercises
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Timeline.tileBuilder(
                        theme: TimelineThemeData(
                          connectorTheme: const ConnectorThemeData(
                            color: Colors.black12,
                          ),
                          indicatorTheme: const IndicatorThemeData(
                            color: Colors.red,
                          ),
                        ),
                        builder: TimelineTileBuilder.fromStyle(
                          contentsAlign: ContentsAlign.basic,
                          nodePositionBuilder: (_, __) => 0,
                          connectorStyle: ConnectorStyle.dashedLine,
                          contentsBuilder: (context, index) => Padding(
                            key: UniqueKey(),
                            padding: const EdgeInsets.only(
                              left: 20,
                              bottom: 10,
                            ),
                            child: CustomListTile(
                              title: workouts[index].title,
                              subtitle: workouts[index].subtitle,
                              onTap: () {},
                            ),
                          ),
                          itemCount: workouts.length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Bottom section
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '20 menit',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Estimasi waktu total',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      print('Mulai olahraga 🏃‍♂️');

                      Navigator.pushNamed(context, '/exercising');
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Mulai olahraga',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.run_circle_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
