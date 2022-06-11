import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/colors.dart';
import '../widgets/exercise/exercise_list.dart';

class DetailPlanScreen extends StatelessWidget {
  final String planId;

  const DetailPlanScreen({
    Key? key,
    required this.planId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Olahraga'),
      ),
      body: Stack(
        children: [
          /// Body section
          ExerciseList(
            planId: planId,
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
              right: 30,
              bottom: 90,
            ),
          ),

          /// Bottom section
          Positioned(
            left: 0,
            right: 0,
            bottom: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ElevatedButton(
                onPressed: () => context.push('/exercising?planId=$planId'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor)),
                child: const Text('Mulai sekarang'),
              ),
            ),
          ),

          /// Error: Operand of null-aware operation '!' has type 'WidgetsBinding' which excludes null.
          /// TODO: Look for alternatives.
          // Container(
          //   color: primaryColor,
          //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          //   child: Builder(
          //     builder: (context) {
          //       final GlobalKey<SlideActionState> _key = GlobalKey();
          //       return SlideAction(
          //         key: _key,
          //         text: 'Geser untuk mulai',
          //         textStyle: Theme.of(context).textTheme.bodyText1,
          //         innerColor: primaryColor,
          //         outerColor: whiteColor,
          //         borderRadius: 10,
          //         elevation: 0,
          //         submittedIcon: const Text(
          //           '🚀',
          //           style: TextStyle(fontSize: 36),
          //         ),
          //         onSubmit: () => context.push('/exercising2?planId=$planId'),
          //         // onSubmit: () => context.push('/exercising?planId=$planId'),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
