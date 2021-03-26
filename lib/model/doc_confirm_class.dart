import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/checklist_model.dart';
import 'package:flutter_app_location_todo/model/quality_check_image_model.dart';
import 'package:intl/intl.dart';

class ConstructConfirm {
  String title;
  String uid;
  String docId;
  DateTime applyDate;
  DateTime confirmDate;
  String recipient ;
  String siteName;
  List<Offset> boundarys = [];
  String quailtyManager1;
  String quailtyManager2;
  String quailtyManager3;
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
  List<CheckList> checkListsId = [];
  String checkMemo ;
  String confirmMemo ;

  ConstructConfirm({
    this.title,
    this.uid,
    this.docId,
    this.applyDate,
    this.confirmDate,
    this.recipient,
    this.siteName,
    this.boundarys,
    this.quailtyManager1,
    this.quailtyManager2,
    this.quailtyManager3,
    this.quailtyManagerCheck1,
    this.quailtyManagerCheck2,
    this.quailtyManagerCheck3,
    this.cheif1,
    this.cheif2,
    this.cheif3,
    this.cheifCheck1,
    this.cheifCheck2,
    this.cheifCheck3,
    this.director,
    this.checkD1,
    this.checkD2,
    this.checkD3,
    this.directorCheck1,
    this.checkListsId,
    this.checkMemo,
    this.confirmMemo,
  });

  ConstructConfirm.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    title = json['title'];
    uid = json['uid'];
    docId = json['docId'];
    applyDate = json['applyDate'].toDate();
    confirmDate = json['confirmDate'].toDate();
    recipient = json['recipient'];
    siteName = json['siteName'];
    Iterable jsonBoundarys = json['boundarys'];
    if(jsonBoundarys != null){
    boundarys = jsonBoundarys.map((e) {
      Offset _offset =Offset(e['dx'],e['dy']);
      return _offset;
    }).toList();
    }

    quailtyManager1 = json['quailtyManager1'];
    quailtyManager3 = json['quailtyManager3'];
    quailtyManagerCheck1 = json['quailtyManagerCheck1'];
    quailtyManagerCheck2 = json['quailtyManagerCheck2'];
    quailtyManagerCheck3 = json['quailtyManagerCheck3'];
    cheif1 = json['cheif1'];
    cheif2 = json['cheif2'];
    cheif3 = json['cheif3'];
    cheifCheck1 = json['cheifCheck1'];
    cheifCheck2 = json['cheifCheck2'];
    cheifCheck3 = json['cheifCheck3'];
    director = json['director'];
    if(json['checkD1']!=null){
    checkD1 = json['checkD1'].toDate();
    }else if (json['checkD1']!=null&& json['checkD2']!=null){
    checkD1 = json['checkD1'].toDate();
    checkD2 = json['checkD2'].toDate();
    }else if (json['checkD1']!=null&&json['checkD2']!=null&&json['checkD3']!=null){
    checkD1 = json['checkD1'].toDate();
    checkD2 = json['checkD2'].toDate();
    checkD3 = json['checkD3'].toDate();
    }
    directorCheck1 = json['directorCheck1'];
    // checkListsId = json['checkLists'].cast<CheckList>();
    Iterable jsonCheckListID = json['checkListId'];
    if(jsonCheckListID != null){
      checkListsId = jsonCheckListID.map((e) {
        Iterable jsonQualityCheckImages = e['qualityCheckImages'];
        if(jsonQualityCheckImages==null){
          return CheckList(
            type1: e['type1'],
            type2: e['type2'],
            timing: e['timing'],
            checkList: e['checkList'],
            boundaryName: e['boundaryName'],
            guid: e['guid'],
            check: e['check'],
            checkDate: e['checkDate'].toDate(),
          );
        }else if (jsonQualityCheckImages !=null){
          return CheckList(
            type1: e['type1'],
            type2: e['type2'],
            timing: e['timing'],
            checkList: e['checkList'],
            boundaryName: e['boundaryName'],
            guid: e['guid'],
            check: e['check'],
            // checkDate: e['checkDate'].toDate(),
              qualityCheckImages: jsonQualityCheckImages.map((i) {
                return QuailtyCheckImage(
                  image: Image.network(i['path']),
                  createTime: i['createTime'].toDate(),
                  title: i['title'],
                );
              }).toList());
        }
      }).toList();
    }
    checkMemo = json['checkMemo'];
    confirmMemo = json['confirmMemo'];
  }
  ConstructConfirm.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['docId'] = this.docId;
    data['applyDate'] = this.applyDate;
    data['confirmDate'] = this.confirmDate;
    data['recipient'] = this.recipient;
    data['siteName'] = this.siteName;
    data['boundarys'] = this.boundarys;
    data['quailtyManager1'] = this.quailtyManager1;
    data['quailtyManager2'] = this.quailtyManager2;
    data['quailtyManager3'] = this.quailtyManager3;
    data['quailtyManagerCheck1'] = this.quailtyManagerCheck1;
    data['quailtyManagerCheck2'] = this.quailtyManagerCheck2;
    data['quailtyManagerCheck3'] = this.quailtyManagerCheck3;
    data['cheif1'] = this.cheif1;
    data['cheif2'] = this.cheif2;
    data['cheif3'] = this.cheif3;
    data['cheifCheck1'] = this.cheifCheck1;
    data['cheifCheck2'] = this.cheifCheck2;
    data['cheifCheck3'] = this.cheifCheck3;
    data['director'] = this.director;
    data['checkD1'] = this.checkD1;
    data['checkD2'] = this.checkD2;
    data['checkD3'] = this.checkD3;
    data['directorCheck1'] = this.directorCheck1;
    data['checkMemo'] = this.checkMemo;
    data['confirmMemo'] = this.confirmMemo;

    data['checkListId'] = this.checkListsId.map((e) {
      final Map<String, dynamic> _map = new Map<String, dynamic>();
      _map['type1'] = e.type1;
      _map['type2'] = e.type2;
      _map['timing'] = e.timing;
      _map['checkList'] = e.checkList;
      _map['boundaryName'] = e.boundaryName;
      _map['guid'] = e.guid;
      _map['check'] = e.check;
      _map['checkDate'] = e.checkDate;
      _map['qualityCheckImages'] = e.qualityCheckImages.map((e) {
        final Map<String, dynamic> _q = new Map<String, dynamic>();
        _q['title'] = e.title;
        _q['location'] = e.location;
        _q['path'] = e.serverPath;
        _q['createTime'] = e.createTime;
        return _q;
      }).toList();
      return _map;
    }).toList();
    return data;
  }

  @override
  String toString() {
    return '${this.siteName} $checkListsId 검측 요청서';
  }
}
