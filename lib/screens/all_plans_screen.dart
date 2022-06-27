import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/global/banner_ad.dart';
import '../widgets/plan/plan_list.dart';

class AllPlansScreen extends StatelessWidget {
  const AllPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📆 Rencana Olahragamu'),
      ),
      body: const PlanList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push('/add-plan'),
        tooltip: 'Tambah rencana',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          const AdBanner(adPlacement: AdPlacement.allPlansScreen),
    );
  }
}
