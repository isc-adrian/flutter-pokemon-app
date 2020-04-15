import 'package:app/models/persistence/pokemon.dart';
import 'package:app/services/pokemonesService.dart';
import 'package:app/pokemonDetail.dart';
import 'package:app/utils/searches/pokemonSearch.dart';
import 'package:app/views/pokemones/PokemonCardView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
  title: "Poke App",
  debugShowCheckedModeBanner: false,
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Pokemon> pokemones = List<Pokemon>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() {
    PokemonesService service = PokemonesService();
    service.getPokemones().then((pokemonesFromService) => {
      this.setState((){
        pokemones = pokemonesFromService;
      })
    });
  }

  AppBar getAppBar(){
    return AppBar(
      title: Text("Poke App"),
      backgroundColor: Colors.cyan,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
          showSearch(context: context, delegate: PokemonSearch(pokemones: pokemones));
        }),
      ],
    );
  }

  FloatingActionButton getRefreshPokemons(){
    return FloatingActionButton(
      child: Icon(Icons.refresh),
      backgroundColor: Colors.cyan,
      onPressed: (){
        pokemones = List<Pokemon>();
        setState(() {});
        fetchData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: pokemones.isEmpty
          ? Center(child: CircularProgressIndicator(),)
          : GridView.builder(
            itemCount: pokemones.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index){
              Pokemon pokemon = pokemones[index];
              return PokemonCardView(pokemon: pokemon,);
            }),
      floatingActionButton: getRefreshPokemons(),
    );
  }
}
