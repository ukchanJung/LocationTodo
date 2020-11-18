
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/ui/location_image_page.dart';
import 'package:intl/intl.dart';

class LocationTodo extends StatefulWidget {

  @override
  _LocationTodoState createState() => _LocationTodoState();
}

class _LocationTodoState extends State<LocationTodo> {
  List<Task> tasks =[];
  TextEditingController _textEditingController = TextEditingController();
  bool _ischecked =false;
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yy.MM.dd');
  bool _doneListOpen = false;
  List<bool> togleSelect = [false];
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
        title: Text('LTD Inbox'),
        actions: [
          Container(width:72,child: TextField(),),
        ],
      ),
      //리스트 초기화 임시버튼
      floatingActionButton: FloatingActionButton(
        onPressed:(){
         setState(() {
           tasks=[];
         });
        } ,
      ),
      body: Column(
        children: [
          //위치 표현 이미지 위젯
          LocationImage(),
          // AspectRatio활용하여 이미지 사이즈 변경 기능 추가예정
          Divider(thickness: 3,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildTodoAddUI(),
          ) ,
          buildTodoList(),
          Divider(color: Colors.grey,),
          ToggleButtons(
            children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 144,
                  child: Center(
                    child: Text('완료한 Task',textScaleFactor: 1.2,),
                  ),
                ),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                togleSelect[index] = !togleSelect[index];
              });
            },
            isSelected: togleSelect,
          ),
          togleSelect[0] == true
          ? Container()
          : buildDoneList(),
          SizedBox(height: 24.0,),
        ],
      ),
    );
  }

  Widget buildTodoList() {  
    return Expanded(
          child: ListView(
            children: tasks.where((element) => element.ischecked == false)
                .map((e) => Card(
                  child: CheckboxListTile(
                    //체크박스 타일 위치 바꾸기
                        controlAffinity: ListTileControlAffinity.leading,
                        secondary: IconButton(
                          //즐겨찾기 기능구현
                          onPressed: (){
                            setState(() {
                              e.favorite = !e.favorite;
                            });
                          },
                          //3항 연산을 활용한 즐겨찾기 아이콘 변경
                          icon: e.favorite == false
                              ? Icon(Icons.star_border)
                              : Icon(Icons.star,color: Colors.red,),
                        ),
                        title: Row(
                          children: [
                            Text(e.name),
                            //수정일 배치를 위한 위젯
                            Expanded(child: SizedBox()),
                            Text(
                            formatter.format(e.writeTime),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                        ),
                        //체크박스 기능 구현
                        value: e.ischecked,
                        onChanged: (bool value){
                          setState(() {
                            e.ischecked = value;
                          });
                                },
                              ),
                  ),
                ) .toList(),
          ),
        );
  }
  Widget buildDoneList() {  
    return Expanded(
          child: ListView(
            children: tasks.where((element) => element.ischecked==true)
                .map((e) => Card(
                  child: CheckboxListTile(
                    //체크박스 타일 위치 바꾸기
                        controlAffinity: ListTileControlAffinity.leading,
                        secondary: IconButton(
                          //즐겨찾기 기능구현
                          onPressed: (){
                            setState(() {
                              e.favorite = !e.favorite;
                            });
                          },
                          //3항 연산을 활용한 즐겨찾기 아이콘 변경
                          icon: e.favorite == false
                              ? Icon(Icons.star_border)
                              : Icon(Icons.star,color: Colors.red,),
                        ),
                        title: Row(
                          children: [
                            Text(e.name,style: TextStyle(decoration: TextDecoration.lineThrough),),
                            //수정일 배치를 위한 위젯
                            Expanded(child: SizedBox()),
                            Text(
                            formatter.format(e.writeTime),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                        ),
                        //체크박스 기능 구현
                        value: e.ischecked,
                        onChanged: (bool value){
                          setState(() {
                            e.ischecked = value;
                          });
                                },
                              ),
                  ),
                ) .toList(),
          ),
        );
  }

  //TODO추가 기능
  Widget buildTodoAddUI() {
    return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'GTD',
                  ),
                ),
              ),
              SizedBox(width: 16,),
              ElevatedButton(
                child: Text('등록'),
                onPressed: () {
                  //메서드?를 UI에서분리해야될것 같음
                  setState(() {

                    tasks.add(Task(now,name: _textEditingController.text));
                    // 등록 버튼 클릭시 필드 초기화
                    _textEditingController.text = '';
                  });
                },
              )
            ],
          );
  }
}
