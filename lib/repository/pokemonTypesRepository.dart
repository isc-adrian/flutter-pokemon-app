
import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/pokemonTypesTable.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class PokemonTypesRepository{

  static PokemonTypesTable _source;

  static Future<PokemonTypesTable> get source async {
    if (_source != null) {
      return _source;
    }
    _source = await _init();
    return _source;
  }

  static _init() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    PokemonTypesTable pokemonTypesTable = new PokemonTypesTable(
        rootPath: documentsDirectory.path
        , dbName: MyDataBase.NAME
        , dbVersion: MyDataBase.VERSION);
    return pokemonTypesTable;
  }

  static Future<void> saveAll(int idPokemon, List<Type> types) async{
    var table = await source;
    return await types.map((type) {
      String typeStr = typeValues.reverse[type];
      table.save(idPokemon, typeStr);
    });
  }

  static Future<List<Type>> getTypesByPokemon(int idPokemon) async{
    var table = await source;
    List<String> typesStr = await table.getByPokemon(idPokemon);
    return typesStr.map((typeStr) => typeValues.map[typeStr]).toList();
  }

}