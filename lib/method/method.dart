import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/site_model.dart';
import 'package:flutter_app_location_todo/model/user_model.dart';

Future<List> readSiteMethod({@required String col, @required List list}) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  QuerySnapshot read = await _db.collection(col).get();
  list = read.docs.map((e) => Site.fromSnapshot(e)).toList();
  return list;
}

Future<List> readUser({@required String col, @required List list}) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  QuerySnapshot read = await _db.collection(col).get();
  list = read.docs.map((e) => TWUser.fromSnapshot(e)).toList();
  return list;
}
writeUser({@required TWUser user}){
  FirebaseFirestore _db = FirebaseFirestore.instance;
  _db.collection('userData').add(user.toJson());
}