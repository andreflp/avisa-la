import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_integ/models/occurrence_model.dart';

class OccurrenceService {
  final databaseReference = Firestore.instance;

  static const OCCURRENCE_COLLECTION = "occurrences";

  Future<List<Occurrence>> fetchAll() async {
    List<Occurrence> occurrences = [];
    QuerySnapshot snapshot = await databaseReference
        .collection(OCCURRENCE_COLLECTION)
        .getDocuments();

    snapshot.documents.forEach(
        (occurrence) => {occurrences.add(Occurrence.fromJson(occurrence))});

    return occurrences;
  }

  Future<List<Occurrence>> fetchAllByUser(String userID) async {
    List<Occurrence> occurrences = [];
    QuerySnapshot snapshot = await databaseReference
        .collection(OCCURRENCE_COLLECTION)
        .where("userId", isEqualTo: userID)
        .getDocuments();

    snapshot.documents.forEach(
        (occurrence) => {occurrences.add(Occurrence.fromJson(occurrence))});

    return occurrences;
  }

  Future<Occurrence> findById(String id) async {
    try {
      DocumentSnapshot document = await databaseReference
          .collection(OCCURRENCE_COLLECTION)
          .document(id)
          .get();
      return Occurrence.fromJson(document);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> save(Occurrence occurrence) async {
    try {
      DocumentReference ref = await databaseReference
          .collection(OCCURRENCE_COLLECTION)
          .add(occurrence.toMap());
    } catch (error) {
      print(error);
    }
  }

  Future<void> update(Occurrence occurrence) async {
    try {
      await databaseReference
          .collection(OCCURRENCE_COLLECTION)
          .document(occurrence.id)
          .updateData(occurrence.toMap());
    } catch (error) {
      print(error);
    }
  }

  Future<void> delete(String id) async {
    try {
      await databaseReference
          .collection(OCCURRENCE_COLLECTION)
          .document(id)
          .delete();
    } catch (error) {
      print(error);
    }
  }
}
