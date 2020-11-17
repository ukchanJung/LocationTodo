import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/ui/location_image_page.dart';

class LocationTodo extends StatefulWidget {

  @override
  _LocationTodoState createState() => _LocationTodoState();
}

class _LocationTodoState extends State<LocationTodo> {
  List<Task> tasks =[];
  TextEditingController _textEditingController = TextEditingController();
  bool _ischecked =false;

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
          Expanded(
            child: ListView(
              children: tasks
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
                          title: Text(e.name),
                          value: e.ischecked,
                          onChanged: (bool value){
                    setState(() {
                      e.ischecked = value;
                    });
                          },
                        ),
                  ))
                  .toList(),
            ),
          )
        ],
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
                    tasks.add(Task(name: _textEditingController.text));
                    _textEditingController.text = '';
                  });
                },
              )
            ],
          );
  }
}
