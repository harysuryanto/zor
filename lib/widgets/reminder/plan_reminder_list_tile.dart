import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class PlanReminderListTile extends StatelessWidget {
  final String title;
  final String subTitle;

  const PlanReminderListTile({
    this.title = 'Title Here',
    this.subTitle = 'Subtitle here',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        // width: 200,
        // height: 100,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 6),
            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
