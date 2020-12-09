import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import 'boundary_detail_page.dart';

class TimView extends StatefulWidget {
  @override
  _TimViewState createState() => _TimViewState();
}

class _TimViewState extends State<TimView> {
  VisionText visionText;
  GlobalKey _keyA = GlobalKey();
  PhotoViewController _photoViewController;
  double iS;
  ui.Image decodeImage;
  List<Drawing> drawings;
  Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _photoViewController = PhotoViewController();
    void readDrawings() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('drawing').get();
      drawings = read.docs.map((e) => Drawing.fromSnapshot(e)).toList();
    }

    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _photoViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
          child: drawings == null
              ? Container()
              : Expanded(
            child: ListView(
              children: drawings
                  .map((e) => ListTile(
                title: Text(e.title),
                onTap: () {
                  setState(() async {
                    context.read<Current>().changePath(e);
                    String tempRoot = 'asset/photos/${context.read<Current>().getDrawing().localPath}';
                    ByteData bytes = await rootBundle.load(tempRoot);
                    // ByteData bytes = await rootBundle.load(context.watch<Current>().getPath());
                    String tempPath = (await getTemporaryDirectory()).path;
                    String tempName = '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
                    File file = File(tempName);
                    // File file = File('$tempPath/${context.watch<Current>().getName()}.png');
                    await file
                        .writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

                    FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
                    final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
                    print(textRecognizer);

                    visionText = await textRecognizer.processImage(vIa);
                    print(visionText);
                    decodeImage = await decodeImageFromList(file.readAsBytesSync());

                    iS = decodeImage.width / _keyA.currentContext.size.width;
                    setState(() {});
                  });
                },
              ))
                  .toList(),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String tempRoot = 'asset/photos/${context.read<Current>().getDrawing().localPath}';
          ByteData bytes = await rootBundle.load(tempRoot);
          // ByteData bytes = await rootBundle.load(context.watch<Current>().getPath());
          String tempPath = (await getTemporaryDirectory()).path;
          String tempName = '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
          File file = File(tempName);
          // File file = File('$tempPath/${context.watch<Current>().getName()}.png');
          await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

          FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
          final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
          print(textRecognizer);

          visionText = await textRecognizer.processImage(vIa);
          print(visionText);
          decodeImage = await decodeImageFromList(file.readAsBytesSync());

          iS = decodeImage.width / _keyA.currentContext.size.width;
          print(_photoViewController.scale);
          setState(() {});
        },
      ),
      body: Column(
        children: [
          Container(height: 50,),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownSearch<Drawing>(
              items: drawings,
              maxHeight: 600,
              onFind: (String filter) => getData(filter),
              label: "도면을 선택해주세요",
              onChanged: context.watch<Current>().changePath,
              showSearchBox: true,
            ),
          ),
          AspectRatio(
            aspectRatio: 421/297,
            child: ClipRect(
              child: Container(
                child: PhotoView.customChild(
                  key: _keyA,
                  controller: _photoViewController,
                  minScale: 1.0,
                  maxScale: 10.0,
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  child: Stack(
                    children: [
                      Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                      visionText == null
                          ? Container()
                          : Stack(
                        children: visionText.blocks
                            .map(
                              (e) => Positioned.fromRect(
                            rect:
                            Rect.fromPoints(e.boundingBox.topLeft / iS, e.boundingBox.bottomRight / iS),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(e.text),
                                      content: Column(
                                        children: drawings
                                            .where((v) => v.drawingNum == e.text)
                                            .map(
                                              (e) => ListTile(
                                            subtitle: Text(e.drawingNum),
                                            title: Text(e.title),
                                            onTap: () {
                                              setState(() async {
                                                context.read<Current>().changePath(e);
                                                String tempRoot =
                                                    'asset/photos/${context.read<Current>().getDrawing().localPath}';
                                                ByteData bytes = await rootBundle.load(tempRoot);
                                                // ByteData bytes = await rootBundle.load(context.watch<Current>().getPath());
                                                String tempPath = (await getTemporaryDirectory()).path;
                                                String tempName =
                                                    '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
                                                File file = File(tempName);
                                                // File file = File('$tempPath/${context.watch<Current>().getName()}.png');
                                                await file.writeAsBytes(bytes.buffer.asUint8List(
                                                    bytes.offsetInBytes, bytes.lengthInBytes));

                                                FirebaseVisionImage vIa =
                                                FirebaseVisionImage.fromFile(file);
                                                final TextRecognizer textRecognizer =
                                                FirebaseVision.instance.cloudTextRecognizer();
                                                print(textRecognizer);

                                                visionText = await textRecognizer.processImage(vIa);
                                                print(visionText);
                                                decodeImage =
                                                await decodeImageFromList(file.readAsBytesSync());

                                                iS =
                                                    decodeImage.width / _keyA.currentContext.size.width;
                                                setState(() {});
                                              });
                                            },
                                          ),
                                        )
                                            .toList(),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration:
                                BoxDecoration(border: Border.all(color: Colors.red, width: 0.1)),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<List<Drawing>> getData(filter) async {
  var response = await Dio().get(
    "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
    queryParameters: {"filter": filter},
  );

  var models = Drawing.fromJsonList(response.data);
  return models;
}

