
import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/pokemonTypesTable.dart';
import 'package:app/utils/database/tables/pokemonWeaknessesTable.dart';

class PokemonWeaknessesSource {

  static PokemonWeaknessesTable _source;

  static Future<PokemonWeaknessesTable> get source async {
    if (_source != null) {
      return _source;
    }
    _source = await _init();
    return _source;
  }

  static _init() async{
    return new PokemonWeaknessesTable(myDataBase: new MyDataBase(), dbVersion: MyDataBase.VERSION);
  }

  static Future<void> saveAll(int idPokemon, List<Type> weaknesses) async{
    var table = await source;
    for(Type weakness in weaknesses){
      String typeStr = typeValues.reverse[weakness];
      table.save(idPokemon, typeStr);
    }
  }

  static Future<List<Type>> getByPokemon(int idPokemon) async{
    var table = await source;
    List<String> weaknessesStr = await table.getByPokemon(idPokemon);
    return weaknessesStr.map((weaknessStr) => typeValues.map[weaknessStr]).toList();
  }

}