import 'package:app/models/persistence/pokemon.dart';
import 'package:app/views/pokemones/pokemonCardView.dart';
import 'package:flutter/material.dart';

class PokemonSearch extends SearchDelegate<Pokemon>{

  List<Pokemon> pokemones;
  
  PokemonSearch({this.pokemones});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,)
      , onPressed: (){
        close(context, null);
      },);
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Pokemon> pokemonesFiltered = List<Pokemon>();
    if(query.isEmpty){
      pokemonesFiltered = pokemones;
    } else {
      pokemonesFiltered = pokemones.where((pokemon) => (
        pokemon.name.toLowerCase().contains(query.toLowerCase())
      )).toList();
    }
    
    return GridView.builder(
        itemCount: pokemonesFiltered.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index){
          Pokemon pokemon = pokemonesFiltered[index];
          return PokemonCardView(pokemon: pokemon,);
        });
  }

}