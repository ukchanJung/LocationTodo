import 'package:cloud_firestore/cloud_firestore.dart';

class Gridtestmodel {
  String name;
  String type;
  String index;
  num startX;
  num startY;
  num endX;
  num endY;

  Gridtestmodel({this.name, this.type, this.index, this.startX, this.startY, this.endX, this.endY});

  Gridtestmodel.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    type = json["type"];
    index = json["index"];
    startX = json["startX"];
    startY = json["startY"];
    endX = json["endX"];
    endY = json["endY"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["type"] = type;
    map["index"] = index;
    map["startX"] = startX;
    map["startY"] = startY;
    map["endX"] = endX;
    map["endY"] = endY;
    return map;
  }

  Gridtestmodel.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);
}
