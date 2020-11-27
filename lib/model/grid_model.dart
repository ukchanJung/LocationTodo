import 'package:flutter/material.dart';

class Grid{
  int x;
  int y;
  String name;

  Grid(this.name, {this.x, this.y,} );

  @override
  String toString() {
    return 'Grid{name: $name, x: $x, y: $y}';
  }
}
