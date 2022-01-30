import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../utils/colors.dart';
import '../widgets/big/add_exercise.dart';
import '../widgets/small/plan_list_tile.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({Key? key}) : super(key: key);

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final _formKeyPlanName = GlobalKey<FormState>();

  int _currentStep = 0;
  String _planName = '';

  final List<Map<String, Object>> _scheduleOptions = [
    {'day': 'Minggu', 'isSelected': false},
    {'day': 'Senin', 'isSelected': true},
    {'day': 'Selasa', 'isSelected': false},
    {'day': 'Rabu', 'isSelected': false},
    {'day': 'Kamis', 'isSelected': true},
    {'day': 'Jumat', 'isSelected': false},
    {'day': 'Sabtu', 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Tambah Rencana Olahraga'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildStepper(
        steps: [
          Step(
            title: const Text('Nama rencana'),
            content: Padding(
              /// Padding is used to fix overflow on label text
              padding: const EdgeInsets.only(top: 4),
              child: Form(
                key: _formKeyPlanName,
                child: TextFormField(
                  autofocus: true,
                  initialValue: 'Workout Senin',
                  onChanged: (value) => setState(() => _planName = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mohon isi nama rencana.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Nama rencana'),
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
                  for (var i = 0; i < _scheduleOptions.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: _buildInteractiveChip(
                        text: _scheduleOptions[i]['day'] as String,
                        isSelected: _scheduleOptions[i]['isSelected'] as bool,
                        onPressed: () {
                          setState(() {
                            _scheduleOptions[i].update(
                              'isSelected',
                              (value) {
                                final _value = value as bool;
                                return !_value;
                              },
                            );
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
                ),
                const SizedBox(height: 10),
                const PlanListTile(
                  title: 'Push Up',
                  schedule: 'Rep: 20, Set: 4',
                  totalReps: 80,
                ),
                const SizedBox(height: 10),
                const PlanListTile(
                  title: 'Pull Up',
                  schedule: 'Rep: 6, Set: 6',
                  totalReps: 36,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper({required List<Step> steps}) {
    return Stepper(
      physics: const BouncingScrollPhysics(),
      controlsBuilder: (context, details) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(
              child: details.currentStep == 0
                  ? OutlinedButton(
                      child: const Text(
                        'Sebelumnya',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.grey),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  : OutlinedButton(
                      child: const Text(
                        'Sebelumnya',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: primaryColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: details.currentStep == steps.length - 1
                    ? const Text('Simpan')
                    : const Text('Selanjutnya'),
                onPressed: details.onStepContinue,
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
              ),
            ),
          ],
        ),
      ),
      currentStep: _currentStep,
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_currentStep < steps.length - 1) {
          if (_formKeyPlanName.currentState!.validate()) {
            setState(() {
              _currentStep += 1;
            });
          }
        }
      },
      onStepTapped: (int index) {
        if (_formKeyPlanName.currentState!.validate()) {
          setState(() {
            _currentStep = index;
          });
        }
      },
      steps: steps,
    );
  }

  Widget _buildInteractiveChip({
    required String text,
    bool isSelected = false,
    required Function() onPressed,
  }) {
    TextStyle? textStyle = isSelected
        ? const TextStyle(color: whiteColor, fontSize: 12)
        : const TextStyle(color: primaryColor, fontSize: 12);
    BorderSide? borderSide =
        isSelected ? null : const BorderSide(width: 1, color: primaryColor);
    Color? backgroundColor = isSelected ? primaryColor : null;

    return OutlinedButton(
      child: Text(text, style: textStyle),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: borderSide,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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
            const Flexible(
              flex: 1,
              child: SingleChildScrollView(child: AddExercise()),
            ),

            /// Padding bottom to prevent content blocked by keyboard
            Container(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
