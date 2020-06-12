class Occurrence {
  String _id;
  String _location;
  String _lat;
  String _long;
  String _imageURL;
  String _gravity;
  String _description;

  Occurrence({
    String id,
    String location,
    String lat,
    String long,
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
    map["iuid"] = this._id;
    map["location"] = this._location;
    map["lat"] = this._lat;
    map["long"] = this._long;
    map["imageURL"] = this._imageURL;
    map["gravity"] = this._gravity;
    map["description"] = this._description;
    return map;
  }
}
