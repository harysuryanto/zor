import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../databases/database.dart';
import '../../models/exercise.dart';
import '../../models/plan.dart';
import '../../utils/colors.dart';
import '../exercise/show_add_exercise_modal_bottom_sheet.dart';
import '../global/dismissible_background.dart';
import 'plan_list_tile.dart';

class AddPlan extends StatefulWidget {
  final Plan? plan;

  /// Called after user saves or updates data.
  final void Function()? onFinish;

  const AddPlan({
    Key? key,
    this.plan,
    this.onFinish,
  }) : super(key: key);

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  late final bool editMode;

  final formKeyPlanName = GlobalKey<FormState>();

  int currentStep = 0;
  late final String? planId;
  late String planName;
  late final List<Map<String, Object>> scheduleOptions;
  late final List<String>? existingSchedules;
  List<Exercise> tempExercises = [];

  @override
  initState() {
    super.initState();

    editMode = widget.plan != null;
    planId = widget.plan?.id;
    planName = widget.plan?.name ?? '';
    existingSchedules = widget.plan?.schedules.cast<String>() ?? [];
    scheduleOptions = [
      {
        'day': 'sunday',
        'dayInId': 'minggu',
        'isSelected': existingSchedules!.contains('sunday')
      },
      {
        'day': 'monday',
        'dayInId': 'senin',
        'isSelected': existingSchedules!.contains('monday')
      },
      {
        'day': 'tuesday',
        'dayInId': 'selasa',
        'isSelected': existingSchedules!.contains('tuesday')
      },
      {
        'day': 'wednesday',
        'dayInId': 'rabu',
        'isSelected': existingSchedules!.contains('wednesday')
      },
      {
        'day': 'thursday',
        'dayInId': 'kamis',
        'isSelected': existingSchedules!.contains('thursday')
      },
      {
        'day': 'friday',
        'dayInId': 'jumat',
        'isSelected': existingSchedules!.contains('friday')
      },
      {
        'day': 'saturday',
        'dayInId': 'sabtu',
        'isSelected': existingSchedules!.contains('saturday')
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildStepper(
      steps: [
        Step(
          title: const Text('Nama rencana'),
          content: Form(
            key: formKeyPlanName,
            child: TextFormField(
              initialValue: planName,
              onChanged: (value) => setState(() => planName = value),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mohon isi nama rencana.';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: [
                  // Highly recommended to use short text or it will overflows
                  'Misal: Cardio',
                  'Misal: Workout Senin',
                  'Misal:Memperbesar tangan',
                  'Misal:Menurunkan berat badan',
                ][Random().nextInt(4)],
                hintStyle: const TextStyle(overflow: TextOverflow.fade),
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
        if (!editMode)
          Step(
            title: const Text('Latihan yang akan dilakukan'),
            subtitle: const Text('Mau latihan apa saja?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah latihan'),
                  onPressed: () => showAddExerciseModalBottomSheet(
                    context: context,
                    onSubmit: (exercise) {
                      setState(() => tempExercises.add(exercise));
                    },
                  ),
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
                    return Dismissible(
                      key: ValueKey(
                          'Dismissible Plan ${tempExercises[index].id}'),
                      direction: DismissDirection.endToStart,
                      background: const DismissibleBackground(),
                      onDismissed: (dismissDirection) {
                        setState(() => tempExercises.removeAt(index));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dihapus')),
                        );
                      },
                      child: PlanListTile(
                        key: ValueKey('Plan ${tempExercises[index].id}'),
                        title: tempExercises[index].name,
                        schedules: [
                          'Rep: ${tempExercises[index].repetitions}',
                          'Set: ${tempExercises[index].sets}'
                        ],
                        totalReps: tempExercises[index].repetitions *
                            tempExercises[index].sets,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
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
                        if (widget.onFinish != null) {
                          widget.onFinish!();
                        }
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
                    ? editMode
                        ? const Text('Simpan perubahan')
                        : const Text('Simpan')
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

  Future<void> onSubmit(DatabaseService db, User? user) async {
    List<String> schedules = [];
    for (var scheduleOption in scheduleOptions) {
      if (scheduleOption['isSelected'].toString() == 'true') {
        schedules.add(scheduleOption['day'].toString());
      }
    }

    if (editMode) {
      await db.updatePlan(
        user!,
        {
          'name': planName.trim(),
          'schedules': schedules,
        },
        planId!,
      );
    } else {
      await db.addPlan(
        user!,
        {
          'name': planName.trim(),
          'schedules': schedules,
        },
        then: (plan) async {
          int exerciseIndex = 0;
          for (var exercise in tempExercises) {
            await db.addExercise(
              user,
              plan.id,
              {
                'index': exerciseIndex++,
                'name': exercise.name.trim(),
                'repetitions': exercise.repetitions,
                'sets': exercise.sets,
              },
            );
          }
        },
      );
    }
  }
}
