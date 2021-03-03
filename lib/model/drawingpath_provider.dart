import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';

class CP with ChangeNotifier {
  String _path = 'S01-001.png';
  String _name = 'S01-001.png';
  List<Drawing> pattern =[];
  Set<Drawing> favorite ={};
  Drawing _drawing = Drawing(
    drawingNum: 'A31-003',
    title: '1층 평면도',
    scale: '500',
    localPath: 'A31-003.png',
    originX: 0.7373979439768359,
    originY: 0.23113260932198965,
  );
  Drawing _layerD = Drawing(
    drawingNum: 'A31-003',
    title: '1층 평면도',
    scale: '500',
    localPath: 'A31-003.png',
    originX: 0.7373979439768359,
    originY: 0.23113260932198965,
  );
  Offset origin= Offset.zero;

  String getPath() => _path;
  String getName() => _name;
  String getcordi() => '${_drawing.toString()}${_drawing.originX}, ${_drawing.originY}, ${_drawing.scale}';
  Drawing getDrawing() => _drawing;
  Drawing getLayer() => _layerD;
  double getcordiX() => double.parse(_drawing.scale) * _drawing.witdh;
  double getcordiY() => double.parse(_drawing.scale) * _drawing.height;
  Offset getOffset() => Offset(_drawing.witdh.toDouble(), _drawing.height.toDouble());
  Offset getcordiOffset(witdh, heigh) => Offset(witdh * _drawing.originX, heigh * _drawing.originY);
  Point getcordiPoint(witdh, heigh) => Point(witdh * _drawing.originX, heigh * _drawing.originY);
  Point getPoint() => Point(_drawing.witdh, _drawing.height);
  Offset getOrigin() => origin;

  void changePath(drawing) {
    _drawing = drawing;
    if(pattern.contains(drawing)==false)
    pattern.add(drawing);
    notifyListeners();
  }
  void changeLayer(drawing) {
    _layerD = drawing;
    notifyListeners();
  }
  void addFavorite(drawing){
    favorite.add(drawing);
    notifyListeners();
  }
  void changeOrigin(double x, double y){
    origin = Offset(x,y);
    print(' 선택한점은 절대좌표 X: $x, Y: $y');
    notifyListeners();
}
}
class OnOff with ChangeNotifier{
  bool memoOn =false;

  void memoOnOff(){
    memoOn =!memoOn;
  }
}
