import 'package:cloud_firestore/cloud_firestore.dart';

class Occurrence {
  String _id;
  String _userId;
  String _location;
  double _lat;
  double _long;
  String _imageURL;
  String _severity;
  String _description;

  Occurrence({
    String id,
    String userId,
    String location,
    double lat,
    double long,
    String imageURL,
    String severity,
    String description,
  }) {
    _id = id;
    _userId = userId;
    _location = location;
    _lat = lat;
    _long = long;
    _imageURL = imageURL;
    _severity = severity;
    _description = description;
  }

  String get id => _id;
  String get userId => _userId;
  String get location => _location;
  double get lat => _lat;
  double get long => _long;
  String get imageURL => _imageURL;
  String get severity => _severity;
  String get description => _description;

  set id(String id) => _id = id;
  set userId(String userId) => _userId = userId;
  set location(String location) => _location = location;
  set lat(double lat) => _lat = lat;
  set long(double long) => _long = long;
  set imageURL(String imageURL) => _imageURL = imageURL;
  set severity(String severity) => _severity = severity;
  set description(String description) => _description = description;

  factory Occurrence.fromJson(DocumentSnapshot document) => Occurrence(
      id: document.documentID,
      userId: document.data["userId"],
      location: document.data["location"],
      lat: document.data["lat"],
      long: document.data["long"],
      imageURL: document.data["imageURL"],
      severity: document.data["severity"],
      description: document.data["description"]);

  toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = this._userId;
    map["location"] = this._location;
    map["lat"] = this._lat;
    map["long"] = this._long;
    map["imageURL"] = this._imageURL;
    map["severity"] = this._severity;
    map["description"] = this._description;
    return map;
  }
}
