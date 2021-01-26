import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:photo_view/photo_view.dart';

class PlaySimul extends StatefulWidget {
  @override
  _PlaySimulState createState() => _PlaySimulState();
}

class _PlaySimulState extends State<PlaySimul> {
  List<Drawing> drawings = [];
  Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
  List<Widget> temp;

  @override
  void initState() {
    super.initState();
    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    temp = drawings
        .sublist(150, 164)
        .map(
          (e) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(0)
          ..rotateX(-0.8)
          ..rotateY(0),
        origin: Offset(750, 300),
        child: Center(
          child: Card(
            child: Container(
              width: 840,
              height: 594,
              child: ClipRect(child: PhotoView.customChild(child: Image.asset('asset/photos/${e.localPath}'))),
            ),
          ),
        ),
      ),
    )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('4D시뮬레이션 테스트'),
      ),
      body: FutureBuilder(
          future: watch,
          builder: (context, snapshot) {
            return Center(
              child: SingleChildScrollView(
                child: CarouselSlider(
                  options: CarouselOptions(
                    disableCenter: true,
                    initialPage: 0,
                    scrollDirection: Axis.vertical,
                    autoPlay:true
                  ),
                  items: temp,
                ),
              ),
            );
          }),
    );
  }
}
