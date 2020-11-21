import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class LocationImage extends StatefulWidget {
  List<Task> tasks;

  LocationImage(this.tasks);

  @override
  _LocationImageState createState() => _LocationImageState();
}

class _LocationImageState extends State<LocationImage> {
  double a = 100;
  double b = 100;
  PhotoViewController pController ;

  @override
  void initState() {
    super.initState();
    pController = PhotoViewController();
  }

  @override
  void dispose() {
    super.dispose();
    pController.dispose();
  }
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
                PhotoView.customChild(
                  controller: pController,
                  initialScale: 1.0,
                  minScale: 1.0,
                  maxScale: 2.0,
                  backgroundDecoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      Image.asset('asset/Plan2.png'),
                      StreamBuilder<PhotoViewControllerValue>(
                          stream: pController.outputStateStream,
                          builder: (BuildContext context, AsyncSnapshot<PhotoViewControllerValue> snapshot) {
                            if (!snapshot.hasData)
                              return Container();
                            return Stack( children: widget.tasks.where((e) => e.x != null).map((e) {
                              return Positioned(
                                left: e.x,
                                top: e.y,
                                child: Draggable(
                                  onDragStarted: (){
                                   setState(() {
                                     e.px = e.x;
                                     e.py = e.y;
                                   });
                                  },
                                  onDragEnd: snapshot.data.scale == 1
                                      ?(details) {
                                    double _mx = details.offset.dx;
                                    double _my = details.offset.dy;
                                    setState(() {
                                      print('1. ${e.x},${e.y}');
                                      e.x = _mx-12;
                                      e.y = _my-92;
                                      print('2. ${e.x},${e.y}');
                                      // e.x = (details.offset.dx - 10);
                                      // e.y = (details.offset.dy - 80);
                                    });
                                  }
                                      :(details) {
                                    double _mx = details.offset.dx;
                                    double _my = details.offset.dy;
                                    double _scale = snapshot.data.scale;
                                    setState(() {
                                      print('1. ${e.x},${e.y}');
                                      e.x = e.px+((_mx)/_scale);
                                      e.y = e.py+((_my-92)/_scale);
                                      print('2. ${e.x},${e.y}');
                                      // e.x = (details.offset.dx - 10);
                                      // e.y = (details.offset.dy - 80);
                                    });
                                  },
                                  childWhenDragging: Container(),
                                  feedback: Opacity(
                                    opacity: 0.8,
                                    child: Transform.scale(
                                      scale: 2,
                                      //Task class favorite을 활용한 위치확인 기능 구현
                                      child: e.favorite == true
                                          ? Icon(
                                        Icons.pin_drop,
                                        color: Colors.red,
                                      )
                                          : Icon(Icons.pin_drop),
                                    ),
                                  ),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Transform.scale(
                                      scale: (1/snapshot.data.scale)*2,
                                      //Task class favorite을 활용한 위치확인 기능 구현
                                      child: e.favorite == true
                                          ? Icon(
                                        Icons.pin_drop,
                                        color: Colors.red,
                                      )
                                          : Icon(Icons.pin_drop),
                                    ),
                                  ),
                                ),
                              );
                            }).toList());
                          }
                      )

                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
