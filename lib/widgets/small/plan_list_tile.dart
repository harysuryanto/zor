import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'vertical_slider.dart';

class PlanListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? schedule;
  final int totalReps;
  final int? totalSets;
  final void Function()? onTap;

  const PlanListTile({
    Key? key,
    this.title = 'Title here',
    this.subtitle,
    this.schedule,
    this.totalReps = 30,
    this.totalSets,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),

                /// Subtitle
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],

                /// Schedule
                if (schedule != null) _buildChip(text: schedule!),
              ],
            ),
            VerticalSlider(
              children: [
                /// Repetitions
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'repetisi total',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '$totalReps',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),

                /// Sets
                if (totalSets != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'set total',
                        style: TextStyle(fontSize: 9),
                      ),
                      Text(
                        '$totalSets',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({required String text}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.black12,
      ),
      child: Text(text, style: const TextStyle(fontSize: 9)),
    );
  }
}
