import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/standard_detail_class.dart';
import 'package:get/get.dart';

class StandardDetailPage extends StatefulWidget {
  List<StandardDetail> std;

  StandardDetailPage(this.std);

  @override
  _StandardDetailPageState createState() => _StandardDetailPageState();
}

class _StandardDetailPageState extends State<StandardDetailPage> {
  List<String> categorys;
  List<String> subCategorys;
  TextEditingController _textEditingController = TextEditingController();
  bool search =false;
  String st ='';

  @override
  void initState() {
    super.initState();
    categorys = widget.std.map((e) => e.category).toSet().toList();
    subCategorys = widget.std.map((e) => e.subCategory).toSet().toList();
    print(subCategorys);
    print(categorys);
    print(categorys.length);
  }
  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: TextField(
            onChanged: (t){
              setState(() {
                st = t;
                t.length==0?search=false:search=true;
              });
            },
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '검색어를 입력해주세요',
              )
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView(
              children: categorys.map((e){
                if (widget.std
                    .where((b) =>
                b.category == e &&
                    b.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")))
                    .length !=
                    0)
                return ExpansionTile(
                  // initiallyExpanded: search,
                  title: Text(e.toString()),
                  children:subCategorys
                      .map((s)  {
                              if (widget.std
                                      .where((b) =>
                                          b.category == e &&
                                          b.subCategory == s &&
                                          b.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")))
                                      .length !=
                                  0) {
                                return ExpansionTile(
                                  initiallyExpanded: search,
                                  title: Text(s),
                                  leading: Text(widget.std
                                      .where((b) =>
                                          b.category == e &&
                                          b.subCategory == s &&
                                          b.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")))
                                      .length
                                      .toString()),
                                  children: widget.std
                              .where((t) => t.category == e&& t.subCategory==s)
                              .where((s) => s.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")))
                              .map((a) => ListTile(
                            title: Text(a.name.replaceAll("\n", "")),
                            trailing: Text(a.path.replaceAll(".png", "")),
                            onTap: () {
                              setState(() {
                                Get.defaultDialog(
                                    title: a.toString(),
                                    content: Image.asset(
                                      'asset/standarddetail/${a.path}',
                                      fit: BoxFit.fitHeight,
                                      height: 800,
                                    ));
                              });
                            },
                          ))
                              .toList(),
                          );}}).where((element) => element!=null)
                      .toList(),
                );}
              ).where((element) => element!=null).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
