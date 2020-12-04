import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';

class DrawingPath with ChangeNotifier {
  String _path = 'asset/Plan2.png';
  String _name = 'S01-001.png';
  Drawing _drawing = Drawing(
    drawingNum: 'A31-003',
    title: '1층 평면도',
    scale: '500',
    localPath: 'asset/photos/A31-003.png',
    originX: 0.7373979439768359,
    originY: 0.23113260932198965,
  );

  String getPath() => _path;
  String getName() => _name;
  Drawing getDrawing() => _drawing;
  double getcordiX() => double.parse(_drawing.scale) * _drawing.witdh;
  double getcordiY() => double.parse(_drawing.scale) * _drawing.height;
  Offset getOffset() => Offset(_drawing.witdh.toDouble(), _drawing.height.toDouble());
  Offset getcordiOffset(witdh, heigh) => Offset(witdh * _drawing.originX, heigh * _drawing.originY);
  Point getcordiPoint(witdh, heigh) => Point(witdh * _drawing.originX, heigh * _drawing.originY);
  Point getPoint() => Point(_drawing.witdh, _drawing.height);

  void changePath(drawing) {
    _drawing = drawing;
    notifyListeners();
  }
}
