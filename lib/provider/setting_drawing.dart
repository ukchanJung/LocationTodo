import 'package:flutter/cupertino.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class SD extends ChangeNotifier {
  double bX = 0;
  double bY = 0;
  double aX = 0;
  double aY = 0;

  Offset bP1 = Offset.zero;
  Offset bP2 = Offset.zero;
  Offset aP1 = Offset.zero;
  Offset aP2 = Offset.zero;

  Line bLine = Line(Offset.zero, Offset.zero);
  Line aLine = Line(Offset.zero, Offset.zero);

  double distanceX() => bX - aX;
  double distanceY() => bY - aY;
  double angle() => aLine.degree() - bLine.degree();
  double angle2() => aLine.degree2() - bLine.degree2();
  List<Offset> getBline() => [bP1, bP2];
  List<Offset> getAline() => [aP1, aP2];
  Offset getbP1() => bP1;
  Offset getbP2() => bP2;
  Offset getaP1() => aP1;
  Offset getaP2() => aP2;

  void changebP1(Offset point) {
    bP1 = point;
    notifyListeners();
  }

  void changebP2(Offset point) {
    bP2 = point;
    notifyListeners();
  }

  void changeaP1(Offset point) {
    aP1 = point;
    notifyListeners();
  }

  void changeaP2(Offset point) {
    aP2 = point;
    notifyListeners();
  }

  void movebP1(Offset point) {
    bP1 += point;
    notifyListeners();
  }

  void movebP2(Offset point) {
    bP2 += point;
    notifyListeners();
  }

  void moveaP1(Offset point) {
    aP1 += point;
    notifyListeners();
  }

  void moveaP2(Offset point) {
    aP2 += point;
    notifyListeners();
  }

  void changeBefore({@required double x, @required double y}) {
    bX = x;
    bY = y;
    print('세팅전: $x, $y');
    notifyListeners();
  }

  void changeBeforeLine({@required Offset beforeP, @required Offset afterP}) {
    bLine = Line(beforeP, afterP);
    notifyListeners();
  }

  void changeAfterLine({@required Offset beforeP, @required Offset afterP}) {
    aLine = Line(beforeP, afterP);
    notifyListeners();
  }

  void setBeforeLine() {
    bLine = Line(this.bP1, this.bP2);
    notifyListeners();
  }

  void setAfterLine() {
    aLine = Line(this.aP1, this.aP2);
    notifyListeners();
  }

  void changeAfter({@required double x, @required double y}) {
    aX = x;
    aY = y;
    print('세팅 후: $x, $y');
    notifyListeners();
  }
}
