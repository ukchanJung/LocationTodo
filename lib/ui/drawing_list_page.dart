import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:get/get.dart';

class DrawingListPage extends StatefulWidget {
  List<Drawing> drawings;

  DrawingListPage(this.drawings);

  @override
  _DrawingListPageState createState() => _DrawingListPageState();
}

class _DrawingListPageState extends State<DrawingListPage> {
  List<String> category;

  @override
  void initState() {
    super.initState();
    category = widget.drawings.map((e) => e.doc).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: category.map((e) {
        List<Drawing> subList = widget.drawings.where((d) => d.doc == e).toList();
        return ListTile(
          title: Text(e),
          leading: Text(subList.length.toString()),
          onTap: (){
            Get.defaultDialog(
                title: e,
                content: Container(
                  height: 800,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: subList.map((a) => Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Chip(label: Text(a.toString())),
                      )).toList(),
                    ),
                  ),
                ));
          },
        );
      }).toList(),
    );
  }
}
