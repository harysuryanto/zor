import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/exercise.dart';
import '../models/my_profile.dart';
import '../models/plan.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// User
  Future<MyProfile> getMyProfile(String id) async {
    var snap = await _db.collection('users').doc(id).get().catchError(
        (error) => print("Failed to get current profile document: $error"));

    return MyProfile.fromMap(snap.data as Map<String, dynamic>);
  }

  Stream<MyProfile> streamMyProfile(String uid) {
    var ref = _db.collection('users').doc(uid);

    return ref.snapshots().map((snap) {
      var data = snap.data() as Map<String, dynamic>;
      return MyProfile.fromMap(data);
    });
  }

  /// Plan
  Stream<List<Plan>> streamPlans(User user) {
    var ref = _db.collection('users').doc(user.uid).collection('plans');

    return ref.snapshots().map((list) {
      return list.docs.map((doc) {
        return Plan.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addPlan(User user, dynamic data) {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .add(data)
        .then((value) => print("Plan added"))
        .catchError((error) => print("Failed to add plan: $error"));
  }

  Future<void> removePlan(User user, String planId) {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .delete()
        .then((value) => print("Plan deleted"))
        .catchError((error) => print("Failed to delete plan: $error"));
  }

  /// Exercise
  Stream<List<Exercise>> streamExercises(User user, String planId) {
    var ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planId)
        .collection('exercises');

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
        .then((value) => print("Exercise added"))
        .catchError((error) => print("Failed to add exercise: $error"));
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
        .then((value) => print("Exercise deleted"))
        .catchError((error) => print("Failed to delete exercise: $error"));
  }
}
