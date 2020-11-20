import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';

class LocationImage extends StatefulWidget {
  List<Task> tasks;

  LocationImage(this.tasks);

  @override
  _LocationImageState createState() => _LocationImageState();
}

class _LocationImageState extends State<LocationImage> {
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
                    child: GestureDetector(
                      onLongPress: () {
                        print('아이콘 롱프레스');
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          e.x = details.localPosition.dx;
                          e.y = details.localPosition.dy;
                        });
                      },
                      child: Opacity(
                        opacity: 0.8,
                        child: Transform.scale(
                          scale: 2,
                          child: Icon(Icons.pin_drop),
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
