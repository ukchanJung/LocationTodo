import 'dart:math';

class Closet{
  Point _p;
  List<Point> _pointList;

  Closet(this._p, this._pointList);
  Point min(){
   return _pointList.reduce((v, e) => _p.distanceTo(v)>_p.distanceTo(e)?e:v);
  }
  Point max(){
   return _pointList.reduce((v, e) => _p.distanceTo(v)>_p.distanceTo(e)?v:e);
  }
}
