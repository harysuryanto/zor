import 'package:cloud_firestore/cloud_firestore.dart';

class Plan {
  final String? id;
  final String name;
  final List schedules;
  final List<Map<String, dynamic>> exercises;

  Plan({
    this.id,
    this.name = '',
    this.schedules = const [],
    this.exercises = const [],
  });

  factory Plan.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Plan(
      id: doc.id,
      name: data['name'] as String,
      schedules: data['schedules'] ?? [] as List<String>,
      exercises: data['exercises'] ?? [],
    );
  }
}
