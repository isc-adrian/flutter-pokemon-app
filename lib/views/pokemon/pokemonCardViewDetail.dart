import 'package:app/models/persistence/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PokemonCardViewDetail extends StatelessWidget {

  final Pokemon pokemon;

  PokemonCardViewDetail({this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width - 20,
          top: MediaQuery.of(context).size.height * 0.1,
          left: 10,
          child: Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 75,),
                Text(this.pokemon.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text("Height: ${this.pokemon.height}"),
                Text("Weight: ${this.pokemon.weight}"),
                Text("Types", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: this.pokemon.type.map((t) =>
                      FilterChip(backgroundColor: Colors.blue, label: Text(typeValues.reverse[t], style: TextStyle(color: Colors.white),), onSelected: (b){})).toList(),),
                Text("Weaknesses", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: this.pokemon.weaknesses.map((w) =>
                      FilterChip(backgroundColor: Colors.red, label: Text(typeValues.reverse[w], style: TextStyle(color: Colors.white)), onSelected: (b){})).toList(),),
                Text("Next Evolution", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: this.pokemon.nextEvolution.map((evol) =>
                      FilterChip( backgroundColor: Colors.green, label: Text(evol.name, style: TextStyle(color: Colors.white),), onSelected: (b){})).toList(),),
              ],),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Hero(
            tag: pokemon.img,
            child: Container(
              height: 160,
              width: 160,
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
          ),
        )
      ],
    );
  }
}
