
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

class TodoDetail extends StatefulWidget {
  final TaskData task;

  TodoDetail(this.task);

  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  PhotoViewController _photoViewController;
  TextEditingController _textEditingController = TextEditingController();
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yy.MM.dd.');
  DateFormat formatter2 = DateFormat('HH:mm:ss');

  final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();

  VisionText visionText;
  ByteData bytes;
  String tempPath;
  File file;

  @override
  void initState() {
    super.initState();
    _photoViewController = PhotoViewController();
    ocr().then((value) => print(value.text));
    // ocr().then((value) {
    //   value.blocks.forEach((e) {
    //     e.lines.forEach((t) {
    //       print( t.elements );
    //       print(t.boundingBox.topLeft);
    //       print('safety');
    //     });
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _photoViewController.dispose();
    _textEditingController.dispose();
  }

  Future<VisionText> ocr()async{

    ByteData bytes = await rootBundle.load(Provider.of<Current>(context, listen: false).getPath());
    String tempPath = (await getTemporaryDirectory()).path;
    file = File('$tempPath/${Provider.of<Current>(context, listen: false).getName()}.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);

    visionText = await textRecognizer.processImage(vIa);
    return visionText;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('디테일페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.details),
            onPressed: () {
              print(_photoViewController.position);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // print(visionText.text);
          _photoViewController.position = Offset(200,-100);
        },
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 421 / 297,
            child: ClipRect(
              child: PhotoView.customChild(
                maxScale: 5.0,
                minScale: 1.0,
                controller: _photoViewController,
                backgroundDecoration: BoxDecoration(color: Colors.white),
                child: PositionedTapDetector(
                  onLongPress: (m) {
                    setState(() {
                      widget.task.x = m.relative.dx / _photoViewController.scale;
                      widget.task.y = m.relative.dy / _photoViewController.scale;
                    });
                  },
                  child: Stack(
                    children: [
                      Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                      StreamBuilder<PhotoViewControllerValue>(
                          stream: _photoViewController.outputStateStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return widget.task.x == null
                                  ? Container()
                                  : Positioned(
                                      left: widget.task.x - 20,
                                      top: widget.task.y - 20,
                                      child: Opacity(
                                        opacity: 0.9,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.pin_drop,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    );
                            return Positioned(
                              left: widget.task.x - 20,
                              top: widget.task.y - 20,
                              child: Opacity(
                                opacity: 0.9,
                                child: Transform.scale(
                                  scale: 1 / snapshot.data.scale * 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.pin_drop,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('일정 : '),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              widget.task.start = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2021),
                                  builder: (context, Widget child) {
                                    return Theme(data: ThemeData.dark(), child: child);
                                  });
                            },
                            child: widget.task.start == null ? Text('시작일 선택') : Text('시작일 : ${formatter.format(widget.task.start)}')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              widget.task.end = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2021),
                                  builder: (context, Widget child) {
                                    return Theme(data: ThemeData.dark(), child: child);
                                  });
                            },
                            child: widget.task.end == null ? Text('종료일 선택') : Text('종료일 : ${formatter.format(widget.task.end)}')),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: '메모입력',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.task.memo = _textEditingController.text;
                                // 등록 버튼 클릭시 필드 초기화
                                _textEditingController.text = '';
                              });
                            },
                            child: Text('저장')),
                      )
                    ],
                  ),
                ),
                widget.task.memo == null ? Text('메모를 추가하세요') : Text(widget.task.memo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
