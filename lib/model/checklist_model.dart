
import 'dart:convert';

import 'package:flutter_app_location_todo/model/quality_check_image_model.dart';

class CheckList {
  String type1;
  String type2;
  String timing;
  String checkList;
  String boundaryName;
  String guid;
  bool check = false;
  DateTime checkDate;
  List<QuailtyCheckImage> qualityCheckImages=[];
  CheckList({
    this.type1,
    this.type2,
    this.timing,
    this.checkList,
    this.boundaryName,
    this.guid,
    this.check,
    this.checkDate,
    this.qualityCheckImages,
  });

  CheckList copyWith({
    String type1,
    String type2,
    String timing,
    String checkList,
    String boundaryName,
    String guid,
    bool check,
    DateTime checkDate,
  }) {
    return CheckList(
      type1: type1 ?? this.type1,
      type2: type2 ?? this.type2,
      timing: timing ?? this.timing,
      checkList: checkList ?? this.checkList,
      boundaryName: boundaryName ?? this.boundaryName,
      guid: guid ?? this.guid,
      check: check ?? this.check,
      checkDate: checkDate ?? this.checkDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type1': type1,
      'type2': type2,
      'timing': timing,
      'checkList': checkList,
      'boundaryName': boundaryName,
      'guid': guid,
      'check': check,
      'checkDate': checkDate?.millisecondsSinceEpoch,
    };
  }

  factory CheckList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CheckList(
      type1: map['type1'],
      type2: map['type2'],
      timing: map['timing'],
      checkList: map['checkList'],
      guid: map['guid'],
      qualityCheckImages : [],
      // boundaryName: map['boundaryName'],
      check: false,
      // checkDate: DateTime.fromMillisecondsSinceEpoch(map['checkDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckList.fromJson(String source) => CheckList.fromMap(json.decode(source));

  @override
  String toString() {
    return '$timing';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CheckList &&
        o.type1 == type1 &&
        o.type2 == type2 &&
        o.timing == timing &&
        o.checkList == checkList &&
        o.boundaryName == boundaryName &&
        o.guid == guid &&
        o.check == check &&
        o.checkDate == checkDate;
  }

  @override
  int get hashCode {
    return type1.hashCode ^
        type2.hashCode ^
        timing.hashCode ^
        checkList.hashCode ^
        boundaryName.hashCode ^
        guid.hashCode ^
        check.hashCode ^
        checkDate.hashCode;
  }
}