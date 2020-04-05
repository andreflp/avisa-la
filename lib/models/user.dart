import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _id;
  String name;
  String email;
  String password;

  User();

  User.fromMap(DocumentSnapshot document) {
    _id = document.documentID;

    this.name = document.data["name"];
    this.email = document.data["email"];
    this.password = document.data["password"];
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = this.name;
    map['email'] = this.email;
    map['password'] = this.password;
    return map;
  }

  String documentId() => _id;
}
