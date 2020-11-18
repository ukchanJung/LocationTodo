class Task {
  String name;
  DateTime start;
  DateTime end;
  DateTime writeTime;
  String memo;
  bool ischecked = false;
  bool favorite = false;

  Task(this.writeTime,{this.name = '메모', this.start, this.end, this.memo});
}