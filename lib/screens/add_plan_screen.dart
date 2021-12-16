import 'package:flutter/material.dart';
import 'package:zor/models/new_exercises.dart';
import 'package:zor/widgets/small/add_exercise_list_tile.dart';

class AddPlanScreen extends StatelessWidget {
  final _nameTextEditingController = TextEditingController();

  AddPlanScreen({Key? key}) : super(key: key);

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
                'Buat Agenda',
                style: TextStyle(fontSize: 18),
              ),
            ),

            /// Workout name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _nameTextEditingController,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Nama agenda. Contoh: Workout Minggu',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Exercises
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  itemBuilder: (context, i) => AddExerciseListTile(
                    index: i,
                    name: newExercises[i].name,
                    reps: newExercises[i].reps,
                    restTime: newExercises[i].restTime,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemCount: newExercises.length,

                  /// The children which are not visible will be disposed
                  /// and garbage collected automatically
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
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
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Simpan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
