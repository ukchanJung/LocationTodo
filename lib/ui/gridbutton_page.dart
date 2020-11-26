
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/ui/gridlist_page.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';

class GridButton extends StatefulWidget {
  @override
  _GridButtonState createState() => _GridButtonState();
}

class _GridButtonState extends State<GridButton> {
  List<Grid> grids = [];
  Offset _origin = Offset(50, 50);
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _distanceControl = TextEditingController();
  String dropdownValue = 'One';
  Grid select;
  @override
  void initState() {
    super.initState();
    grids.addAll([
      Grid('X1',origin: _origin,x: 0),
      Grid('Y0',origin: _origin,y: 0),
    ]
    );
  }
  void dispose() {
    super.dispose();
    _nameControl.dispose();
    _distanceControl.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('그리드 버튼'),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            select.name.contains('X')
                ?grids.add(Grid(_nameControl.text, origin: _origin, x: select.x + int.parse(_distanceControl.text)))
                :grids.add(Grid(_nameControl.text, origin: _origin, y: select.y + int.parse(_distanceControl.text)));
            select = grids.last;
            });
        },
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: GridMaker(grids),
                ),
              ),
              Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: grids.map((e) => Text('${e.name}은''${e.x}''${e.y}')).toList()
              ),
            ),
              Card(
                elevation: 4,
                child: ListTile(
                  title: select == null ? Text('그리드를 선택해주세요') : Text(select.toString()),
                  onTap: ()async{
                    Grid _select;
                    _select =  await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GridList(grids)),);
                    setState(() {
                      select = _select;
                    });
                  },
                ),
              ),
              Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nameControl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '그리드 이름',
                      ),
                    ),
                  ),
                ),
                  Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _distanceControl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '거리',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      )
    );
  }
}
