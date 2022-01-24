import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zor/widgets/big/plan_list.dart';

class AllPlansScreen extends StatelessWidget {
  const AllPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📆 Rencana Olahragamu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.go('/add-plan'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: PlanList(),
      ),
    );
  }
}
