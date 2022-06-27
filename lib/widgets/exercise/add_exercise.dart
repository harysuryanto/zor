import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:uuid/uuid.dart';

import '../../databases/database.dart';
import '../../models/exercise.dart';
import '../../utils/colors.dart';

class AddExercise extends StatefulWidget {
  final String? planId;
  final void Function(Exercise) onSubmit;

  const AddExercise({
    Key? key,
    required this.planId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final formKeyExerciseName = GlobalKey<FormState>();
  final sslSetKey = GlobalKey<ScrollSnapListState>();
  final sslRepetitionKey = GlobalKey<ScrollSnapListState>();

  /// These are assigned in initState()
  final List<int> repetitionOptions = [];
  final List<int> setOptions = [];

  String exerciseName = '';
  int focusedRepetitionIndex = 0;
  int focusedSetIndex = 0;

  @override
  void initState() {
    super.initState();

    const int maxRepetitions = 50;
    const int maxSets = 10;

    /// Give repetition and set default values
    for (int i = 1; i <= maxRepetitions; i++) {
      repetitionOptions.add(i);
    }
    for (int i = 1; i <= maxSets; i++) {
      setOptions.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👟', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          const Text(
            'Berapa banyak waktu yang akan digunakan?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sebaiknya berdasarkan sains!',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Form(
            key: formKeyExerciseName,
            child: TextFormField(
              onChanged: (value) => setState(() => exerciseName = value),
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('Rep', style: TextStyle(fontSize: 18)),
                      Text('Set', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            /// Repetitions
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(scrollbars: false),
                                child: ScrollSnapList(
                                  key: sslRepetitionKey,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          _buildRepetitionListItemTile(
                                              context: context, index: index),
                                  onItemFocus: (index) =>
                                      _onRepetitionFocus(index),
                                  itemSize:
                                      40, // Size of widget [_buildRepetitionListItemTile]
                                  itemCount: repetitionOptions.length,
                                  dynamicItemOpacity: 0.3,
                                  scrollDirection: Axis.vertical,
                                  scrollPhysics: const BouncingScrollPhysics(),
                                ),
                              ),
                            ),

                            /// Sets
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(scrollbars: false),
                                child: ScrollSnapList(
                                  key: sslSetKey,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          _buildSetListItemTile(
                                              context: context, index: index),
                                  onItemFocus: (index) => _onSetFocus(index),
                                  itemSize:
                                      40, // Size of widget [_buildSetListItemTile]
                                  itemCount: setOptions.length,
                                  dynamicItemOpacity: 0.3,
                                  scrollDirection: Axis.vertical,
                                  scrollPhysics: const BouncingScrollPhysics(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.maxFinite,
            child: OutlinedButton(
              onPressed: () async {
                if (formKeyExerciseName.currentState!.validate()) {
                  final db = DatabaseService();
                  final user = Provider.of<User?>(context, listen: false);
                  final exerciseIndex = widget.planId != null
                      ? await db.getHighestExerciseIndex(
                              user!, widget.planId!) +
                          1
                      : -1;

                  widget.onSubmit(
                    Exercise(
                      id: const Uuid().v1(),
                      index: exerciseIndex,
                      name: exerciseName,
                      repetitions: repetitionOptions[focusedRepetitionIndex],
                      sets: setOptions[focusedSetIndex],
                    ),
                  );
                  // ignore: use_build_context_synchronously
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
              child: const Text('Simpan', style: TextStyle(color: whiteColor)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepetitionListItemTile({
    required BuildContext context,
    required int index,
  }) {
    return Container(
      key: ValueKey('repetition option index $index'),
      height: 40,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Text(
        '${repetitionOptions[index]}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: focusedRepetitionIndex == index ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _buildSetListItemTile({
    required BuildContext context,
    required int index,
  }) {
    return Container(
      key: ValueKey('set option index $index'),
      height: 40,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Text(
        '${setOptions[index]}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: focusedSetIndex == index ? FontWeight.bold : null,
        ),
      ),
    );
  }

  void _onRepetitionFocus(int index) {
    setState(() => focusedRepetitionIndex = index);
  }

  void _onSetFocus(int index) {
    setState(() => focusedSetIndex = index);
  }
}
