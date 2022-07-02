import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/exercise.dart';
import '../models/plan.dart';

class FirestoreService {
  FirestoreService({required this.uid});

  final String uid;
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  /// Plan
  Stream<List<Plan>> streamPlans({
    int? limit,
    String? whereScheduleIs,
  }) {
    Query<Map<String, dynamic>> ref;
    ref = _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .orderBy('name');

    if (limit != null) {
      ref = ref.limit(limit);
    }

    if (whereScheduleIs != null) {
      ref = ref.where('schedules', arrayContains: whereScheduleIs);
    }

    return ref.snapshots().map((list) {
      return list.docs.map((doc) {
        return Plan.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addPlan(
    dynamic data, {
    FutureOr<void> Function(
            DocumentReference<Map<String, dynamic>> documentReference)?
        then,
  }) async {
    return _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .add(data)
        .then(then ?? (_) {})
        .then((_) => debugPrint("Plan added"))
        .catchError((error) => debugPrint("Failed to add plan: $error"));
  }

  Future<void> updatePlan(
    dynamic data,
    String planId, {
    FutureOr<void> Function(void)? then,
  }) async {
    return _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .update(data)
        .then(then ?? (_) {})
        .then((_) => debugPrint("Plan updated"))
        .catchError((error) => debugPrint("Failed to update plan: $error"));
  }

  Future<void> removePlan(String planId) {
    return _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .delete()
        .then((_) => debugPrint("Plan deleted"))
        .catchError((error) => debugPrint("Failed to delete plan: $error"));
  }

  /// Exercise
  Stream<List<Exercise>> streamExercises(String planId) {
    final ref = _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .orderBy('index');

    return ref.snapshots().map((list) {
      return list.docs.map((doc) {
        return Exercise.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addExercise(String planId, dynamic data) {
    return _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .add(data)
        .then((_) => debugPrint("Exercise added"))
        .catchError((error) => debugPrint("Failed to add exercise: $error"));
  }

  Future<void> reorderExerciseIndexes(
    String planId, {
    required List<Exercise> oldList,
    required List<Exercise> newList,
  }) async {
    oldList.sort((a, b) => a.id.compareTo(b.id));
    newList.sort((a, b) => a.id.compareTo(b.id));

    for (var i = 0; i < oldList.length; i++) {
      final oldExercise = oldList[i];
      final newExercise = newList[i];

      if (oldExercise.index != newExercise.index) {
        await updateExercise(
          {'index': newExercise.index},
          planId,
          oldExercise.id,
        );
      }
    }
  }

  Future<void> updateExercise(
    dynamic data,
    String planId,
    String exerciseId,
  ) async {
    return _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .doc(exerciseId)
        .update(data)
        .then((_) => debugPrint("Exercise updated"))
        .catchError((error) => debugPrint("Failed to update exercise: $error"));
  }

  Future<void> removeExercise(String planId, String exerciseId) {
    return _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .doc(exerciseId)
        .delete()
        .then((_) => debugPrint("Exercise deleted"))
        .catchError((error) => debugPrint("Failed to delete exercise: $error"));
  }

  /// Returns highest exercise index. Will return -1 if the exercise is empty.
  Future<int> getHighestExerciseIndex(String planId) async {
    final snap = await _instance
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .orderBy('index', descending: true)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? snap.docs.first.data()['index'] : -1;
  }
}
