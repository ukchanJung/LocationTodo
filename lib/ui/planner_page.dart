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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: addContrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '작업을 입력해주세요',
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
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
