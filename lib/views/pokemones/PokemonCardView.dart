import 'package:app/models/persistence/pokemon.dart';
import 'package:app/services/pokemonesService.dart';
import 'package:flutter/material.dart';

import '../../pokemonDetail.dart';

class PokemonCardView extends StatelessWidget {

  Pokemon pokemon;

  PokemonCardView({this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetail(pokemon: pokemon,)));
        },
        child: Hero(
          tag: pokemon.img,
          child: Card(
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(pokemon.img),),),
                ),
                Text("${pokemon.num} - ${pokemon.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
