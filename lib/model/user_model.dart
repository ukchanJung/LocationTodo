import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TWUser {
  String uid = 'aaa';
  String name = 'aaa';
  String company='aaa';
  String rank='aaa';
  String email;
  String phonenumber;
  int level;
  DateTime start;
  DateTime end;


  @override
  String toString() {
    return 'TWUser{uid: $uid, name: $name, company: $company, rank: $rank, email: $email, phonenumber: $phonenumber, level: $level, start: $start, end: $end}';
  }

  TWUser({
    @required this.uid,
    @required this.name,
    @required this.company,
    @required this.rank,
    @required this.email,
    @required this.phonenumber,
    @required this.level,
  });
  TWUser.SignUp({ @required String value }){
    uid = value;
  }
  TWUser.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    uid = json['userList'];
    name = json["name"];
    company = json["company"];
    rank = json["rank"];
    email = json["email"];
    phonenumber = json["phonenumber"];
    level = json["level"].toInt();
    if(json['start']!=null){
    start = json['start'].toDate();
    }
    if(json['end']!=null){
    start = json['end'].toDate();
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userList"] = uid;
    map["name"] = name;
    map["company"] = company;
    map["rank"] = rank;
    map["email"] = email;
    map["phonenumber"] = phonenumber;
    map["level"] = level;
    map["start"] = start;
    map["end"] = end;
    return map;
  }

  TWUser.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);
}
