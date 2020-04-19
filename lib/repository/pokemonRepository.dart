import 'package:app/models/persistence/pokemon.dart';
import 'package:app/repository/pokemonTypesRepository.dart';
import 'package:app/utils/database/myDataBase.dart';

import '../utils/database/tables/pokemonesTable.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class PokemonRepository{

  static PokemonesTable _source;

  static Future<PokemonesTable> get source async {
    if (_source != null) {
      return _source;
    }
    _source = await _init();
    return _source;
  }

  static _init() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    PokemonesTable pokemonesTable = new PokemonesTable(
        rootPath: documentsDirectory.path
        , dbName: MyDataBase.NAME
        , dbVersion: MyDataBase.VERSION);
    return pokemonesTable;
  }

  static Future<void> saveAll(List<Pokemon> pokemones) async{
    var table = await source;
    for(Pokemon pokemon in pokemones){
      await table.save(pokemon);
      PokemonTypesRepository.saveAll(pokemon.id, pokemon.type);
    }
  }

  static Future<List<Pokemon>> getAll() async{
    var table = await source;
    List<Pokemon> pokemones = await table.getAll();
    for(Pokemon pokemon in pokemones){
      pokemon.type = await PokemonTypesRepository.getTypesByPokemon(pokemon.id);
    }
    return pokemones;
  }
}