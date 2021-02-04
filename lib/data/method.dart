import 'package:flutter_app_location_todo/data/grid_data.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';

List<Gridtestmodel> fechGrid(){
  return gridData.map((e) => Gridtestmodel.map(e)).toList();
}