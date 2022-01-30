import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({Key? key}) : super(key: key);

  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final _formKeyExerciseName = GlobalKey<FormState>();
  String _exerciseName = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('👟', style: TextStyle(fontSize: 96)),
          const SizedBox(height: 30),
          const Text(
            'How much time are you ready to spend on workout?',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          const SizedBox(height: 20),
          const Text(
            'Make sure it\'s based on science!',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKeyExerciseName,
            child: TextFormField(
              onChanged: (value) => setState(() => _exerciseName = value),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mohon isi nama latihan.';
                }
                return null;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                isDense: true,
                hintText: 'Nama latihan',
                filled: true,
                fillColor: Colors.white54,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              height: 50,
              width: 200,
              child: Text('Lanjutkan ini'),
              decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            child: const Text('Simpan', style: TextStyle(color: whiteColor)),
            onPressed: () {
              if (_formKeyExerciseName.currentState!.validate()) {
                print('Siap disimpan ke database');
                Navigator.of(context).pop();
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 1, color: whiteColor),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
