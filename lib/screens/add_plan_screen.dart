import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/plan/add_plan.dart';

class AddPlanScreen extends StatelessWidget {
  const AddPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Tambah Rencana Olahraga'),
      ),
      body: AddPlan(
        onFinish: () => GoRouter.of(context).pop(),
      ),
    );
  }
}
