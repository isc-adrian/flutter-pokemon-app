import 'package:app/models/persistence/pokemon.dart';
import 'package:app/services/pokemonesService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../pokemon/pokemonDetail.dart';

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
                  child: CachedNetworkImage(
                    imageUrl: pokemon.img,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
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
