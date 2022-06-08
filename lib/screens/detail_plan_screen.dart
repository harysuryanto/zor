import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../databases/database.dart';
import '../models/exercise.dart';
import '../utils/colors.dart';
import '../widgets/exercise/exercise_list.dart';

class DetailPlanScreen extends StatelessWidget {
  final String planId;

  const DetailPlanScreen({
    required this.planId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User?>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Olahraga'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Body section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: StreamProvider<List<Exercise>>.value(
                value: db.streamExercises(user!, planId),
                initialData: const [],
                child: const ExerciseList(),
              ),
            ),
          ),

          /// Bottom section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: ElevatedButton(
              onPressed: () => context.push('/exercising?planId=$planId'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor)),
              child: const Text('Mulai sekarang'),
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
