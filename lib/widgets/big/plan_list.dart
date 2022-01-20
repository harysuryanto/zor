import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/plans.dart';
import '../small/plan_list_tile.dart';

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
    final plans = Plans().plans;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: FutureBuilder<QuerySnapshot>(
        future: limit != null ? plans.limit(limit!).get() : plans.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Terjadi kesalahan.');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            dynamic data = (snapshot.data! as dynamic).docs;

            return ListView.separated(
              itemBuilder: (context, index) {
                return PlanListTile(
                  key: UniqueKey(),
                  title: data[index]['name'],
                  onTap: () => context.go('/detail-plan?planIndex=$index'),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemCount: data.length,
              shrinkWrap: !isScrollable,
              physics: isScrollable
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),

              /// The children which are not visible will be disposed
              /// and garbage collected automatically
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
            );
          }

          return const Text("loading");
        },
      ),
    );
  }
}
