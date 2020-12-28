import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class BoundayDetail extends StatefulWidget {
  List<Task> boundaryTasks;

  BoundayDetail(this.boundaryTasks);

  @override
  _BoundayDetailState createState() => _BoundayDetailState();
}

class _BoundayDetailState extends State<BoundayDetail> {
  PhotoViewController _viewController = PhotoViewController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _viewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('바운더리 디테일 페이지'),
      ),
      body: Column(
        children: [
          TimViewer(viewController: _viewController),
          Expanded(
            child: ListView(
              children: widget.boundaryTasks
                  .map((e) => ListTile(
                        title: Text(e.name),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class TimViewer extends StatelessWidget {
  const TimViewer({
    Key key,
    PhotoViewController viewController,
  })  : _viewController = viewController,
        super(key: key);

  final PhotoViewController _viewController;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 421 / 297,
      child: ClipRect(
        child: PhotoView.customChild(
          controller: _viewController,
          initialScale: 1.0,
          minScale: 1.0,
          maxScale: 5.0,
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
          child: Image.asset(context.watch<Current>().getDrawing().localPath),
        ),
      ),
    );
  }
}
