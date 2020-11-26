import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';

class GridList extends StatefulWidget {
  List<Grid> _grid;
  GridList(this._grid);

  @override
  _GridListState createState() => _GridListState();
}

class _GridListState extends State<GridList> {
  List<bool> _select;
  Grid _selectGrid ;
  @override
  void initState() {
    super.initState();
    _select = List.filled(widget._grid.length, false);
    _selectGrid = widget._grid[0];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                  children: widget._grid
                      .map(
                        (e) {
                          bool select = false;
                          return Card(
                            child: RadioListTile(
                              title: Text(e.toString()),
                              value: e,
                              groupValue: _selectGrid,
                              onChanged: (value){
                                setState(() {
                                  _selectGrid = value;
                                });
                              },
                            ),
                          );
                        }
                      )
                      .toList()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _selectGrid);
                },
                child: ListTile(
                  title: Text('선택 합니다.'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
