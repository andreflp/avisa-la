import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _id;
  String _name;
  String _email;
  String _password;
  String _photoURL;

  User(
      {String id,
      String name,
      String email,
      String password,
      String photoURL}) {
    _id = id;
    _name = name;
    _email = email;
    _password = password;
    _photoURL = photoURL;
  }

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get photoURL => _photoURL;

  set id(String id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  set photoURL(String photoURL) => _photoURL = photoURL;

  factory User.fromJson(DocumentSnapshot document) => User(
      id: document.documentID,
      name: document.data["name"],
      email: document.data["email"],
      password: document.data["password"],
      photoURL: document.data["photoURL"]);

  toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = this._name;
    map["email"] = this._email;
    map["password"] = this._password;
    map["photoURL"] = this._photoURL;
    return map;
  }
}
