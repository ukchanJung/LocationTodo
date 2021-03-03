// Widget buildViewer(BuildContext context, BoxConstraints c, {double width, double height}) {
//   return Container(
//     child: ClipRect(
//       child: Transform(
//         transform: Matrix4.identity()
//           ..setEntry(3, 2, 0.001)
//           ..rotateZ(0)
//           ..rotateX(0.005 * _offset.dy)
//           ..rotateY(0),
//         origin: _origin2,
//         child: PhotoView.customChild(
//           minScale: 1.0,
//           maxScale: 20.0,
//           initialScale: PhotoViewComputedScale.covered,
//           controller: _pContrl,
//           backgroundDecoration: BoxDecoration(color: Colors.transparent),
//           childSize: Size(width, width / a3),
//           child: LayoutBuilder(builder: (context, k) {
//             return Stack(
//               children: [
//                 PositionedTapDetector(
//                   controller: pointer == true ? _positionedTapController : null,
//                   key: _key,
//                   onTap: (m) {
//                     setState(() {
//                       _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
//                       print(m.relative / _pContrl.scale);
//                       int debugX =
//                       (((m.relative.dx / _pContrl.scale) / width - context.read<Current>().getDrawing().originX) *
//                           context.read<Current>().getcordiX())
//                           .round();
//                       int debugY = (((m.relative.dy / _pContrl.scale) / height -
//                           context.read<Current>().getDrawing().originY) *
//                           context.read<Current>().getcordiY())
//                           .round();
//                       tracking.add(_origin);
//                       measurement.add(_origin);
//                       rmeasurement.add(Offset(debugX.toDouble(), debugY.toDouble()));
//                       context.read<Current>().changeOrigin(debugX.toDouble(), debugY.toDouble());
//                     });
//                   },
//                   onLongPress: (m) {
//                     int debugX =
//                     (((m.relative.dx / _pContrl.scale) / width - context.read<Current>().getDrawing().originX) *
//                         context.read<Current>().getcordiX())
//                         .round();
//                     int debugY =
//                     (((m.relative.dy / _pContrl.scale) / height - context.read<Current>().getDrawing().originY) *
//                         context.read<Current>().getcordiY())
//                         .round();
//                     context.read<Current>().changeOrigin(debugX.toDouble(), debugY.toDouble());
//                     context.read<MemoDialog>().memoOn = true;
//                   },
//                   child: Listener(
//                     onPointerHover: (h) {
//                       setState(() {
//                         hover = h.localPosition;
//                       });
//                     },
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       key: _key2,
//                       // alignment: Alignment.center,
//                       children: [
//                         // Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
//                         Container(
//                           width: width,
//                           height: height,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
//                               alignment: Alignment.topLeft,
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
//                             child: Container(
//                               color: Colors.black.withOpacity(0),
//                             ),
//                           ),
//                         ),
//                         layerOn
//                             ? Positioned(
//                           top: ((context.watch<Current>().getDrawing().originY -
//                               context.watch<Current>().getLayer().originY) *
//                               height) /
//                               (double.parse(context.watch<Current>().getDrawing().scale) /
//                                   double.parse(context.watch<Current>().getLayer().scale)) +
//                               1.5,
//                           left: ((context.watch<Current>().getDrawing().originX -
//                               context.watch<Current>().getLayer().originX) *
//                               width) /
//                               (double.parse(context.watch<Current>().getDrawing().scale) /
//                                   double.parse(context.watch<Current>().getLayer().scale)),
//                           child: Opacity(
//                             opacity: 1,
//                             child: ColorFiltered(
//                               colorFilter: ColorFilter.mode(Colors.red, BlendMode.lighten),
//                               child: Transform.scale(
//                                 alignment: Alignment.topLeft,
//                                 origin: Offset(context.watch<Current>().getDrawing().originX * width,
//                                     context.watch<Current>().getDrawing().originY * height),
//                                 scale: double.parse(context.watch<Current>().getLayer().scale) /
//                                     double.parse(context.watch<Current>().getDrawing().scale),
//                                 child: Image.asset(
//                                   'asset/photos/${context.watch<Current>().getLayer().localPath}',
//                                   width: width,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                             : Container(),
//
//                         ///Level작업중
//                         // Container(
//                         //   decoration: ShapeDecoration(
//                         //     shadows: [BoxShadow(color: Colors.black, offset: Offset(3, -3), blurRadius: 2)],
//                         //     shape: HatchShape(),
//                         //     color: Colors.red
//                         //   ),
//                         //   child: ClipPath(
//                         //       clipper: CustomClipperImage(),
//                         //       child:
//                         //           Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}')),
//                         // ),
//
//                         ///TaskBoundary 구현
//                         taskAdd == true
//                             ? StreamBuilder<PhotoViewControllerValue>(
//                             stream: _pContrl.outputStateStream,
//                             initialData: PhotoViewControllerValue(
//                               position: _pContrl.position,
//                               rotation: 0,
//                               rotationFocusPoint: null,
//                               scale: _pContrl.scale,
//                             ),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//                               return Stack(
//                                 children: [
//                                   CustomPaint(
//                                     painter: TaskBoundaryPaint(tP: tracking, s: snapshot.data.scale),
//                                   ),
//                                 ],
//                               );
//                             })
//                             : Container(),
//
//                         ///서버 바운더리 Read
//                         context.watch<Current>().getDrawing().scale != '1'
//                             ? TaskBoundaryRead(
//                           tasks2: tasks2,
//                           width: width,
//                           height: height,
//                           pContrl: _pContrl,
//                           day: rangeS,
//                           m: caculon,
//                           add: taskAdd,
//                         )
//                             : Container(),
//
//                         ///측정구현
//                         caculon == true
//                             ? StreamBuilder<PhotoViewControllerValue>(
//                             stream: _pContrl.outputStateStream,
//                             initialData: PhotoViewControllerValue(
//                               position: _pContrl.position,
//                               rotation: 0,
//                               rotationFocusPoint: null,
//                               scale: _pContrl.scale,
//                             ),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//                               return Stack(
//                                 children: [
//                                   CustomPaint(
//                                     painter: CallOutCount(tP: tracking, s: snapshot.data.scale),
//                                   ),
//                                   rmeasurement != null && rmeasurement.length > 2
//                                       ? Positioned(
//                                     left: hover.dx,
//                                     top: hover.dy,
//                                     child: Text(
//                                       '${(computeArea(rmeasurement) / 1000000).toStringAsFixed(0)}m3',
//                                     ),
//                                   )
//                                       : Container(),
//                                   measurement != null && measurement.length > 1
//                                       ? Stack(
//                                     children: measurement
//                                         .sublist(1)
//                                         .map((e) => Positioned.fromRect(
//                                         rect: Rect.fromCenter(
//                                             center: (measurement[measurement.indexOf(e) - 1] +
//                                                 measurement[measurement.indexOf(e)]) /
//                                                 2,
//                                             width: 100,
//                                             height: 100),
//                                         child: Center(
//                                             child: Transform.rotate(
//                                               angle: pi /
//                                                   (180 /
//                                                       Line(measurement[measurement.indexOf(e) - 1],
//                                                           measurement[measurement.indexOf(e)])
//                                                           .degree()),
//                                               child: Transform.scale(
//                                                 scale: 1 / snapshot.data.scale,
//                                                 child: Card(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.all(4.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Text(
//                                                           '${(Line(rmeasurement[measurement.indexOf(e) - 1], rmeasurement[measurement.indexOf(e)]).length() / 1000).toStringAsFixed(2)}',
//                                                           textScaleFactor: 1.2,
//                                                           // style: TextStyle(color: Colors.white),
//                                                         ),
//                                                         Text(
//                                                           'X : ${(Line(Offset(rmeasurement[measurement.indexOf(e) - 1].dx, 0), Offset(rmeasurement[measurement.indexOf(e)].dx, 0)).length() / 1000).toStringAsFixed(2)}',
//                                                           style: TextStyle(color: Colors.red, fontSize: 12),
//                                                         ),
//                                                         Text(
//                                                           'Y :${(Line(Offset(0, rmeasurement[measurement.indexOf(e) - 1].dy), Offset(0, rmeasurement[measurement.indexOf(e)].dy)).length() / 1000).toStringAsFixed(2)}',
//                                                           style:
//                                                           TextStyle(color: Colors.blue, fontSize: 12),
//                                                         )
//                                                       ],
//                                                       mainAxisSize: MainAxisSize.min,
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ))))
//                                         .toList(),
//                                   )
//                                       : Container(),
//                                 ],
//                               );
//                             })
//                             : Container(),
//
//                         ///커스텀페인터 그리드 및 교점
//                         //   context.watch<Current>().getDrawing().scale != '1'
//                         //       ? Container(
//                         //           child: StreamBuilder<PhotoViewControllerValue>(
//                         //             stream: _pContrl.outputStateStream,
//                         //                   initialData: PhotoViewControllerValue(
//                         //                     position: Offset(0,0),
//                         //                     rotation: 0,
//                         //                     rotationFocusPoint: null,
//                         //                     scale: 1,
//                         //                   ),
//                         //               builder: (context, snapshot2) {
//                         //               return CustomPaint(
//                         //                 painter: GridMaker(
//                         //                   snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList(),
//                         //                   double.parse(context.watch<Current>().getDrawing().scale) * 421,
//                         //                   _origin,
//                         //                   pointList: _iPs,
//                         //                   deviceWidth: width,
//                         //                   cordinate: context.watch<Current>().getcordiOffset(width, height),
//                         //                   sS: snapshot2.data.scale,
//                         //                   x: keyX*width,
//                         //                   y: keyY*height ,
//                         //                 ),
//                         //               );
//                         //             }
//                         //           ),
//                         //         )
//                         //       : Container(),
//
//                         // 도면 정보 스케일 위젯
//                         ///도면 상세정보
//                         // StreamBuilder<PhotoViewControllerValue>(
//                         //     stream: _pContrl.outputStateStream,
//                         //     builder: (context, snapshot) {
//                         //       if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//                         //       return snapshot.data.scale < 12 ? planInfo(context) : detailInfo(context);
//                         //     }),
//                         ///Memo 구현
//                         StreamBuilder<PhotoViewControllerValue>(
//                             stream: _pContrl.outputStateStream,
//                             initialData: PhotoViewControllerValue(
//                               position: _pContrl.position,
//                               rotation: 0,
//                               rotationFocusPoint: null,
//                               scale: _pContrl.scale,
//                             ),
//                             builder: (context, snapshot) {
//                               return Stack(
//                                 children: memoList.map((e) {
//                                   double rx = e.origin.dx / context.watch<Current>().getcordiX() * width;
//                                   double ry = e.origin.dy / context.watch<Current>().getcordiX() * width;
//                                   double x = context.watch<Current>().getcordiOffset(width, height).dx;
//                                   double y = context.watch<Current>().getcordiOffset(width, height).dy;
//                                   Offset rOffset = Offset(rx + x, ry + y);
//
//                                   return Positioned.fromRect(
//                                       rect: Rect.fromCenter(center: rOffset, width: 100, height: 100),
//                                       child: Transform.scale(
//                                           scale: 1 / snapshot.data.scale,
//                                           child: Icon(
//                                             CommunityMaterialIcons.check,
//                                             color: e.check ? Colors.red : Colors.black,
//                                             size: 32,
//                                           )));
//                                 }).toList(),
//                               );
//                             }),
//
//                         ///CallOut 바운더리 구현
//                         callOutLayerOn == true
//                             ? Stack(
//                           children: context.watch<Current>().getDrawing().callOutMap.map((e) {
//                             double l = e['bLeft'] / context.watch<Current>().getcordiX() * width;
//                             double t = e['bTop'] / context.watch<Current>().getcordiX() * width;
//                             double r = e['bRight'] / context.watch<Current>().getcordiX() * width;
//                             double b = e['bBottom'] / context.watch<Current>().getcordiX() * width;
//                             double x = context.watch<Current>().getcordiOffset(width, height).dx;
//                             double y = context.watch<Current>().getcordiOffset(width, height).dy;
//                             return Positioned.fromRect(
//                               rect: Rect.fromLTRB(
//                                 l + x,
//                                 t + y,
//                                 r + x,
//                                 b + y,
//                               ),
//                               child: GestureDetector(
//                                 onLongPress: () {
//                                   callOutLayerOn = false;
//                                   count = [];
//                                   tracking = [];
//                                   Drawing select = drawings.singleWhere((v) => v.drawingNum == e['name']);
//                                   context.read<Current>().changePath(select);
//                                   recaculate();
//                                   setState(() {});
//                                 },
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Container(
//                                     color: Color.fromRGBO(255, 0, 0, 0.15),
//                                     child: Center(
//                                         child: AutoSizeText(
//                                           e['name'],
//                                           maxLines: 1,
//                                           minFontSize: 0,
//                                           // minFontSize: ,
//                                         )),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         )
//                             : Container(),
//
//                         ///RoomTag구현
//                         callOutLayerOn == true
//                             ? Stack(
//                           children: context.watch<Current>().getDrawing().roomMap.map((e) {
//                             double l = e['bLeft'] / context.watch<Current>().getcordiX() * width;
//                             double t = e['bTop'] / context.watch<Current>().getcordiX() * width;
//                             double r = e['bRight'] / context.watch<Current>().getcordiX() * width;
//                             double b = e['bBottom'] / context.watch<Current>().getcordiX() * width;
//                             double x = context.watch<Current>().getcordiOffset(width, height).dx;
//                             double y = context.watch<Current>().getcordiOffset(width, height).dy;
//                             return Positioned.fromRect(
//                               rect: Rect.fromLTRB(
//                                 l + x,
//                                 t + y,
//                                 r + x,
//                                 b + y,
//                               ),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     print(e['name']);
//                                     selectRoom = interiorList
//                                         .where((r) =>
//                                     r.roomNum.contains(e['id']) || r.roomName.contains(e['name']))
//                                         .toList();
//                                   });
//                                 },
//                                 child: Container(
//                                   color: Color.fromRGBO(0, 0, 255, 0.3),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         )
//                             : Container(),
//                         pointer == false
//                             ? CustomPaint(
//                           painter: CrossHairPaint(hover, s: _pContrl.scale),
//                           // painter: CrossHairPaint(hover,width: context.size.width,height: context.size.height),
//                         )
//                             : Container(),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 ///외각가리기
//                 // StreamBuilder<PhotoViewControllerValue>(
//                 //   stream: _pContrl.outputStateStream,
//                 //     initialData: PhotoViewControllerValue(
//                 //       position: _pContrl.position,
//                 //       rotation: 0,
//                 //       rotationFocusPoint: null,
//                 //       scale: _pContrl.scale,
//                 //     ),
//                 //     builder: (context, snapshot) {
//                 //     return Positioned.fromRect(rect: Rect.fromCenter(
//                 //         center: Offset(c.maxWidth / 2 - keyX * c.maxWidth, height / 2 - keyY * height),
//                 //         width: (c.maxWidth * 0.95+70)/snapshot.data.scale ,
//                 //         height: (c.maxHeight * 0.92 + 80) / snapshot.data.scale,
//                 //       ),
//                 //       child: Container(
//                 //         width: (c.maxWidth * 0.95+70)/snapshot.data.scale ,
//                 //         height: (c.maxHeight * 0.92 + 80) / snapshot.data.scale,
//                 //         decoration: BoxDecoration(border: Border.all(width: 70/snapshot.data.scale,color: Color.fromRGBO(255, 255, 255, 0.0))),
//                 //       ),
//                 //     );
//                 //   }
//                 // ),
//
//                 StreamBuilder<PhotoViewControllerValue>(
//                     stream: _pContrl.outputStateStream,
//                     initialData: PhotoViewControllerValue(
//                       position: _pContrl.position,
//                       rotation: 0,
//                       rotationFocusPoint: null,
//                       scale: _pContrl.scale,
//                     ),
//                     builder: (context, snapshot) {
//                       gridIntersection(snapshot, c, width, c.maxHeight);
//                       return moving == false && _offset == Offset.zero
//                           ? Stack(
//                           children: bb.map((e) {
//                             return Positioned.fromRect(
//                               rect: Rect.fromCenter(center: e.p, width: 40, height: 40),
//                               child: Transform.scale(
//                                 scale: 1 / snapshot.data.scale,
//                                 child: Container(
//                                     width: 50,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                         color: Color.fromRGBO(0, 0, 0, 0.4),
//                                         // border: Border.all(color: Color.fromRGBO(0, 0, 0, 1.0),width: 1.2),
//                                         borderRadius: BorderRadius.circular(100)),
//                                     child: Center(
//                                         child: Text(
//                                           e.name.replaceAll('-', ''),
//                                           textScaleFactor: 0.9,
//                                           style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
//                                         ))),
//                               ),
//                             );
//                           }).toList())
//                           : Container();
//                     }),
//                 StreamBuilder<PhotoViewControllerValue>(
//                     stream: _pContrl.outputStateStream,
//                     initialData: PhotoViewControllerValue(
//                       // position: _pContrl.position,
//                       rotation: 0,
//                       rotationFocusPoint: null,
//                       scale: _pContrl.scale,
//                     ),
//                     builder: (context, snapshot) {
//                       gridIntersection(snapshot, c, width, c.maxHeight);
//                       return moving == false && _offset == Offset.zero
//                           ? Stack(
//                           children: sectionGrid.map((e) {
//                             return Positioned.fromRect(
//                               rect: Rect.fromCenter(center: e.p, width: 40, height: 40),
//                               child: Transform.scale(
//                                 scale: 1 / snapshot.data.scale,
//                                 child: InkWell(
//                                   onTap: () {
//                                     context
//                                         .read<Current>()
//                                         .changePath(drawings.singleWhere((t) => t.drawingNum == e.name));
//                                   },
//                                   child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(100),
//                                       child: Container(
//                                           color: Colors.blue,
//                                           child: Center(
//                                               child: Text(
//                                                 e.name,
//                                                 textScaleFactor: 0.5,
//                                                 style: TextStyle(color: Colors.white),
//                                               )))),
//                                 ),
//                               ),
//                             );
//                           }).toList())
//                           : Container();
//                     })
//               ],
//             );
//           }),
//         ),
//       ),
//     ),
//   );
// }
