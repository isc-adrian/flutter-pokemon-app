
import 'package:app/models/persistence/pokemon.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/utils/database/tables/pokemonNextEvolutionsTable.dart';

class PokemonNextEvolutionsSource {

  static PokemonNextEvolutionsTable _source;

  static Future<PokemonNextEvolutionsTable> get source async {
    if (_source != null) {
      return _source;
    }
    _source = await _init();
    return _source;
  }

  static _init() async{
    return new PokemonNextEvolutionsTable(myDataBase: new MyDataBase(), dbVersion: MyDataBase.VERSION);
  }

  static Future<void> saveAll(int idPokemon, List<Evolution> evolutions) async{
    var table = await source;
    for(Evolution evolution in evolutions){
      table.save(idPokemon, evolution);
    }
  }

  static Future<List<Evolution>> getByPokemon(int idPokemon) async{
    var table = await source;
    return await table.getByPokemon(idPokemon);
  }

}