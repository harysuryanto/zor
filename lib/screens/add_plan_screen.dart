import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../databases/database.dart';
import '../models/exercise.dart';
import '../utils/colors.dart';
import '../widgets/exercise/add_exercise.dart';
import '../widgets/plan/plan_list_tile.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({Key? key}) : super(key: key);

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final List<Map<String, Object>> scheduleOptions = [
    {'day': 'sunday', 'dayInId': 'minggu', 'isSelected': false},
    {'day': 'monday', 'dayInId': 'senin', 'isSelected': true},
    {'day': 'tuesday', 'dayInId': 'selasa', 'isSelected': false},
    {'day': 'wednesday', 'dayInId': 'rabu', 'isSelected': false},
    {'day': 'thursday', 'dayInId': 'kamis', 'isSelected': true},
    {'day': 'friday', 'dayInId': 'jumat', 'isSelected': false},
    {'day': 'saturday', 'dayInId': 'sabtu', 'isSelected': false},
  ];

  List<Exercise> tempExercises = [];

  final formKeyPlanName = GlobalKey<FormState>();
  final uuid = const Uuid();

  int currentStep = 0;
  String planName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      tempExercises.clear();
      tempExercises.add(
        Exercise(
          id: uuid.v1(),
          name: 'Push Up',
          repetitions: 20,
          sets: 4,
        ),
      );
      tempExercises.add(
        Exercise(
          id: uuid.v1(),
          name: 'Pull Up',
          repetitions: 6,
          sets: 6,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Tambah Rencana Olahraga'),
      ),
      body: _buildStepper(
        steps: [
          Step(
            title: const Text('Nama rencana'),
            content: Padding(
              /// Padding is used to fix overflow on label text
              padding: const EdgeInsets.only(top: 4),
              child: Form(
                key: formKeyPlanName,
                child: TextFormField(
                  initialValue: 'Workout Senin',
                  onChanged: (value) => setState(() => planName = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mohon isi nama rencana.';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Contoh: Workout Senin'),
                ),
              ),
            ),
          ),
          Step(
            title: const Text('Jadwalkan rencanamu'),
            subtitle: const Text('Kapan kamu akan melakukannya?'),
            content: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: [
                  for (var i = 0; i < scheduleOptions.length; i++) ...[
                    Padding(
                      key: ValueKey('Schedule options item $i'),
                      padding: const EdgeInsets.all(5),
                      child: _buildInteractiveChip(
                        key: ValueKey(
                            'Chip ${scheduleOptions[i]['day'] as String}'),
                        text: scheduleOptions[i]['day'] as String,
                        isSelected: scheduleOptions[i]['isSelected'] as bool,
                        onTap: () {
                          setState(() {
                            scheduleOptions[i].update('isSelected', (value) {
                              final newValue = value as bool;
                              return !newValue;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Latihan yang akan dilakukan'),
            subtitle: const Text('Mau latihan apa saja?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah latihan'),
                  onPressed: () => _showModalBottomSheet(context: context),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: tempExercises.length,
                  itemBuilder: (context, index) {
                    return PlanListTile(
                      title: tempExercises[index].name,
                      schedules: [
                        'Rep: ${tempExercises[index].repetitions}',
                        'Set: ${tempExercises[index].sets}'
                      ],
                      totalReps: tempExercises[index].repetitions *
                          tempExercises[index].sets,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper({required List<Step> steps}) {
    final db = DatabaseService();
    final user = Provider.of<User?>(context, listen: false);

    return Stepper(
      controlsBuilder: (context, details) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(
              child: details.currentStep == 0
                  ? OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.grey),
                      ),
                      child: const Text(
                        'Sebelumnya',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text(
                        'Sebelumnya',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: details.currentStep == steps.length - 1
                    ? () async {
                        await onSubmit(db, user!);
                        context.go('/');
                      }
                    : details.onStepContinue,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: details.currentStep == steps.length - 1
                    ? const Text('Simpan')
                    : const Text('Selanjutnya'),
              ),
            ),
          ],
        ),
      ),
      currentStep: currentStep,
      onStepCancel: () {
        if (currentStep > 0) {
          setState(() {
            currentStep -= 1;
          });
        }
      },
      onStepContinue: () {
        if (currentStep < steps.length - 1) {
          if (formKeyPlanName.currentState!.validate()) {
            setState(() {
              currentStep += 1;
            });
          }
        }
      },
      onStepTapped: (int index) {
        if (formKeyPlanName.currentState!.validate()) {
          setState(() {
            currentStep = index;
          });
        }
      },
      steps: steps,
    );
  }

  Widget _buildInteractiveChip({
    Key? key,
    required String text,
    bool isSelected = false,
    required Function() onTap,
  }) {
    TextStyle? textStyle = isSelected
        ? const TextStyle(color: whiteColor, fontSize: 12)
        : const TextStyle(color: primaryColor, fontSize: 12);
    Color? backgroundColor = isSelected ? primaryColor : null;

    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: 1, color: primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }

  Future<dynamic> _showModalBottomSheet({
    required BuildContext context,
    bool expand = false,
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
                behavior: _CustomScrollBehavior(),
                child: SingleChildScrollView(
                  child: AddExercise(
                    onSubmit: (exercise) {
                      setState(() => tempExercises.add(exercise));
                    },
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

  Future<void> onSubmit(DatabaseService db, User? user) async {
    List<String> schedules = [];
    for (var scheduleOption in scheduleOptions) {
      if (scheduleOption['isSelected'].toString() == 'true') {
        schedules.add(scheduleOption['day'].toString());
      }
    }

    // TODO: Save exercises to Firestore 👇
    // List exercises = tempExercises.map((exercise) => exercise).toList();
    // print('exercises          : $exercises');

    await db.addPlan(
      user!,
      {
        'name': planName.trim(),
        'schedules': schedules,
      },
    );
  }
}

class _CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
