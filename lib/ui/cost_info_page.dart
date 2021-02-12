import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/cost_info_model.dart';
import 'package:flutter_app_location_todo/model/standard_detail_class.dart';
import 'package:get/get.dart';

class CostInfoPage extends StatefulWidget {
  List<CostInfo> ci;

  CostInfoPage(this.ci);

  @override
  _CostInfoPageState createState() => _CostInfoPageState();
}

class _CostInfoPageState extends State<CostInfoPage> {
  List<String> _lc1;
  List<String> subCategorys;
  TextEditingController _textEditingController = TextEditingController();
  bool search = false;
  String st = '';
  List<CostInfo> data;

  @override
  void initState() {
    super.initState();
    // categorys = widget.std.map((e) => e.category).toSet().toList();
    // subCategorys = widget.std.map((e) => e.subCategory).toSet().toList();
    _lc1 = widget.ci.map((e) => e.index1).toSet().toList();
    data = widget.ci;
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
              onChanged: (t) {
                setState(() {
                  st = t;
                  t.length == 0 ? search = false : search = true;
                });
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '검색어를 입력해주세요',
              )),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView(
              children: _lc1.map((a) {
                List<CostInfo> _c2 = data
                    .where((s) {
                      if (s.index4 != null) {
                        return s.index1.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index2.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index4.toString().replaceAll(" ", "").contains(st.replaceAll(" ", ""));
                      } else if (s.index5 != null) {
                        return s.index1.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index2.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index4.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index5.toString().replaceAll(" ", "").contains(st.replaceAll(" ", ""));
                      } else if (s.index6 != null) {
                        return s.index1.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index2.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index4.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index5.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index6.toString().replaceAll(" ", "").contains(st.replaceAll(" ", ""));
                      }
                      return true;
                    })
                    .where((e) => e.index1 == a)
                    .toSet()
                    .toList();
                List<String> _c2n = data
                    .where((s) {
                      if (s.index4 != null) {
                        return s.index1.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index2.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index4.toString().replaceAll(" ", "").contains(st.replaceAll(" ", ""));
                      } else if (s.index5 != null) {
                        return s.index1.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index2.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index4.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index5.toString().replaceAll(" ", "").contains(st.replaceAll(" ", ""));
                      } else if (s.index6 != null) {
                        return s.index1.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index2.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index4.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index5.toString().replaceAll(" ", "").contains(st.replaceAll(" ", "")) ||
                            s.index6.toString().replaceAll(" ", "").contains(st.replaceAll(" ", ""));
                      }
                      return true;
                    })
                    .where((e) => e.index1 == a)
                    .map((e) => e.index2)
                    .toSet()
                    .toList();
                return ExpansionTile(
                  title: AutoSizeText(a),
                  initiallyExpanded: search,
                  children: _c2n.map((b) {
                    List<CostInfo> _c3 = _c2.where((e) => e.index2 == b).toList();
                    List<String> _c3n = _c3.where((e) => e.index2 == b).map((e) => e.index4).toSet().toList();
                    return ExpansionTile(
                      title: AutoSizeText('  $b'),
                      // initiallyExpanded: search,
                      children: [
                        // Image.asset('asset/costinfo/${_c2.singleWhere((e) =>e.index2==b).index4Path}'),
                        ..._c3n
                            .map((c) {
                              List<CostInfo> _c4 = _c3.where((e) => e.index4 == c).toList();
                              List<String> _c4n = _c4.where((e) => e.index4 == c).map((e) => e.index5).toSet().toList();
                              String p4 = _c4.firstWhere((e) => e.index4 == c).index4Path;
                              if (c != null)
                                return ExpansionTile(
                                  title: AutoSizeText('    $c'),
                                  // initiallyExpanded: search,
                                  children: [
                                    p4 != null
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                            child: Image.asset(
                                              'asset/costinfo/$p4.png',
                                              fit: BoxFit.fitWidth,
                                              errorBuilder: (context, error, stackTrace) => Container(),
                                            ),
                                          )
                                        : Container(),
                                    ..._c4n
                                        .map((d) {
                                          List<CostInfo> _c5 = _c4.where((e) => e.index5 == d).toList();
                                          List<String> _c5n =
                                              _c5.where((e) => e.index5 == d).map((e) => e.index6).toSet().toList();
                                          String p5 = _c5.firstWhere((e) => e.index5 == d).index5Path;
                                          if (d != null)
                                            return ExpansionTile(
                                              title: AutoSizeText('      $d'),
                                              // initiallyExpanded: search,
                                              children: [
                                                p5 != null
                                                    ? Padding(
                                                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                                        child: Image.asset(
                                                          'asset/costinfo/$p5.png',
                                                          fit: BoxFit.fitWidth,
                                                          errorBuilder: (context, error, stackTrace) => Container(),
                                                        ),
                                                      )
                                                    : Container(),
                                                ..._c5n
                                                    .map((f) {
                                                      List<CostInfo> _c6 = _c5.where((e) => e.index6 == f).toList();
                                                      List<String> _c6n = _c6
                                                          .where((e) => e.index6 == f)
                                                          .map((e) => e.index7)
                                                          .toSet()
                                                          .toList();
                                                      String p6 = _c6.firstWhere((e) => e.index6 == f).index6Path;
                                                      if (f != null)
                                                        return ExpansionTile(
                                                          title: AutoSizeText('        $f'),
                                                          // initiallyExpanded: search,
                                                          children: [
                                                            p6 != null
                                                                ? Padding(
                                                                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                                                    child: Image.asset(
                                                                      'asset/costinfo/$p6.png',
                                                                      fit: BoxFit.fitWidth,
                                                                      errorBuilder: (context, error, stackTrace) =>
                                                                          Container(),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                            ..._c6n
                                                                .map((g) {
                                                                  if (g != null)
                                                                    return ListTile(
                                                                      title: AutoSizeText('          $g'),
                                                                    );
                                                                })
                                                                .where((em) => em != null)
                                                                .toList(),
                                                          ],
                                                        );
                                                    })
                                                    .where((em) => em != null)
                                                    .toList(),
                                              ],
                                            );
                                        })
                                        .where((em) => em != null)
                                        .toList(),
                                  ],
                                );
                            })
                            .where((em) => em != null)
                            .toList()
                      ],
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
        // Expanded
      ],
    );
  }
}
