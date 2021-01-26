import 'dart:ui';

import 'package:flutter/material.dart';
class CrossHair extends StatefulWidget {
  @override
  _CrossHairState createState() => _CrossHairState();
}

class _CrossHairState extends State<CrossHair> {
  Offset hover = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Listener(
        onPointerHover: (h){
          setState(() {
            hover = h.localPosition;
            print(hover);
          });
        },
        child: CustomPaint(
          painter: CrossHairPaint(hover),
          // painter: CrossHairPaint(hover,width: context.size.width,height: context.size.height),
        ),
      ),
    );
  }
}


class CrossHairPaint extends CustomPainter {
  Offset h = Offset.zero;
  double s;
  double width = 10000;
  double height = 10000;

  CrossHairPaint(this.h,{this.width,this.height,});

  @override
  void paint(Canvas canvas, Size size) {
    Paint crossHair = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2.0
      ..color = Color.fromRGBO(0, 0, 255, 0.5);

    canvas.drawLine(Offset(h.dx,0), Offset(h.dx,100000000), crossHair);
    canvas.drawLine(Offset(0,h.dy), Offset(1000000000,h.dy), crossHair);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
