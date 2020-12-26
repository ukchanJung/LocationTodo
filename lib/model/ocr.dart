import 'package:cloud_firestore/cloud_firestore.dart';

class OcrData {
  List dataList;
  String drawingNum;

  OcrData(this.dataList, this.drawingNum);

  OcrData.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    dataList = json["dataList"];
    drawingNum = json["drawingNum"];
    // rect = json["rect"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["dataList"] = dataList;
    map["drawingNum"] = drawingNum;
    // map["rect"] = rect;
    return map;
  }

  OcrData.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);
}
