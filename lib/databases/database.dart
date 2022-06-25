import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/exercise.dart';
import '../models/my_profile.dart';
import '../models/plan.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// User
  Future<MyProfile> getMyProfile(String id) async {
    final snap = await _db.collection('users').doc(id).get().catchError(
        (error) => print("Failed to get current profile document: $error"));

    return MyProfile.fromMap(snap.data as Map<String, dynamic>);
  }

  Stream<MyProfile> streamMyProfile(String uid) {
    final ref = _db.collection('users').doc(uid);

    return ref.snapshots().map((snap) {
      var data = snap.data() as Map<String, dynamic>;
      return MyProfile.fromMap(data);
    });
  }

  /// Plan
  Stream<List<Plan>> streamPlans(
    User user, {
    int? limit,
    String? whereScheduleIs,
  }) {
    Query<Map<String, dynamic>> ref;
    ref = _db
        .collection('users')
        .doc(user.uid)
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
    User user,
    dynamic data, {
    FutureOr<void> Function(
            DocumentReference<Map<String, dynamic>> documentReference)?
        then,
  }) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .add(data)
        .then(then ?? (_) {})
        .then((_) => print("Plan added"))
        .catchError((error) => print("Failed to add plan: $error"));
  }

  Future<void> updatePlan(
    User user,
    dynamic data,
    String planId, {
    FutureOr<void> Function(void)? then,
  }) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .update(data)
        .then(then ?? (_) {})
        .then((_) => print("Plan updated"))
        .catchError((error) => print("Failed to update plan: $error"));
  }

  Future<void> removePlan(User user, String planId) {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .delete()
        .then((_) => print("Plan deleted"))
        .catchError((error) => print("Failed to delete plan: $error"));
  }

  /// Exercise
  Stream<List<Exercise>> streamExercises(User user, String planId) {
    final ref = _db
        .collection('users')
        .doc(user.uid)
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

  Future<void> addExercise(User user, String planId, dynamic data) {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .add(data)
        .then((_) => print("Exercise added"))
        .catchError((error) => print("Failed to add exercise: $error"));
  }

  Future<void> reorderExerciseIndexes(
    User user,
    String planId, {
    required List<Exercise> oldList,
    required List<Exercise> newList,
  }) async {
    log('--------------------------------------------------');

    for (var i = 0; i < newList.length; i++) {
      var oldExercise = oldList[i];
      var newExercise = newList[i];

      if (oldExercise.index != newExercise.index) {
        await updateExercise(
          user,
          {'index': oldExercise.index},
          planId,
          newExercise.id,
        );

        log('* ${oldExercise.index} -> ${newExercise.index}');
      }
    }
  }

  Future<void> updateExercise(
    User user,
    dynamic data,
    String planId,
    String exerciseId,
  ) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .doc(exerciseId)
        .update(data)
        .then((_) => print("Exercise updated"))
        .catchError((error) => print("Failed to update exercise: $error"));
  }

  Future<void> removeExercise(User user, String planId, String exerciseId) {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .doc(exerciseId)
        .delete()
        .then((_) => print("Exercise deleted"))
        .catchError((error) => print("Failed to delete exercise: $error"));
  }

  /// Returns highest exercise index. Will return -1 if the exercise is empty.
  Future<int> getHighestExerciseIndex(User user, String planId) async {
    final snap = await _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises')
        .orderBy('index', descending: true)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? snap.docs.first.data()['index'] : -1;
  }
}
