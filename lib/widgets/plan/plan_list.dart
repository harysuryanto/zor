import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/plan.dart';
import 'plan_list_tile.dart';

class PlanList extends StatelessWidget {
  final bool isScrollable;
  final int? limit;

  const PlanList({
    this.isScrollable = true,
    this.limit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var plans = Provider.of<List<Plan>>(context);

    if (limit != null) {
      if (plans.length > limit!) {
        plans.removeRange(limit!, plans.length);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: plans.isEmpty
          ? const Text('No plans.')
          : ListView.separated(
              itemBuilder: (context, index) {
                return PlanListTile(
                  key: ValueKey(plans[index].id),
                  title: plans[index].name,
                  onTap: () =>
                      context.push('/detail-plan?planId=${plans[index].id}'),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemCount: plans.length,
              shrinkWrap: !isScrollable,
              physics: isScrollable
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),

              /// The children which are not visible will be disposed
              /// and garbage collected automatically
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
            ),
    );
  }
}
