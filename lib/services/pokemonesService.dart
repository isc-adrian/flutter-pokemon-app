import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/models/persistence/pokemon.dart';

class PokemonesService {

  static const String URL = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  Future<List<Pokemon>> getPokemones() async{
    try{
      var response = await http.get(URL);
      if(response.statusCode == 200){
        var json = jsonDecode(response.body);
        List<Pokemon> pokemones = List<Pokemon>.from(json["pokemon"].map((x) => Pokemon.fromMap(x)));
        return pokemones;
      } else {
        throw Exception("No se pudo conectar con el servidor");
      }
    }catch(ex){
      throw ex;
    }
  }
}







