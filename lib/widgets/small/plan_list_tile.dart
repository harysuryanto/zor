import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'vertical_slider.dart';

class PlanListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String schedule;
  final int totalReps;
  final int totalSets;
  final void Function()? onTap;

  const PlanListTile({
    Key? key,
    this.title = 'Title here',
    this.subtitle = 'Subtitle here',
    this.schedule = 'Monday, Wednesday, Friday',
    this.totalReps = 30,
    this.totalSets = 8,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),

                /// Schedule
                _buildChips(text: schedule),
              ],
            ),
            VerticalSlider(
              children: [
                /// Repetitions
                Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
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
                ),

                /// Sets
                Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips({required String text}) {
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
