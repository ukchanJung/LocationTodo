import 'package:cloud_firestore/cloud_firestore.dart';

class Grid {
  num x;
  num y;
  String name;

  Grid(this.name,{
    this.x,
    this.y,
    });

  Grid.fromJson(Map<String, dynamic> json,{DocumentReference reference}) {
    x = json['x'];
    y = json['y'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    map['name'] = name;
    return map;
  }
  Grid.fromSnapshot(DocumentSnapshot snapshot)
  : this.fromJson(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() {
    return 'Grid{X: $x, Y: $y, name: $name}';
  }
}
