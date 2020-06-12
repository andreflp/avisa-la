class Occurrence {
  String _id;
  String _location;
  double _lat;
  double _long;
  String _imageURL;
  String _gravity;
  String _description;

  Occurrence({
    String id,
    String location,
    double lat,
    double long,
    String imageURL,
    String gravity,
    String description,
  }) {
    _id = id;
    _location = location;
    _lat = lat;
    _long = long;
    _imageURL = imageURL;
    _gravity = gravity;
    _description = description;
  }

  String get id => _id;
  String get location => _location;
  double get lat => _lat;
  double get long => _long;
  String get imageURL => _imageURL;
  String get gravity => _gravity;
  String get description => _description;

  set location(String location) => _location = location;
  set lat(double lat) => _lat = lat;
  set long(double long) => _long = long;
  set imageURL(String imageURL) => _imageURL = imageURL;
  set gravity(String gravity) => _gravity = gravity;
  set description(String description) => _description = description;

  factory Occurrence.fromJson(Map<String, dynamic> json) => Occurrence(
      id: json["iuid"],
      location: json["location"],
      lat: json["lat"],
      long: json["long"],
      imageURL: json["imageURL"],
      gravity: json["gravity"],
      description: json["description"]);

  toMap() {
    var map = new Map<String, dynamic>();
    map["location"] = this._location;
    map["lat"] = this._lat;
    map["long"] = this._long;
    map["imageURL"] = this._imageURL;
    map["gravity"] = this._gravity;
    map["description"] = this._description;
    return map;
  }
}
