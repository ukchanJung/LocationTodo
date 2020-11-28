
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/ui/gridlist_page.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

void write()async{
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = await _db.collection('gridList');
  dbGrid.doc('test').set({
    'name' : 'X1',
    'x' : 7500.0,
  });
}

void writeX(String name, num cordinate)async{
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = await _db.collection('gridList');
  dbGrid.doc(name).set({
    'name' : name,
    'x' : cordinate,
  });
}

void writeY(String name, num cordinate)async{
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = await _db.collection('gridList');
  dbGrid.doc(name).set({
    'name' : name,
    'y' : cordinate,
  });
}

void updateX(String name, num cordinate)async{
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = _db.collection('gridList');
  dbGrid.doc(name).update({
    'name' : name,
    'x' : cordinate,
  });
}

class GridButton extends StatefulWidget {
  @override
  _GridButtonState createState() => _GridButtonState();
}
class _GridButtonState extends State<GridButton> {
  List<Grid> grids = [];
  Offset _origin ;
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _distanceControl = TextEditingController();
  String dropdownValue = 'One';
  Grid select;
  // FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read;
  @override
  void initState() {
    super.initState();
    // grids.addAll([
    //   Grid('X1',x: 0),
    //   Grid('Y0',y: 0),
    // ]
    // );
    void reading()async{
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('gridList').get();
      grids = read.docs.map((e) => Grid.fromSnapshot(e)).toList();
    }
    reading();
    print(grids);
  }
  void dispose() {
    super.dispose();
    _nameControl.dispose();
    _distanceControl.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('그리드 버튼'),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gridList').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return SafeArea(child: Center(child: CircularProgressIndicator()));
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 400,
                          height: 300,
                          child: PositionedTapDetector(
                            onLongPress: (m){
                              print(m.relative.toString());
                              setState(() {
                              _origin =Offset(m.relative.dx, m.relative.dy);
                              });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 400,
                                  height: 300,
                                  child: CustomPaint(
                                    painter: GridMaker(snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList(), 250,_origin),
                                  ),
                                ),
                                Container(
                                  width: 400,
                                  height: 300,
                                  child: CustomPaint(),
                                )
                              ],
                            ),
                          ),
                        ),
                        // RawMaterialButton(onPressed: (){},child: Rect.,)
                      ],
                    ),
                  ),
                  Expanded(
                  child: ListView(
                    children: snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().map((e) => Text('${e.name}은''${e.x}''${e.y}')).toList()
                    // children: grids.map((e) => Text('${e.name}은''${e.x}''${e.y}')).toList()
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
                            MaterialPageRoute(builder: (context) => GridList(snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList())),);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: (){
                      updateX(_nameControl.text,select.x + int.parse(_distanceControl.text));
                      setState(() {
                        select = snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().firstWhere((e) => e.name.contains(_nameControl.text));
                      });
                    }, child: Text('수정하기'),style: ElevatedButton.styleFrom(primary: Colors.redAccent),),
                    ElevatedButton(onPressed: (){
                      writeX(_nameControl.text,int.parse(_distanceControl.text));
                      setState(() {
                        select = snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().firstWhere((e) => e.name.contains(_nameControl.text));
                      });
                    }, child: Text('추가하기')),
                    ElevatedButton(onPressed: (){
                      writeY(_nameControl.text,int.parse(_distanceControl.text));
                      setState(() {
                        select = snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().firstWhere((e) => e.name.contains(_nameControl.text));
                      });
                    }, child: Text('Y 추가하기')),
                  ],
                ),
              ],
            ),
          );
        }
      )
    );
  }
}
