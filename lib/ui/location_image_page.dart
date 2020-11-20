import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';

class LocationImage extends StatefulWidget {
  List<Task> tasks;

  LocationImage(this.tasks);

  @override
  _LocationImageState createState() => _LocationImageState();
}

class _LocationImageState extends State<LocationImage> {
  double a = 100;
  double b = 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // 향후 PhotoView활용하여 확대 축소 Pan 기능 구현 필요
      child: AspectRatio(
        aspectRatio: 421 / 297,
        child: ClipRect(
          child: Card(
            child: Stack(
              children: [
                Image.asset('asset/Plan2.png'),
                Stack(
                    children: widget.tasks.where((e) => e.x != null).map((e) {
                  return Positioned(
                    left: e.x,
                    top: e.y,
                    child: Draggable(
                      onDragEnd: (details){
                        setState(() {
                          e.x = details.offset.dx-10;
                          e.y = details.offset.dy-80;
                        });
                      },
                      childWhenDragging: Container(),
                      feedback: Opacity(
                        opacity: 0.8,
                        child: Transform.scale(
                          scale: 2,
                          //Task class favorite을 활용한 위치확인 기능 구현
                          child: e.favorite == true ? Icon(Icons.pin_drop,color: Colors.red,) : Icon(Icons.pin_drop),
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.8,
                        child: Transform.scale(
                          scale: 2,
                          //Task class favorite을 활용한 위치확인 기능 구현
                          child: e.favorite == true ? Icon(Icons.pin_drop,color: Colors.red,) : Icon(Icons.pin_drop),
                        ),
                      ),
                    ),
                  );
                }).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
