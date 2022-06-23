import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final int index;
  final String name;
  final int repetitions;
  final int sets;

  Exercise({
    required this.id,
    this.index = -1,
    this.name = '',
    this.repetitions = 0,
    this.sets = 0,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Exercise(
      id: doc.id,
      index: data['index'] as int,
      name: data['name'] as String,
      repetitions: data['repetitions'] as int,
      sets: data['sets'] as int,
    );
  }
}
