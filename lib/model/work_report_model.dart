import 'dart:math';

class WorkReport{
  String title;
  String uid;
  DateTime modifyTime;
  DateTime writeTime;
  String memo;
  List<String> participated;

  WorkReport({ this.title, this.uid, this.modifyTime, this.writeTime, this.memo, this.participated });
}
