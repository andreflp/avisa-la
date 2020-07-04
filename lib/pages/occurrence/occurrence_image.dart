import 'package:flutter/material.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:transparent_image/transparent_image.dart';

class OccurrenceImagePage extends StatelessWidget {
  OccurrenceImagePage(this.occurrence);

  final Occurrence occurrence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(occurrence.location)),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(occurrence.imageURL),
                ),
              ),
            )),
          ],
        ));
  }
}
