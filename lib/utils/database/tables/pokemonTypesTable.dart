import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/tables/tableDataBase.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PokemonTypesTable extends TableDataBase{

  static const String TABLE_NAME = "pokemonTypes";

  static const String ID_POKEMON = "idPokemon";
  static const String TYPE = "type";

  PokemonTypesTable({rootPath, dbName, dbVersion}) : super(rootPath: rootPath, dbName: dbName, dbVersion: dbVersion);

  String getTableNameVersion(){
    return """${TABLE_NAME}_${dbVersion}""";
  }

  @override
  create(Database db, int version) async{
    String sqlQuery = "CREATE TABLE IF NOT EXISTS ${getTableNameVersion()} (${ID_POKEMON} INTEGER, ${TYPE} TEXT NOT NULL DEFAULT ''); ";
    await db.execute(sqlQuery);
  }

  @override
  update(Database db, int oldVersion, int newVersion) async {
    await create(db, newVersion);
  }

  Future<int> save(int idPokemon, String type) async{
    var dbClient = await db;
    /*pokemon.id = await dbClient.insert(TABLE_NAME, pokemon.toMap());
    return pokemon;*/
    await dbClient.transaction((trans) async {
      var query = "INSERT OR IGNORE INTO ${getTableNameVersion()} (${ID_POKEMON}, ${TYPE}) VALUES (${idPokemon}, '${type}')";
      return await trans.rawInsert(query);
    });
  }

  Future<List<String>> getByPokemon(int idPokemon) async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE_NAME, columns: [ID, NAME]);
    List<Map> maps = await dbClient.rawQuery("SELECT ${TYPE} FROM ${getTableNameVersion()} WHERE ${ID_POKEMON} = ${idPokemon}");
    return List.generate(maps.length, (int index){
      Map map = maps[index];
      return map[TYPE];
    });
  }

}