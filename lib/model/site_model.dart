import 'package:cloud_firestore/cloud_firestore.dart';

class Site{
  String name;
  DateTime start;
  DateTime end;
  List<String> uIDList;

  Site(this.name, this.start, this.end, this.uIDList);

  Site.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    start = json['start'].toDate();
    end = json['end'].toDate();
    // uIDList = json['userList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["start"] = start;
    map["end"] = end;
    map["userList"] = uIDList;
    return map;
  }

  Site.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);

}