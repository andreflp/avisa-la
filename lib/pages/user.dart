import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path/path.dart';
import 'package:projeto_integ/components/dialogs.dart';
import 'package:projeto_integ/models/user.dart';
import 'package:projeto_integ/services/user_service.dart';
import 'package:projeto_integ/utils/utils.dart';

class UserPage extends StatefulWidget {
  UserPage({this.userID});

  final String userID;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  UserService userService = UserService();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  User _user = User();
  Future<String> _fetchUser;

  String _name = "";
  String _email = "";
  String _photoURL = "";
  bool _loading = false;
  File imageFile;

  @override
  void initState() {
    _fetchUser = fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchUser,
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
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text("Meus dados"),
                ),
                body: LoadingOverlay(
                    color: Colors.grey,
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                              height: double.infinity,
                              child: FormBuilder(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 55.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _userPhoto(context),
                                      _nameTextField(),
                                      _emailTextField(),
                                      _saveUserBtn(context),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    isLoading: _loading),
              );
          }
          return null;
        });
  }

  Widget _nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            controller: _nameController,
            maxLines: 1,
            attribute: "_name",
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration:
                occurrenceFieldDecoration("Digite seu nome", null, "Nome"),
            onSaved: (value) => _name = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            readOnly: true,
            controller: _emailController,
            maxLines: 1,
            attribute: "_email",
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration:
                occurrenceFieldDecoration("Digite um e-mail", null, "E-mail"),
            onSaved: (value) => _email = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _userPhoto(BuildContext context) {
    return GestureDetector(
      onTap: () => {_showOptionsDialog(context)},
      child: Container(
        padding: EdgeInsets.only(bottom: 30.0),
        width: double.infinity,
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.blue,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_photoURL),
          ),
        ),
      ),
    );
  }

  Widget _saveUserBtn(BuildContext context) {
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

  void _validateAndSubmit(BuildContext context) {
    final form = _formKey.currentState;
    form.save();

    if (_name.isEmpty) {
      _showDialog("O campo nome é obrigatório.");
    } else {
      saveUserInfo(context);
    }
  }

  void saveUserInfo(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      User model = User();
      model.id = _user.id;
      model.name = _name;
      model.email = _user.email;
      model.password = _user.password;
      model.photoURL = _user.photoURL;

      await userService.update(model);
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

  Future _openGallery(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(picture.path);
      setState(() {
        _photoURL = basename(imageFile.path);
      });
    });

    await uploadImage();

    User model = User();
    model.id = _user.id;
    model.name = _user.name;
    model.email = _user.email;
    model.password = _user.password;
    model.photoURL = _photoURL;

    await userService.update(model);

    Navigator.of(context).pop();
  }

  Future _openCamera(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(picture.path);
      setState(() {
        _photoURL = basename(imageFile.path);
      });
    });

    await uploadImage();

    User model = User();
    model.id = _user.id;
    model.name = _user.name;
    model.email = _user.email;
    model.password = _user.password;
    model.photoURL = _photoURL;

    await userService.update(model);

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
      String dowurl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _photoURL = dowurl.toString();
      });
      print("Upload feito com sucesso!");
    } catch (error) {
      print("Erro ao fazer o upload: $error");
    }
  }

  Future<String> fetchUser() async {
    User user = await userService.findById(widget.userID);
    setState(() {
      _user = user;
    });
    _nameController.value = _nameController.value.copyWith(text: _user.name);
    _emailController.value = _emailController.value.copyWith(text: _user.email);
    _photoURL =
        _user.photoURL == null || _user.photoURL.isEmpty ? "" : _user.photoURL;

    return Future.value("Done");
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
