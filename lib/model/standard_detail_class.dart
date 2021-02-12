import 'package:cloud_firestore/cloud_firestore.dart';

class StandardDetail {
  String path;
  String type;
  int index1;
  int index2;
  String category="";
  String subCategory="분류";

  StandardDetail({this.path, this.type, this.index1, this.index2, this.index3, this.name, this.fulltext});

  int index3;
  String name;
  String fulltext;

  StandardDetail.fromJson(Map<String, dynamic> json, {DocumentReference reference}){
    path = json['path'];
    type = json['type'];
    index1 = json['index1'];
    index2 = json['index2'];
    index3 = json['index3'];
    name = json['name'];
    fulltext = json['fulltext'];
  }

  StandardDetail.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['type'] = this.type;
    data['index1'] = this.index1;
    data['index2'] = this.index2;
    data['index3'] = this.index3;
    data['name'] = this.name;
    data['fulltext'] = this.fulltext;
    return data;
  }

  @override
  String toString() {
    return '${path.replaceAll(".png", "")}-$name';
  }
}
