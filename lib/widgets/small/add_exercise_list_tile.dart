import 'package:flutter/material.dart';

class AddExerciseListTile extends StatefulWidget {
  final int index;
  final String name;
  final String reps;
  final String restTime;

  AddExerciseListTile({
    Key? key,
    required this.index,
    required this.name,
    required this.reps,
    required this.restTime,
  }) : super(key: key);

  @override
  State<AddExerciseListTile> createState() => _AddExerciseListTileState();
}

class _AddExerciseListTileState extends State<AddExerciseListTile> {
  TextEditingController? _nameTextEditingController;

  TextEditingController? _repsTextEditingController;

  TextEditingController? _restTimeTextEditingController;

  @override
  void dispose() {
    _nameTextEditingController!.dispose();
    _repsTextEditingController!.dispose();
    _restTimeTextEditingController!.dispose();

    print('data ${widget.index} disposed');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nameTextEditingController = TextEditingController(text: widget.name);
    _repsTextEditingController = TextEditingController(text: widget.reps);
    _restTimeTextEditingController =
        TextEditingController(text: widget.restTime);

    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              print('Deleting item ${widget.index}');

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
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Nama gerakan',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textInputAction: TextInputAction.next,
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
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Repetisi',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          textInputAction: TextInputAction.next,
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
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Repetisi',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
    );
  }
}
