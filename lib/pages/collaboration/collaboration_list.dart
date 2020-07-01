import 'package:flutter/material.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/pages/occurrence/occurrence_edit.dart';

Widget card(BuildContext context, Occurrence occurrence) {
  Color setColor(String severity) {
    if (severity == "Alta") {
      return Colors.red;
    } else if (severity == "Média") {
      return Color(0xFFfcba03);
    } else {
      return Colors.blue;
    }
  }

  return GestureDetector(
      onTap: () => {
            Navigator.push(context,
                Transition(widget: OccurrenceEditPage(occurrence: occurrence)))
          },
      child: Card(
        elevation: 5,
        child: Container(
          height: 100.0,
          child: Row(
            children: <Widget>[
              Container(
                height: 100.0,
                width: 70.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(occurrence.imageURL.isNotEmpty
                            ? occurrence.imageURL
                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR7p-SbihJOWctH9CrNnnfU_qXQi1Tqe2wu7g&usqp=CAU"))),
              ),
              Container(
                height: 100,
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
                            occurrence.location,
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
                            occurrence.description,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 48, 48, 54)),
                          ),
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
