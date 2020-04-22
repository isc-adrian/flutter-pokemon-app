import 'package:app/models/persistence/pokemon.dart';
import 'package:app/services/pokemonesService.dart';
import 'package:app/sources/pokemonSource.dart';
import 'package:app/utils/database/myDataBase.dart';
import 'package:app/views/pokemones/pokemonCardView.dart';
import 'package:connectivity/connectivity.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

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

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  bool offlineMode = false;
  List<Pokemon> pokemones = List<Pokemon>();
  List<Pokemon> pokemonesFiltered = List<Pokemon>();

  @override
  void initState() {
    super.initState();
    initialize();
    fetchData();
  }

  initialize() async{
    MyDataBase myDataBase = new MyDataBase();
    myDataBase.createDataBase();
  }

  /*Future<bool> canConnectToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }*/

  fetchData() async {
    if(offlineMode){
      PokemonSource.getAll().then((pokemonList) {
        this.setState((){
          pokemones = pokemonList;
          pokemonesFiltered = pokemones;
        });
      });
    } else {
      PokemonesService service = PokemonesService();
      service.getPokemones().then((pokemonesFromService) => {
        this.setState((){
          pokemones = pokemonesFromService;
          pokemonesFiltered = pokemones;
        })
      });
    }
  }

  AppBar getAppBar(){
    return AppBar(
      title: _isSearching ? _buildSearchField(): Text("Pokemon app"),
      backgroundColor: Colors.cyan,
      leading: _isSearching ? BackButton() : null,
      actions: _buildActions(),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Buscar...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),

      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      IconButton(
        icon: getConnectionMode(),
      ),
    ];
  }

  Widget getConnectionMode(){
    if(offlineMode){
      return Icon(Icons.signal_wifi_off, color: Colors.white,);
    } else {
      return Icon(Icons.signal_wifi_4_bar, color: Colors.white,);
    }
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      if(searchQuery.isEmpty){
        pokemonesFiltered = pokemones;
      } else {
        pokemonesFiltered = pokemones.where((pokemon) => (
            pokemon.name.toLowerCase().contains(searchQuery.toLowerCase())
        )).toList();
      }
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  FloatingActionButton getFloatingActionButtons(){
    return FloatingActionButton(
      child: Icon(Icons.refresh),
      backgroundColor: Colors.cyan,
      onPressed: refreshPokemones,
    );
  }

  refreshPokemones(){
    setState(() {
      pokemones = List<Pokemon>();
      pokemonesFiltered = List<Pokemon>();
    });
    fetchData();
  }

  Widget getBody(){
    if(_isSearching){
      if(pokemonesFiltered.isEmpty){
        return Center(
          child: EmptyListWidget(
            title: 'No se encuentra al pokemon:',
            subTitle: searchQuery,
            image: 'assets/emptyImage.png',
            titleTextStyle: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
            subtitleTextStyle: TextStyle(color: Colors.grey, fontSize:  20, fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return getGridPokemones();
      }
    } else {
      if(pokemonesFiltered.isEmpty){
        return Center(child: CircularProgressIndicator(),);
      }else {
        return getGridPokemones();
      }
    }
  }

  Widget getGridPokemones(){
    return GridView.builder(
        itemCount: pokemonesFiltered.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index){
          Pokemon pokemon = pokemonesFiltered[index];
          return PokemonCardView(pokemon: pokemon,);
        });
  }

  Widget getDawer(){
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pikachu_perfil_avatar.jpg"),
                fit: BoxFit.contain
              ),
            ),
          ),
          Text("Menú de opciones",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,

          ),
          SwitchListTile(
            value: offlineMode,
            onChanged: (activatedOfflineMode){
              setState(() {
                offlineMode = activatedOfflineMode;
              });
              if(activatedOfflineMode){
                PokemonSource.saveAll(pokemones);
              }
              refreshPokemones();
            },
            title: Text("Activar modo offline"),
            secondary: Icon(Icons.signal_wifi_off),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      drawer: getDawer(),
      body: getBody(),
      floatingActionButton: _isSearching ? null : getFloatingActionButtons(),
    );
  }
}
