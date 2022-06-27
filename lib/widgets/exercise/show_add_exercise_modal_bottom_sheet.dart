import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../models/exercise.dart';
import '../../utils/colors.dart';
import '../global/custom_scroll_behavior.dart';
import 'add_exercise.dart';

Future<dynamic> showAddExerciseModalBottomSheet({
  required BuildContext context,
  String? planId,
  bool expand = false,
  required FutureOr<void> Function(Exercise exercise) onSubmit,
}) {
  return showCupertinoModalBottomSheet(
    context: context,
    expand: expand,
    builder: (context) => Material(
      color: primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Draggable indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: 50,
              height: 5,
              decoration: const BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),

          /// Body
          Expanded(
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior().copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: AddExercise(
                  planId: planId,
                  onSubmit: (exercise) => onSubmit(exercise),
                ),
              ),
            ),
          ),

          /// Padding bottom to prevent content blocked by keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    ),
  );
}
