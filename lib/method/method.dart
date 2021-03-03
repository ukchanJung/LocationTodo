import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/site_model.dart';

Future<List> readSiteMethod({ @required String col,@required List list }) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  QuerySnapshot read = await _db.collection(col).get();
  list = read.docs.map((e) => Site.fromSnapshot(e)).toList();
  return list;
}
