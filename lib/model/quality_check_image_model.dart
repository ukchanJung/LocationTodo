import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class QuailtyCheckImage{
  Image image;
  String title;
  String fileName;
  String location;
  List<Offset> boundarys;
  DateTime createTime;
  String serverPath;
  String localPath;
  Uint8List uint8list;

  QuailtyCheckImage({
    this.image,
    this.title,
    this.location,
    this.boundarys,
    this.createTime,
    this.serverPath,
    this.localPath,
    this.uint8list,
    this.fileName,
  });
}