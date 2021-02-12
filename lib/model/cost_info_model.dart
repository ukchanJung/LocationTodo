import 'package:cloud_firestore/cloud_firestore.dart';

class CostInfo {
  String index1;
  String index2;
  String index3;
  String index4;
  String index5;
  String index6;
  String index7;
  String index4Path;
  String index5Path;
  String index6Path;
  String index7Path;

  CostInfo(
      {this.index1,
      this.index2,
      this.index3,
      this.index4,
      this.index5,
      this.index6,
      this.index7,
      this.index4Path,
      this.index5Path,
      this.index6Path,
      this.index7Path});

  CostInfo.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    index1 = json['index1'];
    index2 = json['index2'];
    index3 = json['index3'];
    index4 = json['index4'];
    index5 = json['index5'];
    index6 = json['index6'];
    index7 = json['index7'];
    index4Path = json['index4Path'];
    index5Path = json['index5Path'];
    index6Path = json['index6Path'];
    index7Path = json['index7Path'];
  }
  CostInfo.fromMap(map) {
    index1 = map['index1'];
    index2 = map['index2'];
    index3 = map['index3'];
    index4 = map['index4'];
    index5 = map['index5'];
    index6 = map['index6'];
    index7 = map['index7'];
    index4Path = map['index4Path'];
    index5Path = map['index5Path'];
    index6Path = map['index6Path'];
    index7Path = map['index7Path'];
  }

  CostInfo.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index1'] = this.index1;
    data['index2'] = this.index2;
    data['index3'] = this.index3;
    data['index4'] = this.index4;
    data['index5'] = this.index5;
    data['index6'] = this.index6;
    data['index7'] = this.index7;
    data['index4Path'] = this.index4Path;
    data['index5Path'] = this.index5Path;
    data['index6Path'] = this.index6Path;
    data['index7Path'] = this.index7Path;
    return data;
  }
}
