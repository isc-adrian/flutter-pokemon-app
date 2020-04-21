
import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/pokemonTypesTable.dart';

class PokemonTypesSource {

  static PokemonTypesTable _source;

  static Future<PokemonTypesTable> get source async {
    if (_source != null) {
      return _source;
    }
    _source = await _init();
    return _source;
  }

  static _init() async{
    return new PokemonTypesTable(myDataBase: new MyDataBase(), dbVersion: MyDataBase.VERSION);
  }

  static Future<void> saveAll(int idPokemon, List<Type> types) async{
    var table = await source;
    for(Type type in types){
      String typeStr = typeValues.reverse[type];
      table.save(idPokemon, typeStr);
    }
  }

  static Future<List<Type>> getByPokemon(int idPokemon) async{
    var table = await source;
    List<String> typesStr = await table.getByPokemon(idPokemon);
    return typesStr.map((typeStr) => typeValues.map[typeStr]).toList();
  }

}