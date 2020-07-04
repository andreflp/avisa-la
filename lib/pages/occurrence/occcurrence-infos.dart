import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/utils/utils.dart';
import 'package:transparent_image/transparent_image.dart';

import 'occurrence_image.dart';

class OccurrenceInfoPage extends StatefulWidget {
  OccurrenceInfoPage(this.occurrence);

  final Occurrence occurrence;

  @override
  _OccurrenceInfoPageState createState() => _OccurrenceInfoPageState();
}

class _OccurrenceInfoPageState extends State<OccurrenceInfoPage> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _severityController = TextEditingController();

  String _location = "";
  String _description = "";
  String _severity = "";

  @override
  void initState() {
    _locationController.value =
        _locationController.value.copyWith(text: widget.occurrence.location);
    _descriptionController.value = _descriptionController.value
        .copyWith(text: widget.occurrence.description);
    _severityController.value =
        _severityController.value.copyWith(text: widget.occurrence.severity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes da Ocorrência"),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      Transition(
                          widget: OccurrenceImagePage(widget.occurrence)),
                    )
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.occurrence.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                  child: FormBuilder(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _locationTextField(),
                      _descriptionTextField(),
                      _severityTextField()
                    ],
                  ),
                ),
              )),
            ],
          ),
        ));
  }

  Widget _locationTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            readOnly: true,
            controller: _locationController,
            maxLines: 3,
            attribute: "_description",
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: occurrenceFieldDecoration(
                "Digite uma descrição", null, "Local"),
            onSaved: (value) => _description = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _descriptionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
              readOnly: true,
              controller: _descriptionController,
              maxLines: 2,
              attribute: "_description",
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black54,
              ),
              decoration: occurrenceFieldDecoration(
                  "Digite uma descrição", null, "Descrição")),
        ),
      ],
    );
  }

  Widget _severityTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
              readOnly: true,
              controller: _severityController,
              maxLines: 1,
              attribute: "_severity",
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black54,
              ),
              decoration:
                  occurrenceFieldDecoration("Gravidade", null, "Gravidade")),
        ),
      ],
    );
  }
}
