import 'package:cloud_firestore/cloud_firestore.dart';

class Plans {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  DocumentReference get currentUser {
    /// TODO: ganti [user1] menjadi dinamis
    return instance.collection('users').doc('user1');
  }

  CollectionReference get plans {
    return currentUser.collection('plans');
  }

  CollectionReference exercises({required String planId}) {
    final exercises = plans.doc(planId).collection('exercises');
    return exercises;
  }
}
