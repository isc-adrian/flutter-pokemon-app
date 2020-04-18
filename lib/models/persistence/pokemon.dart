class Pokemon {
  int id;
  String num;
  String name;
  String img;
  List<Type> type = List<Type>();
  String height;
  String weight;
  String candy;
  int candyCount;
  Egg egg;
  String spawnChance;
  String avgSpawns;
  String spawnTime;
  List<double> multipliers;
  List<Type> weaknesses = List<Type>();
  List<Evolution> nextEvolution = List<Evolution>();
  List<Evolution> prevEvolution = List<Evolution>();

  Pokemon({
    this.id,
    this.num,
    this.name,
    this.img,
    this.type = const [],
    this.height,
    this.weight,
    this.candy,
    this.candyCount,
    this.egg,
    this.spawnChance,
    this.avgSpawns,
    this.spawnTime,
    this.multipliers,
    this.weaknesses = const [],
    this.nextEvolution = const [],
    this.prevEvolution = const [],
  });

  factory Pokemon.fromMap(Map<String, dynamic> json) => Pokemon(
    id: json["id"],
    num: json["num"],
    name: json["name"].toString().replaceAll("'", ""),
    img: json["img"],
//    type: json['type'] == null ? List<String>() : json['type'].cast<String>(),
    type: json['type'] == null ? List<Type>() : List<Type>.from(json["type"].map((x) => typeValues.map[x])),
    height: json["height"],
    weight: json["weight"],
    candy: json["candy"],
    candyCount: json["candy_count"] == null ? 0 : json["candy_count"],
    egg: eggValues.map[json["egg"]],
    spawnChance: json["spawn_chance"].toString(),
    avgSpawns: json["avg_spawns"].toString(),
    spawnTime: json["spawn_time"],
    multipliers: json["multipliers"] == null ? List<double>() : List<double>.from(json["multipliers"].map((x) => x.toDouble())),
    //weaknesses: json['weaknesses'] == null ? List<String>() : json['weaknesses'].cast<String>(),//List<Type>.from(json["weaknesses"].map((x) => typeValues.map[x])),
    weaknesses: json['weaknesses'] == null ? List<Type>() : List<Type>.from(json["weaknesses"].map((x) => typeValues.map[x])),
    nextEvolution: json["next_evolution"] == null ? List<Evolution>() : List<Evolution>.from(json["next_evolution"].map((x) => Evolution.fromJson(x))),
    prevEvolution: json["prev_evolution"] == null ? List<Evolution>() : List<Evolution>.from(json["prev_evolution"].map((x) => Evolution.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "num": num,
    "name": name,
    "img": img,
    "type": List<dynamic>.from(type.map((x) => typeValues.reverse[x])),
    "height": height,
    "weight": weight,
    "candy": candy,
    "candy_count": candyCount == null ? 0 : candyCount,
    "egg": eggValues.reverse[egg],
    "spawn_chance": spawnChance,
    "avg_spawns": avgSpawns,
    "spawn_time": spawnTime,
    "multipliers": multipliers == null ? List<dynamic>() : List<dynamic>.from(multipliers.map((x) => x)),
    "weaknesses": List<dynamic>.from(weaknesses.map((x) => typeValues.reverse[x])),
    "next_evolution": nextEvolution == null ? List<dynamic>() : List<dynamic>.from(nextEvolution.map((x) => x.toJson())),
    "prev_evolution": prevEvolution == null ? List<dynamic>() : List<dynamic>.from(prevEvolution.map((x) => x.toJson())),
  };
}

enum Type { FIRE, ICE, FLYING, PSYCHIC, WATER, GROUND, ROCK, ELECTRIC, GRASS, FIGHTING, POISON, BUG, FAIRY, GHOST, DARK, STEEL, DRAGON, NORMAL }

final typeValues = EnumValues({
  "Bug": Type.BUG,
  "Dark": Type.DARK,
  "Dragon": Type.DRAGON,
  "Electric": Type.ELECTRIC,
  "Fairy": Type.FAIRY,
  "Fighting": Type.FIGHTING,
  "Fire": Type.FIRE,
  "Flying": Type.FLYING,
  "Ghost": Type.GHOST,
  "Grass": Type.GRASS,
  "Ground": Type.GROUND,
  "Ice": Type.ICE,
  "Normal": Type.NORMAL,
  "Poison": Type.POISON,
  "Psychic": Type.PSYCHIC,
  "Rock": Type.ROCK,
  "Steel": Type.STEEL,
  "Water": Type.WATER
});

enum Egg { THE_2_KM, NOT_IN_EGGS, THE_5_KM, THE_10_KM, OMANYTE_CANDY }

final eggValues = EnumValues({
  "Not in Eggs": Egg.NOT_IN_EGGS,
  "Omanyte Candy": Egg.OMANYTE_CANDY,
  "10 km": Egg.THE_10_KM,
  "2 km": Egg.THE_2_KM,
  "5 km": Egg.THE_5_KM
});

class Evolution {
  String num;
  String name;

  Evolution({
    this.num,
    this.name,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) => Evolution(
    num: json["num"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "num": num,
    "name": name,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}