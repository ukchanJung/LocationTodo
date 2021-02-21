class InteriorIndex {
  String floor;
  String category;
  String roomNum;
  String roomName;
  String fBackground;
  String fFin;
  String fThk;
  String bBBackground;
  String bBFin;
  String bBThk;
  String wBackground;
  String wFin;
  String cBackground;
  String cFin;
  String cLevel;
  List fwDetail;
  List cwDetail;

  InteriorIndex({
    this.floor,
    this.category,
    this.roomNum,
    this.roomName,
    this.fBackground,
    this.fFin,
    this.fThk,
    this.bBBackground,
    this.bBFin,
    this.bBThk,
    this.wBackground,
    this.wFin,
    this.cBackground,
    this.cFin,
    this.cLevel,
    this.fwDetail,
    this.cwDetail,
  });

  InteriorIndex.fromJson(dynamic json) {
    floor = json["floor"];
    category = json["category"];
    roomNum = json["roomNum"];
    roomName = json["roomName"];
    fBackground = json["fBackground"];
    fFin = json["fFin"];
    fThk = json["fThk"];
    bBBackground = json["bBBackground"];
    bBFin = json["bBFin"];
    bBThk = json["bBThk"];
    wBackground = json["wBackground"];
    wFin = json["wFin"];
    cBackground = json["cBackground"];
    cFin = json["cFin"];
    cLevel = json["cLevel"];
    fwDetail = json["fwDetail"];
    cwDetail = json["cwDetail"];
  }
  InteriorIndex.fromMap(Map map) {
    floor = map["floor"];
    category = map["category"];
    roomNum = map["roomNum"];
    roomName = map["roomName"];
    fBackground = map["fBackground"];
    fFin = map["fFin"];
    fThk = map["fThk"];
    bBBackground = map["bBBackground"];
    bBFin = map["bBFin"];
    bBThk = map["bBThk"];
    wBackground = map["wBackground"];
    wFin = map["wFin"];
    cBackground = map["cBackground"];
    cFin = map["cFin"];
    cLevel = map["cLevel"];
    fwDetail = map["fwDetail"];
    cwDetail = map["cwDetail"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["floor"] = floor;
    map["category"] = category;
    map["roomNum"] = roomNum;
    map["roomName"] = roomName;
    map["fBackground"] = fBackground;
    map["fFin"] = fFin;
    map["fThk"] = fThk;
    map["bBBackground"] = bBBackground;
    map["bBFin"] = bBFin;
    map["bBThk"] = bBThk;
    map["wBackground"] = wBackground;
    map["wFin"] = wFin;
    map["cBackground"] = cBackground;
    map["cFin"] = cFin;
    map["cLevel"] = cLevel;
    map["fwDetail"] = fwDetail;
    map["cwDetail"] = cwDetail;

    return map;
  }

}