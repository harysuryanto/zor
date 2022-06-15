import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class PlanReminderListTile extends StatelessWidget {
  final String title;
  final String? subTitle;

  const PlanReminderListTile({
    required this.title,
    this.subTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: LimitedBox(
          maxWidth: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subTitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subTitle!,
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
