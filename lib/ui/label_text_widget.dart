import 'dart:ui';

import 'package:flutter/material.dart';

class LabelText extends StatefulWidget {
  double scale = 1;

  LabelText(this.scale);

  @override
  _LabelTextState createState() => _LabelTextState();
}

class _LabelTextState extends State<LabelText> {
  double top = 50;
  double left = 150;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            CustomPaint(
              painter: Leader(top,left,widget.scale),
            ),
            Positioned(
              top: top,
              left: left,
              child: Draggable(
                onDragStarted: (){
                  print('시작');
                },
                onDragEnd: (details) {
                  print('끝');
                  setState(() {
                    top = details.offset.dy;
                    left = details.offset.dx;
                  });
                },
                childWhenDragging: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(8.0/widget.scale),
                      child: Text('테스트1',textScaleFactor: 1/widget.scale,),
                    ),
                  ),
                ),
                feedback: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(8.0/widget.scale),
                      child: Text('테스트1',textScaleFactor: 1/widget.scale,),
                    ),
                  ),
                ),
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(8.0/widget.scale),
                      child: Text('테스트1',textScaleFactor: 1/widget.scale,),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

class Leader extends CustomPainter {
  double y =50;
  double x =150;
  double s =1;

  Leader(this.y,this.x,this.s);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2.0/s
      ..color = Colors.red;
    Paint paint2 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9.0/s
      ..color = Colors.red;
    canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(0, 0),
          Offset(0, y),
          Offset(x, y),
        ],
        paint);
    canvas.drawPoints(PointMode.points, [Offset(0, 0)], paint2);
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
