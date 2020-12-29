import 'package:flutter/material.dart';

class Planner extends StatefulWidget {
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  TextEditingController addContrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addContrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('플래너'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border(right: BorderSide())),
              child: ListView(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: addContrl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '작업을 입력해주세요',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('등록'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    children: [
                      ExpansionTile(
                        title: Text('d2'),
                        children: [
                          Container(height: 50,color: Colors.red,)
                        ],
                      )
                    ],
                    title: Text('D1'),
                    onExpansionChanged: (v){
                      print(v);
                    },
                    trailing: ElevatedButton(onPressed: () {  }, child: Text('추가'),),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  12,
                  (i) => Container(
                    width: 100,
                    decoration: BoxDecoration(border: Border(right: BorderSide())),
                    child: Center(child: Text('${i + 1}')),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Plan {
  List<Plan> lowPlan;
  DateTime start;
  DateTime end;
  bool isCheck = false;
  int id;
  String name;

  Plan({this.lowPlan, this.start, this.end});
}
