import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class OccurrenceService {
  Future<QuerySnapshot> fetchAll();

  void save();

  void update();
}

class OccurrenceServiceImpl implements OccurrenceService {
  final databaseReference = Firestore.instance;

  @override
  Future<QuerySnapshot> fetchAll() async {
    List<Occurrence>
    databaseReference
        .collection("occurrences")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  @override
  void save() async {
    // TODO: implement save
  }

  @override
  void update() async {
    // TODO: implement update
  }
}
