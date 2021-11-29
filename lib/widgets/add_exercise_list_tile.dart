import 'package:flutter/material.dart';

class AddExerciseListTile extends StatelessWidget {
  final int index;
  final String name;
  final String reps;
  final String restTime;

  TextEditingController? _nameTextEditingController;
  TextEditingController? _repsTextEditingController;
  TextEditingController? _restTimeTextEditingController;

  AddExerciseListTile({
    Key? key,
    required this.index,
    required this.name,
    required this.reps,
    required this.restTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameTextEditingController = TextEditingController(text: name);
    _repsTextEditingController = TextEditingController(text: reps);
    _restTimeTextEditingController = TextEditingController(text: restTime);

    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              print('Item $index pressed');

              /// TODO: uncomment this below after state manager implemented
              // newExercises.removeAt(index);
            },
            child: Container(
              padding: const EdgeInsets.only(
                top: 8,
                right: 10,
                left: 30,
                bottom: 8,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// name
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _nameTextEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Nama gerakan',
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// restTime
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _restTimeTextEditingController,
                          decoration: const InputDecoration(
                            hintText: 'Repetisi',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const Icon(Icons.timer_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// reps
          Container(
            width: 80,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _repsTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Repetisi',
                hintStyle: TextStyle(fontSize: 12),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
