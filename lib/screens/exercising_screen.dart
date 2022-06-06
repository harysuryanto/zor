import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Exercise {
  final int exerciseId;
  final String name;
  final int repetitions;
  final int sets;

  const Exercise({
    required this.exerciseId,
    required this.name,
    required this.repetitions,
    required this.sets,
  });
}

class ExercisingScreen extends StatefulWidget {
  final String planId;
  const ExercisingScreen({
    required this.planId,
    Key? key,
  }) : super(key: key);

  @override
  State<ExercisingScreen> createState() => _ExercisingScreenState();
}

class _ExercisingScreenState extends State<ExercisingScreen> {
  int _currentExerciseIndex = 0;
  bool _isResting = false;
  bool _isEndOfExercise = false;
  List _refactorredExercises = [];

  final List<Exercise> _orignalExercises = const [
    Exercise(
      exerciseId: 1,
      name: 'Pull Up',
      repetitions: 5,
      sets: 3,
    ),
    Exercise(
      exerciseId: 2,
      name: 'Dumble Curl',
      repetitions: 12,
      sets: 4,
    ),
  ];

  List convertToNewList(List<Exercise> exercises) {
    List newList = [];

    /// Assign [totalSets] with overall reps
    for (var i = 0; i < exercises.length; i++) {
      // totalSets += exercises[i].sets;
      for (var j = 0; j < exercises[i].sets; j++) {
        newList.add(exercises[i].name);
        print('adding ${exercises[i].name} to new list');
      }
    }

    return newList;
  }

  void handleNextExercise() {
    setState(() {
      /// Change current exercise to the next one if exists
      if (_currentExerciseIndex < _refactorredExercises.length - 1) {
        /// But rest first before go to the next exercise
        if (!_isResting) {
          setState(() {
            _isResting = true;
            print('Istirahat dulu ya');
          });
        } else {
          /// Go to next exercise
          _currentExerciseIndex++;

          /// And stop resting
          _isResting = false;
        }

        /// Set [_isEndOfExercise] to true if next exercise does not exist
        if (_currentExerciseIndex == _refactorredExercises.length - 1) {
          setState(() {
            _isEndOfExercise = true;
          });
        }
      } else {
        print('Sudah mentok kanan!!!');
      }
    });
  }

  void handlePreviousExercise() {
    setState(() {
      /// Change current exercise to the next one if exists
      if (_currentExerciseIndex > 0) {
        setState(() {
          /// Go back to previous exercise
          _currentExerciseIndex--;
        });

        /// Set [_isEndOfExercise] to false if next exercise exists
        if (_currentExerciseIndex != _refactorredExercises.length - 1) {
          setState(() {
            _isEndOfExercise = false;
          });
        }
      } else {
        print('Sudah mentok kiri!!!');
      }
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _refactorredExercises = convertToNewList(_orignalExercises);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 60,
                right: 30,
                bottom: 20,
                left: 30,
              ),
              child: Text(
                'Workout Senin (Exercising Screen)',
                style: TextStyle(fontSize: 18),
              ),
            ),

            /// List of exercises
            ..._refactorredExercises.map((e) => Text(e)).toList(),

            const SizedBox(height: 30),

            /// Current exercise
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _isResting
                    ? const Text('😴 Istirahat.')
                    : Text('▶ ${_refactorredExercises[_currentExerciseIndex]}'),
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _currentExerciseIndex == 0
                          ? null
                          : () {
                              /// Show previous exercise
                              setState(() {
                                handlePreviousExercise();
                              });
                            },
                      child: const Text('◀ Sebelumnya'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                          _isEndOfExercise ? 'Selesai 🏁' : 'Selanjutnya ▶'),
                      onPressed: () {
                        if (_isEndOfExercise) {
                          /// Go back to Home Screen
                          context.go('/');
                        } else {
                          /// Show next exercise
                          handleNextExercise();
                        }
                      },
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

  Widget _buildCurrentExerciseView({
    required String name,
    int? duration,
    int? repetitions,
    int? sets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name),

        /// If only [duration] that exists
        if (duration == null && repetitions != null && sets != null)
          Text('$repetitions repetisi, $sets set.')

        /// If only [repetitions] and [sets] that exist
        else if (duration != null && repetitions == null && sets == null)
          Text('$duration second(s).')
        else
          const Text('There is something wrong with the data'),
      ],
    );
  }
}
