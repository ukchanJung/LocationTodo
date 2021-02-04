class ConGInfo {
  // var index1;
  // var conType;
  // var page;
  // var index2;
  // var index3;
  // var index4;
  // var index5;
  // var index6;
  // var index7;
  // var path;
  int index1;
  String conType;
  int page;
  int index2;
  String index3;
  int index4;
  String index5;
  int index6;
  String index7;
  String path;
  String ocr;

  ConGInfo({
      this.index1, 
      this.conType, 
      this.page, 
      this.index2, 
      this.index3, 
      this.index4, 
      this.index5, 
      this.index6, 
      this.index7, 
      this.path});

  ConGInfo.fromJson(dynamic json) {
    index1 = json["index1"];
    conType = json["conType"];
    page = json["page"];
    index2 = json["index2"];
    index3 = json["index3"];
    index4 = json["index4"];
    index5 = json["index5"];
    index6 = json["index6"];
    index7 = json["index7"];
    path = json["path"];
  }
  ConGInfo.fromMap(map) {
    index1 = map['index1'];
    conType = map['conType'];
    page = map['page'];
    index2 = map['index2'];
    index3 = map['index3'];
    index4 = map['index4'];
    index5 = map['index5'];
    index6 = map['index6'];
    index7 = map['index7'];
    path = map['path'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["index1"] = index1;
    map["conType"] = conType;
    map["page"] = page;
    map["index2"] = index2;
    map["index3"] = index3;
    map["index4"] = index4;
    map["index5"] = index5;
    map["index6"] = index6;
    map["index7"] = index7;
    map["path"] = path;
    return map;
  }

  @override
  String toString() {
    return '${index1}.${conType} ${index2}.${index3} ${index4} ${index5}';
  }
  // @override
  // String toString() {
  //   return 'ConGInfo{index1: $index1, conType: $conType, page: $page, index2: $index2, index3: $index3, index4: $index4, index5: $index5, index6: $index6, index7: $index7 }';
  // }
}