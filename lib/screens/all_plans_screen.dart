import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/plan/plan_list.dart';

class AllPlansScreen extends StatelessWidget {
  const AllPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📆 Rencana Olahragamu'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push('/add-plan'),
      ),
      body: const PlanList(),
    );
  }
}
