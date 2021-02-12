import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/data/standard_detail_list.dart';
import 'package:flutter_app_location_todo/model/standard_detail_class.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show Codec, FrameInfo, Image;


class OcrSettingPage extends StatefulWidget {
  @override
  _OcrSettingPageState createState() => _OcrSettingPageState();
}

class _OcrSettingPageState extends State<OcrSettingPage> {
  int index =0;
  List<QueryDocumentSnapshot>data;
  Iterable temp;
  String temp2;
  ui.Image decodeImage;
  double iS;
  GlobalKey _keyA = GlobalKey();
  String selectT ='';

  @override
  void initState() {
    super.initState();
    void read()async{
      QuerySnapshot read = await FirebaseFirestore.instance.collection('standarddetail').get();
      data =read.docs.map((e) => e).toList();
    }
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$selectT [$index/${data.length}]'),),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Text('+'),
            heroTag: null,
            onPressed: (){
              setState(() async{
                index ++;
                String tempRoot = 'asset/standarddetail/${standarddetail[index]['path']}';
                ByteData bytes = await rootBundle.load(tempRoot);
                String tempPath = (await getTemporaryDirectory()).path;
                String tempName = '$tempPath/${standarddetail[index]['path']}';
                File file = File(tempName);
                await file
                    .writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                decodeImage = await decodeImageFromList(file.readAsBytesSync());
                iS = decodeImage.width / _keyA.currentContext.size.width;
                setState(() {});
                print(data[index].data()['dataList']);
                temp =data[index].data()['dataList'];
              });
            },
          ),
          SizedBox(width: 24,),
          FloatingActionButton(
            child: Text('-'),
            heroTag: null,
            onPressed: (){
              setState(() async{
                index --;
                String tempRoot = 'asset/standarddetail/${standarddetail[index]['path']}';
                ByteData bytes = await rootBundle.load(tempRoot);
                String tempPath = (await getTemporaryDirectory()).path;
                String tempName = '$tempPath/${standarddetail[index]['path']}';
                File file = File(tempName);
                await file
                    .writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                decodeImage = await decodeImageFromList(file.readAsBytesSync());
                iS = decodeImage.width / _keyA.currentContext.size.width;
                setState(() {});
                print(data[index].data()['dataList']);
                temp =data[index].data()['dataList'];
                temp2 =data[index].data()['fulltext'];
              });
            },
          ),
          SizedBox(width: 24,),
          FloatingActionButton(onPressed: (){
            setState(() {
              StandardDetail _sD =StandardDetail();
              _sD
                ..name = selectT
                ..type =standarddetail[index]['type']
                ..index1 =standarddetail[index]['index1']
                ..index2 =standarddetail[index]['index2']
                ..index3 =standarddetail[index]['index3']
                ..fulltext = temp2
                ..path = standarddetail[index]['path'];
              print(_sD);
              FirebaseFirestore.instance.collection('detailData').doc(_sD.path).set(_sD.toJson());
            });
          })
        ],
      ),
      body: Stack(
        children: [
          Image.asset('asset/standarddetail/${standarddetail[index]['path']}',key: _keyA,width: 400,fit: BoxFit.fitWidth,),
          temp!=null
              ?Stack(
            children: temp
                .map((e) => Positioned.fromRect(
                rect: Rect.fromLTRB(e['rect']['left']/iS, e['rect']['top']/iS, e['rect']['right']/iS, e['rect']['bottom']/iS),
                child: InkWell(
                  onTap: (){
                    setState(() {
                     selectT = e['text'];
                    });
                  },
                  child: Container(
                    color: Color.fromRGBO(255, 0, 0, 0.5),
                  ),
                )))
                .toList(),
          )
              :Container(),
        ],
      ),
    );
  }
}
