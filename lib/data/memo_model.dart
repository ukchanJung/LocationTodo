import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Memo{
  String title;
  String subTitle;
  DateTime writeTime;
  String imagePath;
  bool check = false;
  int category = 0;
  Offset origin = Offset.zero;


  Memo({this.title, this.subTitle, this.writeTime, this.imagePath, this.check, this.category, this.origin});

  Memo.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    title = json["title"];
    subTitle = json['subTitle'];
    writeTime = json['writeTime'].toDate();
    imagePath = json['imagePath'];
    check = json['check'];
    category = json['category'];
    origin = Offset(json['dx'].toDouble(),json['dy'].toDouble());
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["subTitle"] = subTitle;
    map["writeTime"] = writeTime;
    map["imagePath"] = imagePath;
    map["check"] = check;
    map["category"] = category;
    map["dx"] = origin.dx;
    map["dy"] = origin.dy;
    return map;
  }

  Memo.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);

}