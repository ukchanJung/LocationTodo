import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/provider/setting_drawing.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

class OriginSettingPage extends StatefulWidget {
  @override
  _OriginSettingPageState createState() => _OriginSettingPageState();
}

class _OriginSettingPageState extends State<OriginSettingPage> {
  double a3Ratio = 420 / 297;
  List<Drawing> drawings = [];
  String A1 = 'A31-003';
  // String A2 = 'A82-004';

  // String A2 = 'A52-024';

  String A2 = 'A52-027';
  PhotoViewController pContrl = PhotoViewController();
  double keyX = 0.0;
  double keyY = 0.0;
  Drawing A1D;
  Drawing A2D;

  @override
  void initState() {
    super.initState();

    Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
      context.read<CP>().changePath(drawings.singleWhere((d) => d.drawingNum == A1));
      // pathDrawings.add(context.read<CP>().getDrawing());
      if (drawings.singleWhere((element) => element.drawingNum == A2).scale == '1') {
        drawings.singleWhere((element) => element.drawingNum == A2).scale = '80';
      }
      Drawing se = drawings.singleWhere((element) => element.drawingNum == A2);
      // print(se.originX);
      // print(se.originY);
    });
  }

  @override
  Widget build(BuildContext context) {
    // drawings.singleWhere((element) => element.drawingNum == A2).originX = 0;
    // drawings.singleWhere((element) => element.drawingNum == A2).originY = 0;
    // drawings.singleWhere((element) => element.drawingNum == A2).originX = 1.49389881;
    // drawings.singleWhere((element) => element.drawingNum == A2).originY = 0.0368265990;
    // drawings.singleWhere((element) => element.drawingNum == A2).originX = 1.039136905;
    // drawings.singleWhere((element) => element.drawingNum == A2).originY = -0.308;
     A1D = drawings.singleWhere((element) => element.drawingNum == A1);
     A2D = drawings.singleWhere((element) => element.drawingNum == A2);

    ///-12398, 15033
    ///세팅전 좌표 - 세팅된 좌표 => 스케일 X 종이 사이즈 =>>좌표 생성

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined), onPressed: (){Get.back();})),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            SD temp = context.read<SD>();
            A2D.originX = temp.distanceX() / double.parse(A2D.scale) / A2D.witdh;
            A2D.originY = temp.distanceY() / double.parse(A2D.scale) / A2D.height;
          });
        },
      ),
      endDrawer: Drawer(
        child:           ListView(
          children: drawings
              .where((element) => element.scale == "1")
              .map((e) => ListTile(
            title: AutoSizeText(e.toString(), maxLines: 1),
            onTap: (){
              setState(() {
                A2=e.localPath;
              });
            },
          ))
              .toList(),
        ),
          
      ),
      body: Row(
        children: [
          LayoutBuilder(builder: (context, c) {
            double dSizeWidth = c.maxHeight / 2 * a3Ratio;
            double dSizeHeight = c.maxHeight / 2;
            return Column(
              children: [
                Container(
                  width: dSizeWidth,
                  height: dSizeHeight,
                  child: TWViewer(
                    selectDrawing: A2D,
                    isSetting: true,
                  ),
                ),
                Container(
                  width: dSizeWidth,
                  height: dSizeHeight,
                  child: TWViewer(
                    selectDrawing: A1D,
                    isSetting: false,
                  ),
                ),
              ],
            );
          }),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              pContrl.addIgnorableListener(() {
                keyX = pContrl.value.position.dx / (constraints.maxHeight * a3Ratio * pContrl.value.scale);
                keyY = pContrl.value.position.dy / (constraints.maxHeight * pContrl.value.scale);
              });

              return Listener(
                onPointerSignal: (m) {
                  if (m is PointerScrollEvent) {
                    Offset up = Offset(keyX * constraints.maxWidth * (pContrl.scale + 0.2),
                        keyY * constraints.maxHeight * (pContrl.scale + 0.2));
                    Offset dn = Offset(keyX * constraints.maxWidth * (pContrl.scale - 0.2),
                        keyY * constraints.maxHeight * (pContrl.scale - 0.2));
                    if (m.scrollDelta.dy > 1 && pContrl.scale > 1) {
                      pContrl.value = PhotoViewControllerValue(
                          position: dn, scale: (pContrl.scale - 0.2), rotation: 0, rotationFocusPoint: null);
                    } else if (m.scrollDelta.dy < 1) {
                      pContrl.value = PhotoViewControllerValue(
                          position: up, scale: (pContrl.scale + 0.2), rotation: 0, rotationFocusPoint: null);
                    }
                  }
                },
                child: Container(
                  height: constraints.maxHeight,
                  child: ClipRect(
                    child: PhotoView.customChild(
                        childSize: Size(constraints.maxHeight * a3Ratio, constraints.maxHeight),
                        minScale: 1.0,
                        initialScale: PhotoViewComputedScale.covered,
                        controller: pContrl,
                        backgroundDecoration: BoxDecoration(color: Colors.transparent),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Opacity(
                              opacity: 1.0,
                              child: Image.asset(
                                'asset/photos/${A1D.localPath}',
                                height: constraints.maxHeight,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Positioned(
                              top: ((A1D.originY - A2D.originY) * constraints.maxHeight) /
                                  (double.parse(A1D.scale) / double.parse(A2D.scale)),
                              left: ((A1D.originX - A2D.originX) * constraints.maxHeight * a3Ratio) /
                                  (double.parse(A1D.scale) / double.parse(A2D.scale)),
                              child: Opacity(
                                opacity: 0.9,
                                child: Transform.scale(
                                  alignment: Alignment.topLeft,
                                  origin: Offset(
                                    A1D.originX * constraints.maxHeight * a3Ratio,
                                    A1D.originY * constraints.maxHeight,
                                  ),
                                  scale: double.parse(A2D.scale) / double.parse(A1D.scale),
                                  child: Transform.rotate(
                                    alignment: Alignment.topLeft,
                                    origin: Offset(
                                      A2D.docOriginX * constraints.maxHeight * a3Ratio,
                                      A2D.docOriginY * constraints.maxHeight,
                                    ),
                                    // origin: Offset(
                                    //   0.652916667 * constraints.maxHeight * a3Ratio,
                                    //   0.303619529 * constraints.maxHeight,
                                    // ),
                                    // angle: -pi / 2,
                                    angle: -pi / (180 / context.read<SD>().angle()),
                                    // angle: -pi / (180 / context.read<SD>().angle()),
                                    child: ClipRect(
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(Colors.red, BlendMode.lighten),
                                        child: Image.asset(
                                          'asset/photos/${A2D.localPath}',
                                          height: constraints.maxHeight,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }

}

class TWViewer extends StatefulWidget {
  Drawing selectDrawing;
  String imagePath = 'A31-003.png';
  Size size;
  bool isSetting;

  TWViewer({@required this.selectDrawing, @required this.isSetting});

  @override
  _TWViewerState createState() => _TWViewerState();
}

class _TWViewerState extends State<TWViewer> {
  PhotoViewController pContrl = PhotoViewController();
  Offset _origin = Offset.zero;
  Drawing d;
  double keyX = 0.0;
  double keyY = 0.0;
  double settingX = 0.0;
  double settingY = 0.0;
  double originX = 0.0;
  double originY = 0.0;
  bool _isSetting = false;
  List<Offset> tempSettingBefore = [];
  List<Offset> first = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      d = widget.selectDrawing;
      _isSetting = widget.isSetting;
    });
  }

  @override
  Widget build(BuildContext context) {
    d = widget.selectDrawing;

    return LayoutBuilder(
      builder: (context, c) {
        pContrl.addIgnorableListener(() {
          keyX = pContrl.value.position.dx / (c.maxWidth * pContrl.value.scale);
          keyY = pContrl.value.position.dy / (c.maxHeight * pContrl.value.scale);
        });

        return Listener(
          onPointerSignal: (m) {
            if (m is PointerScrollEvent) {
              Offset up = Offset(keyX * c.maxWidth * (pContrl.scale + 0.2), keyY * c.maxHeight * (pContrl.scale + 0.2));
              Offset dn = Offset(keyX * c.maxWidth * (pContrl.scale - 0.2), keyY * c.maxHeight * (pContrl.scale - 0.2));
              if (m.scrollDelta.dy > 1 && pContrl.scale > 1) {
                pContrl.value = PhotoViewControllerValue(
                    position: dn, scale: (pContrl.scale - 0.2), rotation: 0, rotationFocusPoint: null);
              } else if (m.scrollDelta.dy < 1) {
                pContrl.value = PhotoViewControllerValue(
                    position: up, scale: (pContrl.scale + 0.2), rotation: 0, rotationFocusPoint: null);
              }
            }
          },
          child: ClipRect(
            child: PhotoView.customChild(
              controller: pContrl,
              minScale: 1.0,
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              child: PositionedTapDetector(
                // onTap: (m) {
                //   setState(() {
                //     _origin = Offset(m.relative.dx, m.relative.dy) / pContrl.scale;
                //     int settingX =
                //         ((m.relative.dx / pContrl.scale) / c.maxWidth * (double.parse(d.scale) * d.witdh)).round();
                //     int settingY =
                //         ((m.relative.dy / pContrl.scale) / c.maxHeight * (double.parse(d.scale) * d.height)).round();
                //     int debugX =
                //         (((m.relative.dx / pContrl.scale) / c.maxWidth - d.originX) * (double.parse(d.scale) * d.witdh))
                //             .round();
                //     int debugY = (((m.relative.dy / pContrl.scale) / c.maxHeight - d.originY) *
                //             (double.parse(d.scale) * d.height))
                //         .round();
                //     // tracking.add(_origin);
                //     // measurement.add(_origin);
                //     // rmeasurement.add(Offset(debugX.toDouble(), debugY.toDouble()));
                //     print('${c.maxWidth}, ${c.maxHeight}');
                //     print('pScale: ${pContrl.scale}');
                //     print('scale: ${d.scale}, X: ${d.originX}, Y: ${d.originY}');
                //     print('$debugX, $debugY');
                //     // pR.changeOrigin(debugX.toDouble(), debugY.toDouble());
                //     if (_isSetting) {
                //       setState(() {
                //         context.read<SD>().changeBefore(x: settingX, y: settingY);
                //         d.docOriginX = (m.relative.dx / pContrl.scale) / c.maxWidth;
                //         d.docOriginY = (m.relative.dy / pContrl.scale) / c.maxHeight;
                //       });
                //     } else if (!_isSetting) {
                //       setState(() {
                //         context.read<SD>().changeAfter(x: debugX, y: debugY);
                //       });
                //     }
                //   });
                // },
                onLongPress: (m) {
                  SD temp = context.read<SD>();
                  double settingX = (m.relative.dx / pContrl.scale) / c.maxWidth * (double.parse(d.scale) * d.witdh);
                  double settingY = (m.relative.dy / pContrl.scale) / c.maxHeight * (double.parse(d.scale) * d.height);
                  double debugX =
                      ((m.relative.dx / pContrl.scale) / c.maxWidth - d.originX) * (double.parse(d.scale) * d.witdh);
                  double debugY =
                      ((m.relative.dy / pContrl.scale) / c.maxHeight - d.originY) * (double.parse(d.scale) * d.height);
                  if (_isSetting) {
                    first.add(Offset(settingX.toDouble(), settingY.toDouble()));
                    setState(() {
                      context.read<SD>().changeBefore(x: first.first.dx, y: first.first.dy);
                      if(d.docOriginX==0){
                        d.docOriginX = (m.relative.dx / pContrl.scale) / c.maxWidth;
                        d.docOriginY = (m.relative.dy / pContrl.scale) / c.maxHeight;
                      }
                    });
                  } else if (!_isSetting) {
                    first.add(Offset(debugX.toDouble(), debugY.toDouble()));
                    setState(() {
                      context.read<SD>().changeAfter(x: first.first.dx, y: first.first.dy);
                    });
                  }

                  Offset scale = m.relative / pContrl.scale;

                  ///세팅전 좌표 - 세팅된 좌표 => 스케일 X 종이 사이즈 =>>좌표 생성
                  print('@@@@@@@${temp.angle()}');
                  setState(() {
                    if (_isSetting) {
                      SD temp = context.read<SD>();
                      // if (temp.aX != 0 && temp.bX != 0&&d.originX==0&&d.originY==0) {
                      //   d.originX = temp.distanceX() / double.parse(d.scale) / d.witdh;
                      //   d.originY = temp.distanceY() / double.parse(d.scale) / d.height;
                      // }
                      if (tempSettingBefore.length < 2) {
                        tempSettingBefore.add(Offset(scale.dx, scale.dy));
                      } else if (tempSettingBefore.length == 2) {
                        temp.changeBeforeLine(beforeP: tempSettingBefore.first, afterP: tempSettingBefore.last);
                      }
                    } else if (!_isSetting) {
                      if (tempSettingBefore.length < 2) {
                        tempSettingBefore.add(Offset(scale.dx, scale.dy));
                      } else if (tempSettingBefore.length == 2) {
                        temp.changeAfterLine(beforeP: tempSettingBefore.first, afterP: tempSettingBefore.last);
                      }
                    }
                  });
                  print('${d.originX}, ${d.originY}');
                },
                child: Stack(
                  children: [
                    Image.asset('asset/photos/${d.localPath}'),
                    tempSettingBefore.length > 0
                        ? StreamBuilder<PhotoViewControllerValue>(
                            stream: pContrl.outputStateStream,
                            initialData: PhotoViewControllerValue(
                              position: pContrl.position,
                              rotation: 0,
                              rotationFocusPoint: null,
                              scale: pContrl.scale,
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                              return CustomPaint(
                                painter: SettingDraw(tP: tempSettingBefore, s: snapshot.data.scale),
                              );
                            })
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SettingDraw extends CustomPainter {
  List<Offset> tP;
  double s = 1;

  SettingDraw({this.tP, this.s});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint4 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0 / s
      ..color = Color.fromRGBO(230, 0, 255, 1.0);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0 / s
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(230, 0, 255, 1.0);

    Path p = Path();
    p.moveTo(tP[0].dx, tP[0].dy);
    tP.forEach((e) {
      p.lineTo(e.dx, e.dy);
    });
    p.close();

    tP == [] ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    tP == [] ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
