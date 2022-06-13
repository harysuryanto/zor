import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../global/vertical_slider.dart';

class PlanListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String>? schedules;
  final int? totalReps;
  final int? totalSets;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const PlanListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.schedules,
    this.totalReps,
    this.totalSets,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
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
                  if (schedules != null)
                    Wrap(
                      children: schedules!
                          .map(
                            (schedule) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildChip(
                                    text: schedule[0].toUpperCase() +
                                        schedule.substring(1).toLowerCase()),
                                const SizedBox(width: 5),
                              ],
                            ),
                          )
                          .toList(),
                    )
                ],
              ),
            ),
            const SizedBox(width: 20),
            VerticalSlider(
              children: [
                /// Repetitions
                if (totalReps != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'total repetisi',
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
                        'total set',
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
