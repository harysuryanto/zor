import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../models/exercise.dart';
import '../services/firestore_service.dart';
import '../utils/colors.dart';

class ExercisingScreen extends StatefulWidget {
  final String planId;
  const ExercisingScreen({required this.planId, Key? key}) : super(key: key);

  @override
  State<ExercisingScreen> createState() => _ExercisingScreenState();
}

class _ExercisingScreenState extends State<ExercisingScreen> {
  List<Exercise> _exercises = [];
  int _currentExerciseIndex = 0; // Range of 0 to [_exercises.length] - 1
  int _currentSetProgress = 0; // Range of 0 to [Exercise.sets]

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
    return Scaffold(
      body: SafeArea(
        child: _exercises.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tidak ada latihan'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).pop(),
                      child: const Text('Tambah latihan'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Body section
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Illustration
                        Lottie.asset(
                          'assets/illustrations/seated_dumble_bicep_curl.json',
                          height: 200,
                          key: const ValueKey('Exercising illustration'),
                        ),

                        const SizedBox(height: 20),

                        /// Texts
                        Text(
                          _exercises[_currentExerciseIndex].name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        if (_currentExerciseIndex < _exercises.length - 1)
                          Text(
                            'Selanjutnya: ${_exercises[_currentExerciseIndex + 1].name}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black54),
                          ),

                        const SizedBox(height: 50),

                        /// Numbers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// Repetitions
                            Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: lightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_exercises[_currentExerciseIndex].repetitions}',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const AutoSizeText(
                                    'rep',
                                    style: TextStyle(
                                        fontSize: 18, color: darkColor),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),

                            /// Sets
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                color: lightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                              ),
                              child: CircularStepProgressIndicator(
                                key: const ValueKey('Set progress indicator'),
                                totalSteps:
                                    _exercises[_currentExerciseIndex].sets,
                                currentStep: _currentSetProgress,
                                selectedColor: primaryColor,
                                unselectedColor: Colors.transparent,
                                roundedCap: (_, __) => true,
                                stepSize: 7,
                                padding: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(
                                          '$_currentSetProgress/${_exercises[_currentExerciseIndex].sets}',
                                          style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        ),
                                        const Text(
                                          'set',
                                          style: TextStyle(
                                              fontSize: 18, color: darkColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Bottom section
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      right: 30,
                      bottom: 30,
                      left: 30,
                    ),
                    child: Row(
                      children: [
                        if (_currentExerciseIndex > 0) ...[
                          OutlinedButton(
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              color: primaryColor,
                            ),
                            onPressed: () => _handlePrevious(),
                          ),
                          const SizedBox(width: 20),
                        ],
                        Expanded(
                          child: _currentExerciseIndex <
                                      _exercises.length - 1 ||
                                  _currentSetProgress <
                                      _exercises[_currentExerciseIndex].sets
                              ? ElevatedButton(
                                  onPressed: () {
                                    _handleNext();
                                    setCurrentSetProgressTo(
                                        _currentSetProgress + 1);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                  ),
                                  child: const Text(
                                    'Selanjutnya',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () => GoRouter.of(context).go('/'),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                  ),
                                  child: const Text(
                                    'Selesai',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleNext() {
    // Move to next set
    if (_currentSetProgress < _exercises[_currentExerciseIndex].sets) {
      setState(() => _currentSetProgress++);
      return;
    }

    // Move to next exercise
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() => _currentExerciseIndex++);
      setState(() => _currentSetProgress = 0);
      return;
    }
  }

  void _handlePrevious() {
    if (_currentExerciseIndex > 0) {
      setState(() => _currentExerciseIndex--);
      setState(() => _currentSetProgress = 0);
      return;
    }
  }

  /// This method gives animation to the CircularStepProgressIndicator.
  ///
  /// BUT this method is currently not working properly. So there is no animation.
  void setCurrentSetProgressTo(int newValue) async {
    int startValue = _currentSetProgress;
    int finishValue = newValue;
    List<int> progress;

    /// Check if the progress is ascending or descending
    if (startValue < finishValue) {
      /// Ascending
      /// Output: [1, 2, 3]
      progress = [for (var i = startValue; i < finishValue; i++) i];
    } else {
      /// Descending
      /// Output: [3, 2, 1]
      progress = [for (var i = startValue; i > finishValue; i--) i];
    }

    /// Progressively change value of [_currentSetProgress]
    for (var value = 0; value < progress.length; value++) {
      setState(() => _currentSetProgress = progress[value]);
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}
