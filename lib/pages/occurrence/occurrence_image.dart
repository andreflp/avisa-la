import 'package:flutter/material.dart';
import 'package:projeto_integ/models/occurrence_model.dart';

class OccurrenceImagePage extends StatelessWidget {
  OccurrenceImagePage(this.occurrence);

  final Occurrence occurrence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(occurrence.location)),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(occurrence.imageURL), fit: BoxFit.cover),
          ),
        ));
  }
}
