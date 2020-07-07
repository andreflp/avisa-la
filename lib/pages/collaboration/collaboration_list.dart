import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_integ/components/dialogs.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/pages/collaboration/collaboration.dart';
import 'package:projeto_integ/pages/map/map.dart';
import 'package:projeto_integ/pages/occurrence/occurrence_edit.dart';
import 'package:projeto_integ/services/occurrence_service.dart';
import 'package:transparent_image/transparent_image.dart';

class CollaborationList extends StatelessWidget {
  CollaborationList(
      this.occurrence, this.bc, this.collaboration, this.mapsState);

  final Occurrence occurrence;
  final CollaborationWidget collaboration;
  final BuildContext bc;
  final OccurrenceService occurrenceService = OccurrenceService();
  final MapsState mapsState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              Navigator.push(
                  context,
                  Transition(
                      widget: OccurrenceEditPage(occurrence: occurrence)))
            },
        child: Card(
          elevation: 5,
          child: Container(
            height: 120.0,
            child: Row(
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: 70.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: occurrence.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                ),
                Container(
                  height: 120,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 20.0,
                          width: 55.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: setColor(occurrence.severity),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0))),
                              child: Center(
                                child: Text(
                                  occurrence.severity,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                          child: Container(
                            width: 260,
                            child: Text(
                              makeEllipsis(occurrence.location),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 48, 48, 54)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                          child: Container(
                            width: 260,
                            child: Text(
                              makeEllipsis(occurrence.description),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 48, 48, 54)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.53),
                          child: ButtonBar(
                            children: <Widget>[
                              Container(
                                width: 60.0,
                                height: 30.0,
                                child: FlatButton(
                                  child: Icon(Icons.delete, size: 18.0),
                                  color: Colors.red,
                                  onPressed: () {
                                    _showOptionsDialog(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Color setColor(String severity) {
    if (severity == "Alta") {
      return Colors.red;
    } else if (severity == "Média") {
      return Color(0xFFfcba03);
    } else {
      return Colors.blue;
    }
  }

  String makeEllipsis(String text) {
    if (text.length < 30) {
      return text;
    } else {
      return "${text.substring(0, 30)}...";
    }
  }

  Future<void> deleteOccurrence(BuildContext context, String id) async {
    try {
      Navigator.of(context).pop();
      await occurrenceService.delete(id);

      await this.mapsState.fetchOccurrences();

      showRemoveSuccessDialog(this.bc, id, this.collaboration);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  SizedBox(
                      width: 100,
                      child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 15.0,
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        label: Text("Voltar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                  SizedBox(
                      width: 100,
                      child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        icon: Icon(
                          Icons.delete,
                          size: 15.0,
                        ),
                        textColor: Colors.white,
                        color: Colors.red,
                        label: Text("Sim"),
                        onPressed: () async {
                          deleteOccurrence(context, occurrence.id);
                        },
                      )),
                ],
              ),
            ],
            title: Text("Deseja remover esta ocorrência?"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          );
        });
  }
}
