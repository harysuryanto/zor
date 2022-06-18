import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String? id;
  final String name;
  final int repetitions;
  final int sets;

  Exercise({
    this.id,
    this.name = '',
    this.repetitions = 0,
    this.sets = 0,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Exercise(
      id: doc.id,
      name: data['name'] as String,
      repetitions: data['repetitions'] as int,
      sets: data['sets'] as int,
    );
  }
}
