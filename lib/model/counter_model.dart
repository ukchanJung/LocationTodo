import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/ui/planner_page.dart';

class DivideCounter with ChangeNotifier{
  List<PlanGant> gants=[PlanGant(),PlanGant()];
  int value =2;
  int getValue()=>value;
  void up (){
    value++;
    gants.add(PlanGant());
    notifyListeners();
  }
}
