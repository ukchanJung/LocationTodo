import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchDialog extends StatefulWidget {
  List<Drawing> drawings ;

  SearchDialog(this.drawings);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          child: TextField(
            autofocus: true,
            onChanged: (_){
              setState(() {
              });
            },
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '도면을 검색해주세요',
            ),
          ),
        ),
        Container(
          width: 500,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              children: widget.drawings
                  .where((e) => e.toString().contains(_controller.text))
                  .map((e) => ListTile(
                        title: Text(e.toString()),
                    onTap: (){
                          context.read<CP>().changePath(e);
                          Navigator.pop(context);
                          },
                onLongPress: (){
                  context.read<CP>().changeLayer(e);
                  Navigator.pop(context);

                },
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
