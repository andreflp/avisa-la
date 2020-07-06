import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/pages/map/map.dart';
import 'package:projeto_integ/services/occurrence_service.dart';

import 'collaboration_list.dart';

class Collaboration extends StatefulWidget {
  Collaboration(this.userId, this.mapsState);

  final String userId;
  final MapsState mapsState;

  @override
  State<StatefulWidget> createState() {
    return CollaborationWidget();
  }
}

class CollaborationWidget extends State<Collaboration> {
  OccurrenceService occurrenceService = OccurrenceService();
  List<Occurrence> occurrencies;
  bool loading = false;

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
                  body: snapshot.data.length == 0
                      ? Center(
                          child: Text(
                            "Nenhuma ocorrência registrada.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : LoadingOverlay(
                          color: Colors.grey,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              Occurrence occurrence = snapshot.data[index];
                              return Column(
                                children: <Widget>[
                                  CollaborationList(occurrence, context, this,
                                      widget.mapsState)
                                ],
                              );
                            },
                          ),
                          isLoading: loading,
                        ));
          }
          return null;
        });
  }

  Future<List<Occurrence>> fetchUserOccurrences(String userId) async {
    return await occurrenceService.fetchAllByUser(userId);
  }
}
