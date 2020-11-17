class Task {
  String name;
  DateTime start;
  DateTime end;
  String memo;
  bool ischecked = false;
  bool favorite = false;

  Task({this.name = '메모', this.start, this.end, this.memo});
}