import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:path/path.dart';
import 'package:projeto_integ/models/place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_integ/utils/utils.dart';

class Occurrence extends StatefulWidget {
  @override
  _OccurrenceState createState() => _OccurrenceState();
}

class _OccurrenceState extends State<Occurrence> {
  var googleApiKey = DotEnv().env['API_KEY'];
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _controller = TextEditingController();
  final _imageController = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Place _placeSelect;
  List<Place> _locationList = [];
  File imageFile;

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
                        _imageTextField(context),
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
          decoration:
              occurrenceFieldDecoration("Digite uma localização", null)),
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

  Widget _imageTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            controller: _imageController,
            onTap: () {
              _showOptionsDialog(context);
            },
            maxLines: 1,
            attribute: "_image",
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: occurrenceFieldDecoration(
                "Adicione uma imagem", Icons.camera_alt),
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
            decoration: occurrenceFieldDecoration("Digite uma descrição", null),
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

    print(predictions);

    List<Place> _results = [];

    for (var i = 0; i < predictions.length; i++) {
      _results.add(Place.fromJson(predictions[i]));
    }

    for (Place place in _results) {
      print(place.description);
    }

    return _results;
  }

  Future _openGallery(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(picture.path);
      setState(() {
        _imageController.text = basename(imageFile.path);
      });
    });

    Navigator.of(context).pop();
  }

  Future _openCamera(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(picture.path);
      setState(() {
        _imageController.text = basename(imageFile.path);
      });
    });

    Navigator.of(context).pop();
  }

  Future<void> _showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Escolha uma opção:"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  cameraBtn(context, "Galeria", _openGallery),
                  cameraBtn(context, "Câmera", _openCamera),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImage() async {
    String fileName = basename(imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    try {
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      print("Upload feito com sucesso!");
    } catch (error) {
      print("Erro ao fazer o upload: $error");
    }
  }

  Widget cameraBtn(BuildContext context, String title, Function func) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          icon: Icon(
            title == "Câmera" ? Icons.camera_alt : Icons.photo_library,
            size: 18.0,
          ),
          textColor: Colors.white,
          color: Colors.blue,
          label: Text(title),
          onPressed: () {
            func(context);
          },
        ));
  }
}
