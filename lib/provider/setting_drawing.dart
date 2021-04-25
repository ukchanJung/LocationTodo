import 'package:flutter/cupertino.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class SD extends ChangeNotifier {
  double bX =0;
  double bY =0;
  double aX =0;
  double aY =0;

  Line bLine = Line(Offset.zero,Offset.zero);
  Line aLine = Line(Offset.zero,Offset.zero);


  double distanceX ()=> bX-aX;
  double distanceY ()=> bY-aY;
  double angle ()=>aLine.degree()-bLine.degree();
  double angle2 ()=>aLine.degree2()-bLine.degree2();

  void changeBefore({@required double x, @required double y }) {
    bX = x;
    bY = y;
    print('세팅전: $x, $y');
    notifyListeners();
  }
  void changeBeforeLine({@required Offset beforeP , @required Offset afterP }) {
    bLine = Line(beforeP,afterP);
    notifyListeners();
  }
  void changeAfterLine({@required Offset beforeP , @required Offset afterP }) {
    aLine = Line(beforeP,afterP);
    notifyListeners();
  }
  void changeAfter({@required double x, @required double y }) {
    aX = x;
    aY = y;
    print('세팅 후: $x, $y');
    notifyListeners();
  }
}