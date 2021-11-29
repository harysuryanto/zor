import 'package:flutter/material.dart';
import 'package:zor/models/new_exercises.dart';
import 'package:zor/widgets/add_exercise_list_tile.dart';

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
                ),
              ),
            ),

            /// Bottom section
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '20 menit',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text('Estimasi waktu total'),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      print('Mulai olahraga 🏃‍♂️');

                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Text('Mulai olahraga'),
                        SizedBox(width: 10),
                        Icon(Icons.run_circle_rounded),
                      ],
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
