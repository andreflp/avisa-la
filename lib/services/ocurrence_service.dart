import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_integ/models/occurrence_model.dart';

class OccurrenceService {
  final databaseReference = Firestore.instance;

  static const OCCURRENCE_COLLECTION = "occurrences";

  Future<List<Occurrence>> fetchAll() async {
    List<Occurrence> occurrencies = [];
    QuerySnapshot snapshot = await databaseReference
        .collection(OCCURRENCE_COLLECTION)
        .getDocuments();

    for (var i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      occurrencies.add(Occurrence.fromJson(document));
    }

    return occurrencies;
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
    await databaseReference
        .collection(OCCURRENCE_COLLECTION)
        .document(occurrence.id)
        .setData(occurrence.toMap());
  }
}
