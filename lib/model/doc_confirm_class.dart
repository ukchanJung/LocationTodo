import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConstructConfirm {
  String title;
  String uid;
  int docId;
  DateTime applyDate;
  DateTime confirmDate;
  List<String> recipient = ['선택하세요', '광명/시흥 본부', '인천지역본부', '충청지역본부'];
  String siteName;
  List<Offset> boundarys = [];
  String quailtyManager3;
  String quailtyManager2;
  String quailtyManager1;
  bool quailtyManagerCheck1 = false;
  bool quailtyManagerCheck2 = false;
  bool quailtyManagerCheck3 = false;
  String cheif1;
  String cheif2;

  String cheif3;
  bool cheifCheck1 = false;
  bool cheifCheck2 = false;
  bool cheifCheck3 = false;
  String director;
  DateTime checkD1;
  DateTime checkD2;
  DateTime checkD3;
  bool directorCheck1 = false;
  List<CheckList> checkLists = [];
  String checkMemo;
  String confirmMemo;
}

class CheckList {
  String type1;
  String type2;
  String timing;
  String checkList;
  String boundaryName;
  bool check = false;
  DateTime checkDate;
  CheckList({
    this.type1,
    this.type2,
    this.timing,
    this.checkList,
    this.boundaryName,
    this.check,
    this.checkDate,
  });

  CheckList copyWith({
    String type1,
    String type2,
    String timing,
    String checkList,
    String boundaryName,
    bool check,
    DateTime checkDate,
  }) {
    return CheckList(
      type1: type1 ?? this.type1,
      type2: type2 ?? this.type2,
      timing: timing ?? this.timing,
      checkList: checkList ?? this.checkList,
      boundaryName: boundaryName ?? this.boundaryName,
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
      // boundaryName: map['boundaryName'],
      check: false,
      // checkDate: DateTime.fromMillisecondsSinceEpoch(map['checkDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckList.fromJson(String source) => CheckList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CheckList(type1: $type1, type2: $type2, timing: $timing, checkList: $checkList, boundaryName: $boundaryName, check: $check, checkDate: $checkDate)';
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
        check.hashCode ^
        checkDate.hashCode;
  }
}
