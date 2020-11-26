import 'package:flutter/material.dart';

class Grid{
  Offset origin;
  int x;
  int y;
  String name;
  Grid nestGrid;
  int nestSize;


  void nestSetX(){x = nestGrid.x +nestSize;}
  void nestSetY(){x = nestGrid.y +nestSize;}

  Grid.nestX(this.origin, this.name, this.nestGrid, this.nestSize);

  Grid(this.name, {this.origin, this.x, this.y,} );

  @override
  String toString() {
    return 'Grid{name: $name, x: $x, y: $y}';
  }
}
