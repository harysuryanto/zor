import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  List? _exercises;

  void handleNextExercise() {
    setState(() {
      /// Change current exercise to the next one if exists
      if (_currentExerciseIndex < _exercises!.length - 1) {
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
        if (_currentExerciseIndex == _exercises!.length - 1) {
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
        if (_currentExerciseIndex != _exercises!.length - 1) {
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
  Widget build(BuildContext context) {
    /// Get arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final myExercises = arguments['myExercises'];

    _exercises = myExercises;

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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _isResting
                    ? Text(
                        '😴 Istirahat ${_exercises![_currentExerciseIndex].restTime} detik.')
                    : _buildCurrentExerciseView(
                        name: _exercises![_currentExerciseIndex].name,
                        duration: _exercises![_currentExerciseIndex].duration,
                        repetitions:
                            _exercises![_currentExerciseIndex].repetitions,
                        sets: _exercises![_currentExerciseIndex].sets,
                      ),
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
                    child: ElevatedButton(
                      child: const Text('◀ Sebelumnya'),
                      onPressed: _currentExerciseIndex == 0
                          ? null
                          : () {
                              /// Show previous exercise
                              setState(() {
                                handlePreviousExercise();
                              });
                            },
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
