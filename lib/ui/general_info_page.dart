import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/construc_general_info.dart';
import 'package:flutter_app_location_todo/data/structureJson.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class GeneralInfo extends StatefulWidget {
  List<ConGInfo> infos;

  GeneralInfo(this.infos);

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  List infodatas;
  bool a = false;
  List<String> data;
  String aa;
  String search = '일반사항';
  List<String> category;
  List<String> category2;
  List<Map> category3;

  @override
  void initState() {
    super.initState();
    category = widget.infos.map((e) => e.conType).toSet().toList();
  }


  Color temp(String t) {
    if (t.contains("#")) {
      return Colors.amber;
    } else if (t.contains('@')) {
      return Colors.pinkAccent;
    } else if (t.contains('!')) {
      return Colors.green;
    } else
      Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 1000,
      itemCount: category.length,
      itemBuilder: (context, index) {
        bool _temp2 = false;
        List<ConGInfo> subInfo=widget.infos.where((b) => b.conType == category[index] && b.index7 == 'text').toList();
        List<ConGInfo> Test=widget.infos.where((b) => b.conType == category[index]).toList();

        return ExpansionTile(
          title: Text(category[index]),
          onExpansionChanged: (_) {
            setState(() {
              _temp2 = !_temp2;
            });
          },
            children:_temp2
                ?[]
                :subInfo.map(
                  (c) {
                bool _temp = false;
                List<ConGInfo> _tempG = Test.where((e) => e.toDif() == c.toDif() && e.index7 != 'text').toList();
                List<String> _tempL =
                Test.where((e) => e.toDif() == c.toDif() && e.index7 != 'text').map((e) => e.index7).toSet().toList();
                // print(c.index4);
                String data = c.index4 != 0 ? c.toString() : '${c.index1}.${c.conType} ${c.index2}.${c.index3}';
                // print('[${c.index4!=0}]$data');
                return ExpansionTile(
                  title: Text(data),
                  children: _temp == true
                      ? []
                      : [
                    Container(
                      child: Image.asset('asset/structure/${c.path}'),
                    ),
                    Wrap(
                      children: _tempL.map((e) {
                        return InkWell(
                          onTap: () {
                            Get.defaultDialog(
                                content: Container(
                                  height: 800,
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                        children: _tempG
                                            .where((y) => y.index7 == e)
                                            .map((z) => Image.asset(
                                          'asset/structure/${z.path}',
                                          height: 270,
                                        ))
                                            .toList()),
                                  ),
                                ));
                          },
                          child: Chip(
                            label: Text(e.substring(1)),
                            backgroundColor: temp(e),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  onExpansionChanged: (_) {
                    setState(() {
                      _temp = !_temp;
                    });
                  },
                );
              },
            ).toList(),
        );
      },
    );
  }
}

class GeneralInfoDetailPage extends StatefulWidget {
  List<ConGInfo> temp;

  GeneralInfoDetailPage({this.temp});

  @override
  _GeneralInfoDetailPageState createState() => _GeneralInfoDetailPageState();
}

class _GeneralInfoDetailPageState extends State<GeneralInfoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.temp
            .map(
              (e) => ExpansionTile(
                title: Text(e.toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}
