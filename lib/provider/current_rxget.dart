import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:get/get.dart';

class CurrentRx{
  RxString _path = 'S01-001.png'.obs;
  RxString _name = 'S01-001.png'.obs;
  RxList<Drawing> pattern =[].obs;
  RxList<Drawing> favorite =[].obs;
  Rx<Drawing> _drawing = Drawing(
    drawingNum: 'A31-003',
    title: '1층 평면도',
    scale: '500',
    localPath: 'A31-003.png',
    originX: 0.7373979439768359,
    originY: 0.23113260932198965,
  ).obs;
  Rx<Drawing> _layerD = Drawing(
    drawingNum: 'A31-003',
    title: '1층 평면도',
    scale: '500',
    localPath: 'A31-003.png',
    originX: 0.7373979439768359,
    originY: 0.23113260932198965,
  ).obs;
  Rx<Offset> origin= Offset.zero.obs;

  String getPath() => _path.value;
  String getName() => _name.value;
  String getcordi() => '${_drawing.toString()}${_drawing.value.originX}, ${_drawing.value.originY}, ${_drawing.value.scale}';
  Drawing getDrawing() => _drawing.value;
  Drawing getLayer() => _layerD.value;
  double getcordiX() => double.parse(_drawing.value.scale) * _drawing.value.witdh;
  double getcordiY() => double.parse(_drawing.value.scale) * _drawing.value.height;
  Offset getOffset() => Offset(_drawing.value.witdh.toDouble(), _drawing.value.height.toDouble());
  Offset getcordiOffset(witdh, heigh) => Offset(witdh * _drawing.value.originX, heigh * _drawing.value.originY);
  Point getcordiPoint(witdh, heigh) => Point(witdh * _drawing.value.originX, heigh * _drawing.value.originY);
  Point getPoint() => Point(_drawing.value.witdh, _drawing.value.height);
  Offset getOrigin() => origin.value;


  void changePath(drawing) {
    _drawing = drawing;
    if(pattern.contains(drawing)==false)
      pattern.add(drawing);
  }
  void changeLayer(drawing) {
    _layerD = drawing;
  }
  void addFavorite(drawing){
    favorite.add(drawing);
  }
  void changeOrigin(double x, double y){
    origin(Offset(x,y));
    print(' 선택한점은 절대좌표 X: $x, Y: $y');
  }

}