import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../services/firestore_service.dart';
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
  _ReorderingMode _reorderingMode = _ReorderingMode.notStarted;
  List<Exercise> oldOrderExercises = [];
  List<Exercise> newOrderExercises = [];

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Olahraga'),
        actions: [
          if (_reorderingMode == _ReorderingMode.notStarted)
            IconButton(
              onPressed: () {
                setState(() => _reorderingMode = _ReorderingMode.reordering);

                db.streamExercises(widget.planId).first.then((exercises) {
                  setState(() => oldOrderExercises = exercises);
                });
              },
              icon: const Icon(Icons.reorder),
              tooltip: 'Sortir',
            ),
          if (_reorderingMode == _ReorderingMode.reordering)
            IconButton(
              onPressed: () async {
                setState(() => _reorderingMode = _ReorderingMode.saving);

                if (newOrderExercises.isEmpty) {
                  newOrderExercises = [...oldOrderExercises];
                }

                await db.reorderExerciseIndexes(
                  widget.planId,
                  oldList: oldOrderExercises,
                  newList: newOrderExercises,
                );

                setState(() => _reorderingMode = _ReorderingMode.notStarted);
              },
              icon: const Icon(Icons.done),
              tooltip: 'Selesai menyortir',
            ),
        ],
      ),
      body: Stack(
        children: [
          /// Body section
          if (_reorderingMode == _ReorderingMode.notStarted)
            ExerciseList(
              planId: widget.planId,
              padding: const EdgeInsets.only(
                top: 30,
                left: 30,
                right: 30,
                bottom: 90,
              ),
            ),
          if (_reorderingMode == _ReorderingMode.reordering)
            _ReorderingListView(
              planId: widget.planId,
              onReorder: (newExercises) =>
                  setState(() => newOrderExercises = newExercises),
            ),
          if (_reorderingMode == _ReorderingMode.saving)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/illustrations/sorting.json',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text('Menyortir...'),
                ],
              ),
            ),

          /// Bottom section
          Positioned(
            left: 0,
            right: 0,
            bottom: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              // TODO: hide this button if there is no exercise
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context)
                    .push('/exercising?planId=${widget.planId}'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor)),
                child: const Text('Olahraga sekarang'),
              ),
            ),
          ),

          /// Error: Operand of null-aware operation '!' has type 'WidgetsBinding' which excludes null.
          /// TODO: Look for alternatives
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
            final db = Provider.of<FirestoreService>(context, listen: false);

            await db.addExercise(
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
        tooltip: 'Tambah latihan',
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
    final db = Provider.of<FirestoreService>(context, listen: false);
    db.streamExercises(widget.planId).first.then((exercises) {
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
          trailing: const Icon(Icons.drag_indicator),
        );
      },
      itemCount: _exercises.length,
      onReorder: (int oldIndex, int newIndex) {
        /// 1. Update the UI
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Exercise item = _exercises.removeAt(oldIndex);
          _exercises.insert(newIndex, item);
        });

        /// 2. Update index in each exercise to be alphabetically ordered
        for (var i = 0; i < _exercises.length; i++) {
          final remove = _exercises.removeAt(i);
          _exercises.insert(
            i,
            Exercise(
              id: remove.id,
              index: i,
              name: remove.name,
              repetitions: remove.repetitions,
              sets: remove.sets,
            ),
          );
        }

        widget.onReorder!(_exercises);
      },
      padding: const EdgeInsets.symmetric(vertical: 30),
    );
  }
}

enum _ReorderingMode {
  notStarted,
  reordering,
  saving,
}
