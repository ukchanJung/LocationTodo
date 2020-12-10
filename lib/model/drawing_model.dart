import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Drawing {
  String localPath;
  String drawingNum;
  String title;
  String listCategory;
  String listSubNum;
  String scale;
  int orient;
  bool ocr;
  bool checked = false;
  List<String> infoCategory;
  List<double> pointX;
  List<double> pointY;
  List<String> pointName;
  num witdh;
  num height;
  num floor;

  ///서치기능 활용
  DateTime createdAt;
  String avatar;

  double originX;
  double originY;

  List<Map> ocrData;

  Drawing({
    this.localPath,
    this.drawingNum,
    this.title,
    this.listCategory,
    this.listSubNum,
    this.scale,
    this.orient,
    this.ocr,
    this.checked,
    this.infoCategory,
    this.pointX,
    this.pointY,
    this.pointName,
    this.originX,
    this.originY,
    this.witdh,
    this.height,
    this.createdAt,
    this.avatar,
  });

  factory Drawing.fromJsonSearch(Map<String, dynamic> json, {DocumentReference reference}) {
    if (json == null) return null;
    return Drawing(
      localPath: json['localPath'],
      drawingNum: json['drawingNum'],
      title: json['title'],
      listCategory: json['listCategory'],
      listSubNum: json['listSubNum'],
      scale: json['scale'],
      orient: json['Orient'],
      ocr: json['ocr'],
      infoCategory: json['infoCategory'].cast<String>(),
      pointX: json['pointX'].cast<double>(),
      pointY: json['pointY'].cast<double>(),
      pointName: json['pointName'].cast<String>(),
    );
  }

  static List<Drawing> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Drawing.fromJsonSearch(item)).toList();
  }

  String userAsString() {
    return '#${this.drawingNum} ${this.title}';
  }

  bool userFilterByCreationDate(String filter) {
    return this?.createdAt?.toString()?.contains(filter);
  }

  bool isEqual(Drawing model) {
    return this?.title == model?.title;
  }

  Drawing.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    localPath = json['localPath'];
    drawingNum = json['drawingNum'];
    title = json['title'];
    listCategory = json['listCategory'];
    listSubNum = json['listSubNum'];
    scale = json['scale'];
    orient = json['Orient'];
    ocr = json['ocr'];
    infoCategory = json['infoCategory'].cast<String>();
    pointX = json['pointX'].cast<double>();
    pointY = json['pointY'].cast<double>();
    pointName = json['pointName'].cast<String>();
    originX = json["originX"];
    originY = json["originY"];
    floor = json["floor"];
    witdh = json["width"];
    height = json["height"];
    // Iterable jsonOcrRect = json["ocrData"];
    // ocrData = jsonOcrRect.map((e) =>
    // {
    //   'text': e['text'],
    //   'rect': {
    //     'left' :e['L'],
    //     'top' :e['T'],
    //     'right' :e['R'],
    //     'bottom' :e['B'],
    //   },
    // }).toList();
  }

  Drawing.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['localPath'] = this.localPath;
    data['drawingNum'] = this.drawingNum;
    data['title'] = this.title;
    data['listCategory'] = this.listCategory;
    data['listSubNum'] = this.listSubNum;
    data['scale'] = this.scale;
    data['Orient'] = this.orient;
    data['ocr'] = this.ocr;
    data['infoCategory'] = this.infoCategory;
    data['pointX'] = this.pointX;
    data['pointY'] = this.pointY;
    data["ocrData"] = this.ocrData;
    data["originX"] = this.originX;
    data["originY"] = this.originY;
    data["floor"] = this.floor;
    data["width"] = this.witdh;
    data["height"] = this.height;
    return data;
  }

  @override
  String toString() => '[${drawingNum}] $title';
}

class Ocr {
  String name;
  Rect rect;

  Ocr({this.name, this.rect});

}
