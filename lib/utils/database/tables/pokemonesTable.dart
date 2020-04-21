import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/tableDataBase.dart';
import 'package:flutter/material.dart';

class PokemonesTable extends TableDataBase{

  static const String TABLE_NAME = "pokemones";

  static const String ID = "id";
  static const String NUM = "num";
  static const String NAME = "name";
  static const String IMG = "img";
  static const String HEIGHT = "height";
  static const String WEIGHT = "weight";

  final MyDataBase myDataBase;

  PokemonesTable({@required this.myDataBase, @required dbVersion}): super(dbVersion: dbVersion);

  String getTableNameVersion(){
    return "${TABLE_NAME}_$dbVersion";
  }

  @override
  String createSchemaQuery(int version) {
    return "CREATE TABLE IF NOT EXISTS ${TABLE_NAME}_$version ($ID INTEGER PRIMARY KEY, $NUM TEXT NOT NULL DEFAULT '', $NAME TEXT NOT NULL DEFAULT '', $IMG TEXT NOT NULL DEFAULT '', $HEIGHT TEXT NOT NULL DEFAULT '0.0', $WEIGHT TEXT NOT NULL DEFAULT '0.0'); ";
  }

  @override
  String dropSchemaQuery(int version){
    return "DROP TABLE IF EXISTS ${TABLE_NAME}_$version";
  }

  @override
  String cleanDataQuery(int version){
    return "DELETE FROM ${TABLE_NAME}_$version";
  }

  Future<void> save(Pokemon pokemon) async {
    var dbClient = await myDataBase.getDataBase();
    await dbClient.transaction((trans) async {
      var query = "INSERT OR IGNORE INTO ${getTableNameVersion()} ($ID, $NUM, $NAME, $IMG, $HEIGHT, $WEIGHT) VALUES (${pokemon.id}, '${pokemon.num}', '${pokemon.name}', '${pokemon.img}', '${pokemon.height}', '${pokemon.weight}')";
      return await trans.rawInsert(query);
    });
  }

  Future<List<Pokemon>> getAll() async {
    var dbClient = await myDataBase.getDataBase();
    List<Map> maps = await dbClient.rawQuery("SELECT $ID, $NUM, $NAME, $IMG, $HEIGHT, $WEIGHT FROM ${getTableNameVersion()}");
    return List.generate(maps.length, (int index){
      Map map = maps[index];
      return Pokemon(
        id: map[ID],
        num: map[NUM],
        name: map[NAME],
        img: map[IMG],
        height: map[HEIGHT],
        weight: map[WEIGHT]
      );
    });
  }


}


