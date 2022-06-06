import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final int repetitions;
  final int sets;

  Exercise({
    required this.id,
    required this.name,
    required this.repetitions,
    required this.sets,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Exercise(
      id: doc.id,
      name: data['name'],
      repetitions: data['repetitions'],
      sets: data['sets'],
    );
  }
}
