import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/room_model.dart';

class Drawing {
  String localPath;
  String drawingNum;
  String title;
  String listCategory;
  String listSubNum;
  String scale;
  double orient;
  bool ocr;
  bool checked = false;
  List<String> infoCategory;
  List<double> pointX;
  List<double> pointY;
  List<String> pointName;
  num witdh;
  num height;
  num floor;
  String doc = '미분류';
  String con = '미분류';
  bool axis = false;

  ///서치기능 활용
  DateTime createdAt;
  String avatar;

  double originX;
  double originY;

  List<Map> ocrData;

  List<Room> rooms;
  List<Map> roomMap = [];
  List<Map> callOutMap = [];
  List<Map> sectionMap = [];
  List<Map> detailInfoMap = [];
  Offset docOrigin = Offset.zero;
  double docOriginX = 0;
  double docOriginY = 0;
  List<String> category = [];

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
    this.docOrigin,
    this.docOriginX,
    this.docOriginY,
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
      // orient: json['Orient'],
      // ocr: json['ocr'],
      // infoCategory: json['infoCategory'].cast<String>(),
      // pointX: json['pointX'].cast<double>(),
      // pointY: json['pointY'].cast<double>(),
      // pointName: json['pointName'].cast<String>(),
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
    print(json['drawingNum']);
    localPath = json['localPath'];
    drawingNum = json['drawingNum'];
    title = json['title'];
    listCategory = json['listCategory'];
    listSubNum = json['listSubNum'];
    scale = json['scale'];
    if (json['Orient'] != null) {
      orient = json['Orient'].toDouble();
    }
    ocr = json['ocr'];
    infoCategory = json['infoCategory'].cast<String>();
    // pointX = json['pointX'].cast<double>();
    // pointY = json['pointY'].cast<double>();
    // pointName = json['pointName'].cast<String>();
    originX = json["originX"].toDouble();
    originY = json["originY"].toDouble();
    floor = json["floor"];
    witdh = json["width"];
    height = json["height"];
    con = json["con"];
    doc = json["doc"];
    axis = json["axis"];
    // if (json["docOrigin"] != null) {
    //   docOrigin = Offset(json["docOrigin"]['dx'], json["docOrigin"]['dy']);
    // }
    if (json["docOriginX"] != null) {
      docOriginX = json["docOriginX"];
    }
    if (json["docOriginY"] != null) {
      docOriginY = json["docOriginY"];
    }

    ///Room데이터 Read
    Iterable jsonRooms = json['roomMap'];
    if (jsonRooms != null) {
      roomMap = jsonRooms
          .map((e) => {
                'name': e['name'],
                'id': e['id'],
                'left': e['left'],
                'top': e['top'],
                'right': e['right'],
                'bottom': e['bottom'],
                'x': e['x'],
                'y': e['y'],
                'z': e['z'],
                'sealL': e['sealL'],
                'bLeft': e['bLeft'],
                'bTop': e['bTop'],
                'bRight': e['bRight'],
                'bBottom': e['bBottom'],
              })
          .toList();
    }
    Iterable jsonCallOut = json['callOutMap'];
    if (jsonCallOut != null) {
      callOutMap = jsonCallOut
          .map((f) => {
                'name': f['name'],
                'id': f['id'],
                'category': f['category'],
                'left': f['left'],
                'top': f['top'],
                'right': f['right'],
                'bottom': f['bottom'],
                'x': f['x'],
                'y': f['y'],
                'z': f['z'],
                'bLeft': f['bLeft'],
                'bTop': f['bTop'],
                'bRight': f['bRight'],
                'bBottom': f['bBottom'],
              })
          .toList();
    }
    Iterable jsonSection = json['sectionMap'];
    if (jsonSection != null) {
      sectionMap = jsonSection
          .map((f) => {
                'name': f['name'],
                'id': f['id'],
                'category': f['category'],
                'left': f['left'],
                'top': f['top'],
                'right': f['right'],
                'bottom': f['bottom'],
                'x': f['x'],
                'y': f['y'],
                'z': f['z'],
                'bLeft': f['bLeft'],
                'bTop': f['bTop'],
                'bRight': f['bRight'],
                'bBottom': f['bBottom'],
              })
          .toList();
    }
    Iterable jsonDetailInfo = json['detailInfoMap'];
    if (jsonDetailInfo != null) {
      detailInfoMap = jsonDetailInfo
          .map((e) => {
                'name': e['name'],
                'category': e['category'],
                'left': e['left'],
                'top': e['top'],
                'right': e['right'],
                'bottom': e['bottom'],
                'x': e['x'],
                'y': e['y'],
                'z': e['z'],
              })
          .toList();
    }
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
    data["con"] = this.con;
    data["doc"] = this.doc;
    data["axis"] = this.axis;
    data["docOrigin"] = {
      "dx": this.docOrigin.dx,
      "dy": this.docOrigin.dy,
    };
    data["docOriginX"] = this.docOriginX;
    data["docOriginY"] = this.docOriginY;
    // List<Map>roomsMap = this.roomMap.map((e) =>
    // {
    //   'name': e.name,
    //   'id': e.id,
    //   'rect': {
    //     'left': e.left,
    //     'top': e.top,
    //     'right': e.right,
    //     'bottom': e.bottom,
    //   },
    //   'x' : e.x,
    //   'y' : e.y,
    //   'z' : e.z,
    //   'sealL' : e.sealL
    // }
    // ).toList();
    // List<Map> roomsMap = this
    //     .rooms
    //     .map((e) => {
    //           'name': e.name,
    //           'id': e.id,
    //           'rect': {
    //             'left': e.left,
    //             'top': e.top,
    //             'right': e.right,
    //             'bottom': e.bottom,
    //           },
    //           'x': e.x,
    //           'y': e.y,
    //           'z': e.z,
    //           'sealL': e.sealL
    //         })
    //     .toList();
    data["roomMap"] = this.roomMap;
    data["callOutMap"] = this.callOutMap;
    data["sectionMap"] = this.sectionMap;
    data["detailInfoMap"] = this.detailInfoMap;
    print(sectionMap);
    return data;
  }

  @override
  String toString() => '[$drawingNum] $title';
}

class Ocr {
  String name;
  Rect rect;

  Ocr({this.name, this.rect});
}
