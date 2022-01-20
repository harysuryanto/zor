import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zor/widgets/big/plan_list.dart';

class AllPlansScreen extends StatelessWidget {
  const AllPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 300),
          child: Center(
            child:
                Text('📆 Rencana Olahragamu', style: TextStyle(fontSize: 14)),
          ),
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
