import 'package:flutter/material.dart';

class DrawingPath with ChangeNotifier{
  String _path = 'asset/photos/S01-001.png';
  String _name = 'S01-001.png';


  String getPath() => _path;
  String getName() => _name;

  void changePath(_selectPath, _selectname){

    _path = _selectPath;
    _name = _selectname;
    notifyListeners();
  }

}
