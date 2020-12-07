import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:provider/provider.dart';

import 'boundary_detail_page.dart';

class TimView extends StatefulWidget {
  @override
  _TimViewState createState() => _TimViewState();
}

class _TimViewState extends State<TimView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIMVIEW'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
      ),
      body: Column(
        children: [
          TimViewer(),
        ],
      ),
    );
  }
}
