import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_location_todo/method/method.dart';
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
  PhotoViewController pContrl = PhotoViewController();
  double keyX = 0.0;
  double keyY = 0.0;
  TextEditingController _textEditingController;
  String search = "";
  TextEditingController docOriginXcontroller;
  TextEditingController docOriginYcontroller;
  TextEditingController angleController;
  TextEditingController scaleController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    docOriginXcontroller = TextEditingController();
    docOriginYcontroller = TextEditingController();
    angleController = TextEditingController();
    scaleController = TextEditingController();

    Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    docOriginXcontroller.dispose();
    docOriginYcontroller.dispose();
    angleController.dispose();
    scaleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CP CW = context.watch<CP>();

    ///세팅전 좌표 - 세팅된 좌표 => 스케일 X 종이 사이즈 =>>좌표 생성
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Get.back();
              })),
      endDrawer: buildDrawer(context),
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
                    selectDrawing: CW.getSettingD(),
                    isSetting: true,
                  ),
                ),
                Container(
                  width: dSizeWidth,
                  height: dSizeHeight,
                  child: TWViewer(
                    selectDrawing: CW.getDrawing(),
                    isSetting: false,
                  ),
                ),
              ],
            );
          }),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 72,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildDataField(label: 'docOriginX', controller: docOriginXcontroller, onChanged: (t) {}),
                      buildDataField(label: 'docOriginY', controller: docOriginYcontroller, onChanged: (t) {}),
                      buildDataField(label: 'scale', controller: scaleController, onChanged: (t) {}),
                      buildDataField(
                          label: 'angle',
                          controller: angleController,
                          onChanged: (t) {
                            setState(() {});
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                context.read<CP>().getSettingD().scale =
                                    (double.parse(context.read<CP>().getDrawing().scale) *
                                            (context.read<SD>().aLine.length() / context.read<SD>().bLine.length()))
                                        .toString();
                                SD temp = context.read<SD>();
                                CW.getSettingD().originX =
                                    temp.distanceX() / double.parse(CW.getSettingD().scale) / CW.getSettingD().witdh;
                                CW.getSettingD().originY =
                                    temp.distanceY() / double.parse(CW.getSettingD().scale) / CW.getSettingD().height;
                                docOriginXcontroller.text = CW.getSettingD().docOriginX.toString();
                                docOriginYcontroller.text = CW.getSettingD().docOriginY.toString();
                                angleController.text = context.read<SD>().angle().toString();
                                scaleController.text = (double.parse(context.read<CP>().getDrawing().scale) *
                                        (context.read<SD>().aLine.length() / context.read<SD>().bLine.length()))
                                    .toString();
                              });
                            },
                            child: Text('적용')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Drawing _d = context.read<CP>().getSettingD();
                                _d.orient = double.parse(angleController.text);
                                _d.scale = scaleController.text;
                                updateDrawing(drawing: _d, doc: '신세계하남');
                              });
                            },
                            child: Text('서버등록')),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
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
                                  buildOriginDoc(CW, constraints),
                                  buildsettingdoc(CW, constraints, context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildDataField(
      {@required String label, @required TextEditingController controller, @required Function(String) onChanged}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
            )),
      ),
    );
  }

  Opacity buildOriginDoc(CP CW, BoxConstraints constraints) {
    return Opacity(
      opacity: 0.5,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.green, BlendMode.overlay),
        child: Image.asset(
          'asset/photos/${CW.getDrawing().localPath}',
          // 'asset/photos/${CW.getDrawing().localPath}',
          height: constraints.maxHeight,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Positioned buildsettingdoc(CP CW, BoxConstraints constraints, BuildContext context) {
    return Positioned(
      top: ((CW.getDrawing().originY - CW.getSettingD().originY) * constraints.maxHeight) /
          (double.parse(CW.getDrawing().scale) / double.parse(CW.getSettingD().scale)),
      left: ((CW.getDrawing().originX - CW.getSettingD().originX) * constraints.maxHeight * a3Ratio) /
          (double.parse(CW.getDrawing().scale) / double.parse(CW.getSettingD().scale)),
      child: Opacity(
        opacity: 0.8,
        child: Transform.scale(
          alignment: Alignment.topLeft,
          origin: Offset(
            CW.getDrawing().originX * constraints.maxHeight * a3Ratio,
            CW.getDrawing().originY * constraints.maxHeight,
          ),
          scale: double.parse(CW.getSettingD().scale) / double.parse(CW.getDrawing().scale),
          child: Transform.rotate(
            alignment: Alignment.topLeft,
            origin: Offset(
              CW.getSettingD().docOriginX * constraints.maxHeight * a3Ratio,
              CW.getSettingD().docOriginY * constraints.maxHeight,
            ),
            angle: -pi / (180 / context.read<SD>().angle()),
            child: ClipRect(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.overlay),
                child: Image.asset(
                  'asset/photos/${CW.getSettingD().localPath}',
                  height: constraints.maxHeight,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (v) {
                  Future.delayed(Duration(milliseconds: 300)).then((value) {
                    setState(() {
                      search = v;
                    });
                  });
                },
                controller: _textEditingController,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: drawings
                  // .where((element) => element.scale == "1")
                  // .where((element) => element.toString().replaceAll(" ", "").contains("A52"))
                  .where((element) => element.toString().replaceAll(" ", "").contains(search.replaceAll(" ", "")))
                  .map((e) => Card(
                        child: ListTile(
                          title: AutoSizeText(e.toString(), maxLines: 1),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(onPressed: () => context.read<CP>().changePath(e), child: Text('A')),
                              TextButton(onPressed: () => context.read<CP>().changeSettingDrawing(e), child: Text('B')),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
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
  Offset pointA = Offset.zero;
  Offset pointB = Offset.zero;
  bool hoverling = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      d = widget.selectDrawing;
      _isSetting = widget.isSetting;
      pContrl.scale = 1;
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
              disableGestures: hoverling,
              controller: pContrl,
              minScale: 1.0,
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              child: PositionedTapDetector(
                onLongPress: (m) {
                  SD temp = context.read<SD>();
                  Offset scale = m.relative / pContrl.scale;
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
                      if (d.docOriginX == 0) {
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

                  ///세팅전 좌표 - 세팅된 좌표 => 스케일 X 종이 사이즈 =>>좌표 생성
                  setState(() {
                    if (pointA == Offset.zero) {
                      pointA = scale;
                    } else if (pointA != Offset.zero && pointB == Offset.zero) {
                      pointB = scale;
                    }
                    if (_isSetting) {
                      if (temp.bP1 == Offset.zero) {
                        temp.changebP1(scale);
                      } else if (temp.bP1 != Offset.zero && temp.bP2 == Offset.zero) {
                        temp.changebP2(scale);
                        temp.setBeforeLine();
                      }
                      if (tempSettingBefore.length < 2) {
                        tempSettingBefore.add(scale);
                        if (tempSettingBefore.length == 2) {
                          temp.changeBeforeLine(beforeP: tempSettingBefore.first, afterP: tempSettingBefore.last);
                        }
                      }
                    } else if (!_isSetting) {
                      if (temp.aP1 == Offset.zero) {
                        temp.changeaP1(scale);
                      } else if (temp.aP1 != Offset.zero && temp.aP2 == Offset.zero) {
                        temp.changeaP2(scale);
                        temp.setAfterLine();
                      }
                      if (tempSettingBefore.length < 2) {
                        tempSettingBefore.add(scale);
                        if (tempSettingBefore.length == 2) {
                          temp.changeAfterLine(beforeP: tempSettingBefore.first, afterP: tempSettingBefore.last);
                        }
                      }
                    }
                  });
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
                                painter: SettingDraw(
                                    tP: [pointA, pointB],
                                    // tP: _isSetting ? context.watch<SD>().getBline() : context.watch<SD>().getAline(),
                                    s: snapshot.data.scale),
                              );
                            })
                        : Container(),
                    StreamBuilder<PhotoViewControllerValue>(
                        stream: pContrl.outputStateStream,
                        initialData: PhotoViewControllerValue(
                          position: pContrl.position,
                          rotation: 0,
                          rotationFocusPoint: null,
                          scale: pContrl.scale,
                        ),
                        builder: (context, snapshot) {
                          return Positioned.fromRect(
                            rect: Rect.fromCenter(center: pointA, width: 100, height: 100),
                            child: Transform.scale(
                              alignment: Alignment.center,
                              scale: 1 / snapshot.data.scale,
                              child: Listener(
                                onPointerUp: (u) {
                                  setState(() {
                                    hoverling = false;
                                    if (_isSetting) {
                                      context.read<SD>().changebP1(pointA);
                                    } else if (!_isSetting) {
                                      context.read<SD>().changeaP1(pointA);
                                    }
                                    print(hoverling);
                                  });
                                },
                                onPointerMove: (p) {
                                  hoverling = true;
                                  setState(() {
                                    pointA += p.delta / pContrl.scale;
                                  });
                                },
                                child: Icon(
                                  Icons.close_sharp,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        }),
                    StreamBuilder<PhotoViewControllerValue>(
                        stream: pContrl.outputStateStream,
                        initialData: PhotoViewControllerValue(
                          position: pContrl.position,
                          rotation: 0,
                          rotationFocusPoint: null,
                          scale: pContrl.scale,
                        ),
                        builder: (context, snapshot) {
                          return Positioned.fromRect(
                            rect: Rect.fromCenter(center: pointB, width: 100, height: 100),
                            child: Transform.scale(
                              alignment: Alignment.center,
                              scale: 1 / snapshot.data.scale,
                              child: Listener(
                                onPointerUp: (u) {
                                  setState(() {
                                    hoverling = false;
                                    if (_isSetting) {
                                      context.read<SD>().changebP2(pointB);
                                    } else if (!_isSetting) {
                                      context.read<SD>().changeaP2(pointB);
                                    }
                                    print(hoverling);
                                  });
                                },
                                onPointerMove: (p) {
                                  hoverling = true;
                                  setState(() {
                                    pointB += p.delta / pContrl.scale;
                                  });
                                  // hoverling =false;
                                },
                                child: Icon(
                                  Icons.close_sharp,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          );
                        })
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
    // p.close();

    tP == [] ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    tP == [] ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
