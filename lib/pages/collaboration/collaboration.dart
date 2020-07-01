import 'package:flutter/material.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/services/occurrence_service.dart';

import 'collaboration_list.dart';

class Collaboration extends StatefulWidget {
  Collaboration(this.userId);

  final String userId;

  @override
  State<StatefulWidget> createState() {
    return CollaborationWidget();
  }
}

class CollaborationWidget extends State<Collaboration> {
  OccurrenceService occurrenceService = OccurrenceService();
  List<Occurrence> occurrencies;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUserOccurrences(widget.userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.waiting:
              return MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                  backgroundColor: Colors.white,
                ),
              );
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: Text("Colaborações"),
                ),
                body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Occurrence occurrence = snapshot.data[index];
                    return Column(
                      children: <Widget>[card(context, occurrence)],
                    );
                  },
                ),
              );
          }
          return null;
        });
  }

  Future<List<Occurrence>> fetchUserOccurrences(String userId) async {
    return await occurrenceService.fetchAllByUser(userId);
  }
}
