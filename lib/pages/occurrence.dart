import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_integ/models/place.dart';

class Occurrence extends StatefulWidget {
  @override
  _OccurrenceState createState() => _OccurrenceState();
}

class _OccurrenceState extends State<Occurrence> {
  static const googleApiKey = "AIzaSyAUMdaC3fs6NfUBgBhwDZEtqnN-D8krvsM";
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _controller = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Place _placeSelect;
  List<Place> _locationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Nova Ocorrência"),
        ),
        body: Center(
          child: Stack(children: <Widget>[
            Container(
                height: double.infinity,
                child: FormBuilder(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 70.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _locationTextField(),
                        _imageTextField(),
                        _descriptionTextField(),
                        _saveOccurrenceBtn(context)
                      ],
                    ),
                  ),
                )),
          ]),
        ));
  }

  Widget _locationTextField() {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 2,
        keyboardType: TextInputType.text,
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          counterText: ' ',
          hintText: 'Digite uma localização',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return await this.searchLocations(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.place),
          title: Text(suggestion.mainText),
          subtitle: Text(suggestion.secondaryText),
        );
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          _controller.value =
              _controller.value.copyWith(text: suggestion.description);
          _placeSelect = suggestion;
        });
      },
    );
  }

  Widget _imageTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            maxLines: 1,
            attribute: "_image",
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: InputDecoration(
                counterText: ' ',
                hintText: 'Adicionar uma imagem',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Icon(Icons.camera_alt)),
            onSaved: (value) => {},
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
            maxLines: 3,
            attribute: "_description",
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: InputDecoration(
              counterText: ' ',
              hintText: 'Digite uma descrição',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onSaved: (value) => {},
          ),
        ),
      ],
    );
  }

  Widget _saveOccurrenceBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {},
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.blue,
        child: Text(
          "Salvar",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.0,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<Iterable<Place>> searchLocations(String text) async {
    if (text.isEmpty) {
      return null;
    }

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String language = 'pt-BR';

    String request =
        '$baseURL?input=$text&key=$googleApiKey&language=$language';
    Response response = await Dio().get(request);

    final predictions = response.data['predictions'];

    List<Place> _results = [];

    for (var i = 0; i < predictions.length; i++) {
      _results.add(Place.fromJson(predictions[i]));
    }

    for (Place place in _results) {
      print(place.description);
    }

    return _results;
//
//    setState(() {
//      _locationList = _results;
//    });
  }
}
//
//class OccurrenceModal {
//
//
//  Widget _saveOccurrenceBtn(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
//      width: double.infinity,
//      child: RaisedButton(
//        elevation: 5.0,
//        onPressed: () => {},
//        padding: EdgeInsets.all(15.0),
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10.0),
//        ),
//        color: Colors.blue,
//        child: Text(
//          "Salvar",
//          style: TextStyle(
//            color: Colors.white,
//            letterSpacing: 1.0,
//            fontSize: 15.0,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//      ),
//    );
//  }
//
//  mainBottomSheet(BuildContext context) {
//    showModalBottomSheet(
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.vertical(
//                top: Radius.circular(20.0), bottom: Radius.circular(20.0))),
//        isScrollControlled: true,
//        context: context,
//        builder: (BuildContext context) {
//          return Padding(
//            padding: MediaQuery.of(context).viewInsets,
//            child: Container(
//              child: Wrap(children: <Widget>[
//                Center(
//                  child: Padding(
//                      padding: EdgeInsets.only(top: 15.0),
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  "Nova Ocorrência",
//                                  style: TextStyle(
//                                      color: Colors.blue, fontSize: 18.0),
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 4.0),
//                                  child:
//                                      Icon(Icons.warning, color: Colors.blue),
//                                ),
//                              ]),
//                        ],
//                      )),
//                ),
//                FormBuilder(
//                  child: SingleChildScrollView(
//                    physics: AlwaysScrollableScrollPhysics(),
//                    padding: EdgeInsets.symmetric(
//                      horizontal: 25.0,
//                      vertical: 30.0,
//                    ),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        _locationTextField(),
//                        _imageTextField(),
//                        _descriptionTextField(),
//                        _saveOccurrenceBtn(context),
//                      ],
//                    ),
//                  ),
//                ),
//              ]),
//            ),
//          );
//        });
//  }
//}
