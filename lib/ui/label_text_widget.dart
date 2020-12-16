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
            // CustomPaint(
            //   painter: Leader(top,left,widget.scale),
            // ),
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
  double top;
  double bottom;
  double left;
  double right;

  Leader({this.left, this.top, this.right, this.bottom,});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2.0
      ..color = Colors.red;
    Paint paint2 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9.0
      ..color = Colors.red;

    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
