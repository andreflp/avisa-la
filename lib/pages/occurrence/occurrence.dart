import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path/path.dart';
import 'package:projeto_integ/components/dialogs.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/models/place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_integ/services/occurrence_service.dart';
import 'package:projeto_integ/utils/utils.dart';

class OccurrencePage extends StatefulWidget {
  @override
  _OccurrencePageState createState() => _OccurrencePageState();
}

class _OccurrencePageState extends State<OccurrencePage> {
  var googleApiKey = DotEnv().env['API_KEY'];
  var urlAutocomplete = DotEnv().env['URL_AUTOCOMPLETE'];
  var urlDetails = DotEnv().env['URL_DETAILS'];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _locationController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  File imageFile;

  OccurrenceService occurrenceService = OccurrenceService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String _userId = "";
  String _placeId = "";
  String _location = "";
  String _severity = "";
  String _imageURL = "";
  double _lat;
  double _long;
  String _description = "";
  bool _loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Nova Ocorrência"),
      ),
      body: LoadingOverlay(
          color: Colors.grey,
          child: Center(
            child: Stack(children: <Widget>[
              Container(
                  height: double.infinity,
                  child: FormBuilder(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 55.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _locationTextField(),
                          _imageTextField(context),
                          _descriptionTextField(),
                          _severityRadio(),
                          _saveOccurrenceBtn(context)
                        ],
                      ),
                    ),
                  )),
            ]),
          ),
          isLoading: _loading),
    );
  }

  Widget _locationTextField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 2,
        keyboardType: TextInputType.text,
        controller: _locationController,
        decoration: occurrenceFieldDecoration(
            "Digite uma localização *", null, "Local"),
      ),
      suggestionsCallback: (pattern) async {
        return await this.searchLocations(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.place),
          title: Text(suggestion.mainText ?? ""),
          subtitle: Text(suggestion.secondaryText ?? ""),
        );
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          _locationController.value =
              _locationController.value.copyWith(text: suggestion.description);
          _placeId = suggestion.placeId;
        });
      },
      onSaved: (value) => _location = value.trim(),
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
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: occurrenceFieldDecoration(
                "Adicione uma imagem", Icons.camera_alt, "Imagem"),
            attribute: null,
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
            controller: _descriptionController,
            maxLines: 3,
            attribute: "_description",
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: occurrenceFieldDecoration(
                "Digite uma descrição", null, "Descrição"),
            onSaved: (value) => _description = value.trim(),
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
        onPressed: () => _validateAndSubmit(context),
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

  Widget _severityRadio() {
    return Container(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Gravidade *",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: "Baixa",
                    groupValue: _severity,
                    onChanged: _onSeverityChange,
                  ),
                  Text(
                    "Baixa",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                  Radio(
                    value: "Média",
                    groupValue: _severity,
                    onChanged: _onSeverityChange,
                  ),
                  Text(
                    "Média",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                  Radio(
                    value: "Alta",
                    groupValue: _severity,
                    onChanged: _onSeverityChange,
                  ),
                  Text(
                    "Alta",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ]));
  }

  Future<Iterable<Place>> searchLocations(String text) async {
    if (text.isEmpty) {
      return null;
    }

    String baseURL = urlAutocomplete;
    String language = 'pt-BR';

    String request =
        '$baseURL?input=$text&key=$googleApiKey&language=$language';

    try {
      Response response = await Dio().get(request);
      final predictions = response.data['predictions'];

      List<Place> _results = [];

      for (var i = 0; i < predictions.length; i++) {
        _results.add(Place.fromJson(predictions[i]));
      }

      return _results;
    } catch (error) {
      print(error);
    }
  }

  Future getLatLongByPlace(String placeId) async {
    String baseURL = urlDetails;
    String request = '$baseURL?placeid=$placeId&key=$googleApiKey';

    try {
      Response response = await Dio().get(request);
      setState(() {
        _lat = response.data["result"]["geometry"]["location"]["lat"];
        _long = response.data["result"]["geometry"]["location"]["lng"];
      });
    } catch (error) {
      print(error);
    }
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
    if (imageFile == null) return;
    String fileName = basename(imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    try {
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String dowurl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _imageURL = dowurl.toString();
      });
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

  void _onSeverityChange(value) {
    setState(() {
      _severity = value;
    });
  }

  void _validateAndSubmit(BuildContext context) {
    final form = _formKey.currentState;
    form.save();

    if (_location.isEmpty && _severity.isEmpty) {
      _showDialog("Selecione uma localização e uma gravidade");
    } else if (_severity.isEmpty) {
      _showDialog("Selecione uma gravidade");
    } else if (_location.isEmpty) {
      _showDialog("Selecione uma localização");
    } else {
      saveOccurrence(context);
    }
  }

  void saveOccurrence(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      await uploadImage();
      await getLatLongByPlace(_placeId);
      FirebaseUser user = await _auth.currentUser();

      Occurrence model = Occurrence();
      model.userId = user.uid;
      model.location = _location;
      model.lat = _lat;
      model.long = _long;
      model.imageURL = _imageURL;
      model.severity = _severity;
      model.description = _description;

      await occurrenceService.save(model);
      _formKey.currentState.reset();

      showSuccessDialog(context);

      setState(() {
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print(error);
    }
  }

  void _showDialog(String msg) {
    var snackbar = SnackBar(
      action: SnackBarAction(
        label: 'Fechar',
        textColor: Colors.white,
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            msg,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
      ),
      backgroundColor: Color(0xffdd2c00),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      behavior: SnackBarBehavior.floating,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
