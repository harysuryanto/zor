import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../utils/colors.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({Key? key}) : super(key: key);

  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final _formKeyExerciseName = GlobalKey<FormState>();
  final sslSetKey = GlobalKey<ScrollSnapListState>();
  final sslRepetitionKey = GlobalKey<ScrollSnapListState>();

  /// Assigned in [initState()]
  final List<int> _repetitionNumbers = [];
  final List<int> _setNumbers = [];

  String _exerciseName = '';
  int _focusedRepetitionIndex = 0;
  int _focusedSetIndex = 0;

  @override
  void initState() {
    super.initState();

    const int maxRepetitions = 50;
    const int maxSets = 10;

    /// Give set and repetition default values
    for (int i = 1; i <= maxRepetitions; i++) {
      _repetitionNumbers.add(i);
    }
    for (int i = 1; i <= maxSets; i++) {
      _setNumbers.add(i);
    }
  }

  void _onSetFocus(int index) {
    setState(() {
      _focusedSetIndex = index;
    });
    print(_focusedSetIndex);
  }

  void _onRepetitionFocus(int index) {
    setState(() {
      _focusedRepetitionIndex = index;
    });
    print(_focusedRepetitionIndex);
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
                                  itemCount: _repetitionNumbers.length,
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
                                  itemCount: _setNumbers.length,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSetListItemTile({
    required BuildContext context,
    required int index,
  }) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        '${_setNumbers[index]}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: _focusedSetIndex == index ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _buildRepetitionListItemTile({
    required BuildContext context,
    required int index,
  }) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        '${_repetitionNumbers[index]}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: _focusedRepetitionIndex == index ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
