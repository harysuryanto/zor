import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../databases/database.dart';
import '../models/exercise.dart';
import '../utils/colors.dart';
import '../widgets/exercise/exercise_list.dart';
import '../widgets/exercise/show_add_exercise_modal_bottom_sheet.dart';
import '../widgets/global/banner_ad.dart';

class DetailPlanScreen extends StatefulWidget {
  final String planId;

  const DetailPlanScreen({
    Key? key,
    required this.planId,
  }) : super(key: key);

  @override
  State<DetailPlanScreen> createState() => _DetailPlanScreenState();
}

class _DetailPlanScreenState extends State<DetailPlanScreen> {
  bool isReorderingList = false;
  List<Exercise> oldOrderExercises = [];
  List<Exercise> newOrderExercises = [];

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User?>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Olahraga'),
        actions: [
          if (isReorderingList)
            IconButton(
              onPressed: () async {
                // print(newOrderExercises.map((exercise) => exercise.name));

                await db.reorderExerciseIndexes(
                  user!,
                  widget.planId,
                  oldList: oldOrderExercises,
                  newList: newOrderExercises,
                );

                setState(() => isReorderingList = false);
              },
              icon: const Icon(Icons.done),
              tooltip: 'Selesai menyortir',
            ),
          if (!isReorderingList)
            IconButton(
              onPressed: () {
                setState(() => isReorderingList = true);

                db
                    .streamExercises(user!, widget.planId)
                    .first
                    .then((exercises) {
                  setState(() => oldOrderExercises = exercises);
                });
              },
              icon: const Icon(Icons.reorder),
              tooltip: 'Sortir',
            ),
        ],
      ),
      body: Stack(
        children: [
          /// Body section
          if (isReorderingList)
            _ReorderingListView(
              planId: widget.planId,
              onReorder: (newExercises) =>
                  setState(() => newOrderExercises = newExercises),
            ),
          if (!isReorderingList)
            ExerciseList(
              planId: widget.planId,
              padding: const EdgeInsets.only(
                top: 30,
                left: 30,
                right: 30,
                bottom: 90,
              ),
            ),

          /// Exercising Screen is still in development, so we disable the access to it
          /// Bottom section
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 1,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          //     child: ElevatedButton(
          //       onPressed: () =>
          //           GoRouter.of(context).push('/exercising?planId=$planId'),
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all<Color>(primaryColor)),
          //       child: const Text('Mulai sekarang (WIP 🚧)'),
          //     ),
          //   ),
          // ),

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
          //         onSubmit: () => GoRouter.of(context).push('/exercising2?planId=$planId'),
          //         // onSubmit: () => GoRouter.of(context).push('/exercising?planId=$planId'),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddExerciseModalBottomSheet(
          context: context,
          planId: widget.planId,
          onSubmit: (exercise) async {
            final db = DatabaseService();
            final user = Provider.of<User?>(context, listen: false);

            await db.addExercise(
              user!,
              widget.planId,
              {
                'index': exercise.index,
                'name': exercise.name.trim(),
                'repetitions': exercise.repetitions,
                'sets': exercise.sets,
              },
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          const AdBanner(adPlacement: AdPlacement.detailPlanScreen),
    );
  }
}

class _ReorderingListView extends StatefulWidget {
  final String planId;
  final void Function(List<Exercise> newExercises)? onReorder;

  const _ReorderingListView({
    Key? key,
    required this.planId,
    this.onReorder,
  }) : super(key: key);

  @override
  State<_ReorderingListView> createState() => _ReorderingListViewState();
}

class _ReorderingListViewState extends State<_ReorderingListView> {
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    final db = DatabaseService();
    final user = Provider.of<User?>(context, listen: false);
    db.streamExercises(user!, widget.planId).first.then((exercises) {
      setState(() => _exercises = exercises);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          key: Key(_exercises[index].id),
          leading: CircleAvatar(
            foregroundColor: primaryColor,
            child: Text('${index + 1}'),
          ),
          title: Text(_exercises[index].name),
          subtitle: Text(_exercises[index].id),
          trailing: const Icon(Icons.drag_indicator),
        );
      },
      itemCount: _exercises.length,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Exercise item = _exercises.removeAt(oldIndex);
          _exercises.insert(newIndex, item);

          widget.onReorder!(_exercises);
        });
      },
    );
  }
}
