import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../utils/colors.dart';

class Exercising2Screen extends StatefulWidget {
  final String planId;
  const Exercising2Screen({required this.planId, Key? key}) : super(key: key);

  @override
  _Exercising2ScreenState createState() => _Exercising2ScreenState();
}

class _Exercising2ScreenState extends State<Exercising2Screen> {
  int _currentSetProgress = 33; // Range of 0 to 100

  void setCurrentSetProgressTo(int newValue) async {
    /// This method gives animation to the CircularStepProgressIndicator

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
      setState(() {
        _currentSetProgress = progress[value];
      });
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Body section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Illustration
                  Lottie.network(
                    'https://assets3.lottiefiles.com/private_files/lf30_i5o0xxk6.json',
                    height: 200,
                    key: const ValueKey('Exercising illustration'),
                  ),

                  const SizedBox(height: 20),

                  /// Texts
                  const Text(
                    'Russian Push Up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Selanjutnya: Dumble Curl',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
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
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              '12',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'rep',
                              style: TextStyle(fontSize: 18),
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
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        child: CircularStepProgressIndicator(
                          key: const ValueKey('Set progress indicator'),
                          totalSteps: 100,
                          currentStep: _currentSetProgress,
                          selectedColor: primaryColor,
                          unselectedColor: Colors.transparent,
                          roundedCap: (_, __) => true,
                          stepSize: 7,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  '1/3',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'set',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
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
                  OutlinedButton(
                    child: const Icon(
                      Icons.skip_previous_rounded,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        'Selanjutnya',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        setCurrentSetProgressTo(66);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
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
}
