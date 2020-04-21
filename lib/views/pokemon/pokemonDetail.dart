import 'package:app/models/persistence/pokemon.dart';
import 'package:app/views/pokemon/pokemonCardViewDetail.dart';
import 'package:flutter/material.dart';

class PokemonDetail extends StatelessWidget {

  final Pokemon pokemon;
  static List<Widget> widgets;

  PokemonDetail({this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text("${this.pokemon.name}"),
        backgroundColor: Colors.cyan,
        elevation: 0,
      ),
      body: PokemonCardViewDetail(pokemon: this.pokemon),
    );
  }
}
