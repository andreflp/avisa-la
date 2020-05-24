class Place {
  String description;
  String placeId;
  String mainText;
  String secondaryText;

  Place({this.description, this.placeId, this.mainText, this.secondaryText});

  factory Place.fromJson(Map<String, dynamic> json) => Place(
      description: json["description"],
      placeId: json["place_id"],
      mainText: json['structured_formatting']['main_text'],
      secondaryText: json['structured_formatting']['secondary_text']);

  toMap() {
    var map = new Map<String, dynamic>();
    map['description'] = this.description;
    map['place_id'] = this.placeId;
    return map;
  }
}
