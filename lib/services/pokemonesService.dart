import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/models/persistence/pokemon.dart';

/*PokemonesService FromJson(String str) => PokemonesService.fromJson(json.decode(str));

String ToJson(PokemonesService data) => json.encode(data.toJson());*/

class PokemonesService {

  final String URL = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  Future<List<Pokemon>> getPokemones() async{
    try{
      var response = await http.get(URL);
      if(response.statusCode == 200){
        var json = jsonDecode(response.body);
        List<Pokemon> pokemones = List<Pokemon>.from(json["pokemon"].map((x) => Pokemon.fromJson(x)));
        return pokemones;
      } else {
        throw Exception("No se pudo conectar con el servidor");
      }
    }catch(ex){
      throw ex;
    }
  }

  /*List<Pokemon> pokemon;

  PokemonesService({
    this.pokemon,
  });

  factory PokemonesService.fromJson(Map<String, dynamic> json) => PokemonesService(
    pokemon: List<Pokemon>.from(json["pokemon"].map((x) => Pokemon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pokemon": List<dynamic>.from(pokemon.map((x) => x.toJson())),
  };*/
}







