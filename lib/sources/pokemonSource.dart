import 'package:app/models/persistence/pokemon.dart';
import 'package:app/sources/pokemonNextEvolutionsSource.dart';
import 'package:app/sources/pokemonTypesSource.dart';
import 'package:app/sources/pokemonWeaknessesSource.dart';
import 'package:app/utils/database/myDataBase.dart';

import '../utils/database/tables/pokemonesTable.dart';

class PokemonSource {

  static PokemonesTable _source;

  static Future<PokemonesTable> get source async {
    if (_source != null) {
      return _source;
    }
    _source = await _init();
    return _source;
  }

  static _init() async{
    return new PokemonesTable(myDataBase: new MyDataBase(), dbVersion: MyDataBase.VERSION);
  }

  static Future<void> saveAll(List<Pokemon> pokemones) async{
    var table = await source;
    for(Pokemon pokemon in pokemones){
      await table.save(pokemon);
      await PokemonTypesSource.saveAll(pokemon.id, pokemon.type);
      await PokemonWeaknessesSource.saveAll(pokemon.id, pokemon.weaknesses);
      await PokemonNextEvolutionsSource.saveAll(pokemon.id, pokemon.nextEvolution);
    }
  }

  static Future<List<Pokemon>> getAll() async{
    var table = await source;
    List<Pokemon> pokemones = await table.getAll();
    for(Pokemon pokemon in pokemones){
      pokemon.type = await PokemonTypesSource.getByPokemon(pokemon.id);
      pokemon.weaknesses = await PokemonWeaknessesSource.getByPokemon(pokemon.id);
      pokemon.nextEvolution = await PokemonNextEvolutionsSource.getByPokemon(pokemon.id);
    }
    return pokemones;
  }
}