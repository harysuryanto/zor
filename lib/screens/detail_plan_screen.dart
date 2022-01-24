import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../utils/colors.dart';
import '../widgets/big/exercise_list.dart';

class DetailPlanScreen extends StatelessWidget {
  final String planId;

  const DetailPlanScreen({
    required this.planId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pratinjau Olahraga')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Body section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: ExerciseList(planId: planId),
            ),
          ),

          /// Bottom section
          Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Builder(
              builder: (context) {
                final GlobalKey<SlideActionState> _key = GlobalKey();
                return SlideAction(
                  key: _key,
                  text: 'Geser untuk mulai',
                  textStyle: Theme.of(context).textTheme.bodyText1,
                  innerColor: primaryColor,
                  outerColor: whiteColor,
                  borderRadius: 10,
                  elevation: 0,
                  submittedIcon: const Center(child: Text('🚀')),
                  onSubmit: () {
                    context.go('/exercising?planId=$planId');

                    Future.delayed(const Duration(seconds: 1),
                        () => _key.currentState!.reset());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
