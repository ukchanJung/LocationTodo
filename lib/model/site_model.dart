import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';

class Site {
  String name;
  DateTime start;
  DateTime end;
  List<String> uIDList;
  QueryDocumentSnapshot data;
  List<Drawing> drawings;

  Site(this.name, this.start, this.end, this.uIDList, this.drawings);

  Site.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    start = json['start'].toDate();
    end = json['end'].toDate();
    // FirebaseFirestore _db = FirebaseFirestore.instance;
    // QuerySnapshot read = await _db.collection('').get();
    // list = read.docs.map((e) => Site.fromSnapshot(e)).toList();
    // if (json['drawings'] != null) {
    //   drawings = json['drawings'];
    // }
    // if (json['userList'] != null) {
    //   uIDList = json['userList'].cast<String>();
    // }
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
