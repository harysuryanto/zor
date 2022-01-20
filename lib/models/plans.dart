import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Plans {
  FirebaseAuth instance = FirebaseAuth.instance;

  /// Create a CollectionReference called users
  /// that references the firestore collection
  CollectionReference plans = FirebaseFirestore.instance
      .collection('users')
      .doc('user1')
      .collection('plans');
}
