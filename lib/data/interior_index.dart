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
      this.cLevel});

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
    return map;
  }

}