import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/tableDataBase.dart';
import 'package:flutter/material.dart';

class PokemonTypesTable extends TableDataBase{

  static const String TABLE_NAME = "pokemonTypes";

  static const String ID_POKEMON = "idPokemon";
  static const String TYPE = "type";

  final MyDataBase myDataBase;

  PokemonTypesTable({@required this.myDataBase, @required dbVersion}): super(dbVersion: dbVersion);

  String getTableNameVersion(){
    return "${TABLE_NAME}_$dbVersion";
  }

  @override
  String createSchemaQuery(int version) {
    return "CREATE TABLE IF NOT EXISTS ${TABLE_NAME}_$version ($ID_POKEMON INTEGER, $TYPE TEXT NOT NULL DEFAULT '', PRIMARY KEY ($ID_POKEMON, $TYPE)); ";
  }

  @override
  String dropSchemaQuery(int version){
    return "DROP TABLE IF EXISTS ${TABLE_NAME}_$version";
  }

  @override
  String cleanDataQuery(int version){
    return "DELETE FROM ${TABLE_NAME}_$version";
  }

  Future<void> save(int idPokemon, String type) async{
    var dbClient = await myDataBase.getDataBase();
    await dbClient.transaction((trans) async {
      var query = "INSERT OR IGNORE INTO ${getTableNameVersion()} ($ID_POKEMON, $TYPE) VALUES ($idPokemon, '$type')";
      return await trans.rawInsert(query);
    });
  }

  Future<List<String>> getByPokemon(int idPokemon) async {
    var dbClient = await myDataBase.getDataBase();
    List<Map> maps = await dbClient.rawQuery("SELECT $TYPE FROM ${getTableNameVersion()} WHERE $ID_POKEMON = $idPokemon");
    return List.generate(maps.length, (int index){
      Map map = maps[index];
      return map[TYPE];
    });
  }

}