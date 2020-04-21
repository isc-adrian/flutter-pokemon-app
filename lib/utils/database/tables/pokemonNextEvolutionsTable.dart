import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/tableDataBase.dart';
import 'package:flutter/material.dart';

class PokemonNextEvolutionsTable extends TableDataBase{

  static const String TABLE_NAME = "pokemonEvolutions";

  static const String ID_POKEMON = "idPokemon";
  static const String NUM = "num";
  static const String NAME = "name";

  final MyDataBase myDataBase;

  PokemonNextEvolutionsTable({@required this.myDataBase, @required dbVersion}): super(dbVersion: dbVersion);

  String getTableNameVersion(){
    return "${TABLE_NAME}_$dbVersion";
  }

  @override
  String createSchemaQuery(int version) {
    return "CREATE TABLE IF NOT EXISTS ${TABLE_NAME}_$version ($ID_POKEMON INTEGER NOT NULL DEFAULT 0, $NUM TEXT NOT NULL DEFAULT '', $NAME TEXT NOT NULL DEFAULT '', PRIMARY KEY ($ID_POKEMON, $NUM, $NAME)); ";
  }

  @override
  String dropSchemaQuery(int version){
    return "DROP TABLE IF EXISTS ${TABLE_NAME}_$version";
  }

  @override
  String cleanDataQuery(int version){
    return "DELETE FROM ${TABLE_NAME}_$version";
  }

  Future<void> save(int idPokemon, Evolution evolution) async {
    var dbClient = await myDataBase.getDataBase();
    await dbClient.transaction((trans) async {
      var query = "INSERT OR IGNORE INTO ${getTableNameVersion()} ($ID_POKEMON, $NUM, $NAME) VALUES (${idPokemon}, '${evolution.num}', '${evolution.name}')";
      return await trans.rawInsert(query);
    });
  }

  Future<List<Evolution>> getByPokemon(int idPokemon) async {
    var dbClient = await myDataBase.getDataBase();
    List<Map> maps = await dbClient.rawQuery("SELECT $NUM, $NAME FROM ${getTableNameVersion()} WHERE $ID_POKEMON = $idPokemon");
    return List.generate(maps.length, (int index){
      Map map = maps[index];
      return Evolution(
          num: map[NUM],
          name: map[NAME],
      );
    });
  }

}