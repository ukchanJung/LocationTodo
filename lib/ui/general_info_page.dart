import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/construc_general_info.dart';
import 'package:flutter_app_location_todo/data/structureJson.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GeneralInfo extends StatefulWidget {
  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  List<ConGInfo> infos;
  List infodatas;
  bool a = false;
  TextEditingController _textEditingController;
  List<String> data;
  String aa;
  String search = '일반사항';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    infos = structureJson.map((e)=>ConGInfo.fromMap(e)
   ).toList();
    void readingInfo() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot read = await _db.collection('generalInfo').get();
    infodatas = read.docs;
    infodatas.forEach((e){
    });
    //그리드를 통한 교차점 확인
    //TODO 실시간 연동 바운더리
    }

    readingInfo();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시방서'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          infos.forEach(print);
          setState(() {
            data = infodatas.map((e) => "{'path' : '${e['path']}'},{'fulltext' : '${e['fulltext'].replaceAll(' ','').replaceAll('\n','')}'}").toList();
            a =true;
            // _textEditingController.text =infodatas.toString();
          });
        },
      ),

      // body: a == false
      //   ?Container()
      //     :SingleChildScrollView(child: SelectableText(data.toString()))
      body: a == false
        ?Container()
      :Column(
        children: [
          Container(
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    height: 80,
                    child: TextField(controller: _textEditingController,
                    ),
                  )
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    search = _textEditingController.text;
                  });
                },child: Text('검색'),)
              ],
            ),
          ),
          Expanded(
            child: ListView(
                    children: infodatas
                        .where((e) => e['fulltext'].replaceAll(' ','').contains(search.replaceAll(' ', '')))
                        .map((t) => Column(
                      mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text(infos.singleWhere((v) => v.path==t['path']).toString()),
                                ),
                                Divider(),
                                Image.asset('asset/structure/${t['path']}'),
                                Divider(),
                              ],
                            )).toList()
            ),
          ),
        ],
      ),
      // body: Expanded(
      //   child: ListView(
      //     children: infos.map((e) => ListTile(title: Text(e.path),)).toList(),
      //   ),
      // ),
      // body: StaggeredGridView.countBuilder(
      //   crossAxisCount: 4,
      //   itemCount: infos.length,
      //   itemBuilder: (context, index) => Expanded(child: Image.asset('asset/structure/$index.png')),
      //   // itemBuilder: (context, index) => Expanded(child: Image.asset('asset/structure/${infos[index].path}')),
      //   // staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
      // ),
    );
  }
}
