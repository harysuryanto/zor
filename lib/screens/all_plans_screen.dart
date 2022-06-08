import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../databases/database.dart';
import '../models/plan.dart';
import '../widgets/plan/plan_list.dart';

class AllPlansScreen extends StatelessWidget {
  const AllPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User?>(context);

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
        onPressed: () => context.push('/add-plan'),
      ),
      body: StreamProvider<List<Plan>>.value(
        value: db.streamPlans(user!),
        initialData: const [],
        child: const PlanList(),
      ),
    );
  }
}
