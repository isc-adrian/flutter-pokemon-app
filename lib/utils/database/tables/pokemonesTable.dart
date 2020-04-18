import 'package:app/models/persistence/pokemon.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class PokemonesTable{

  static const String TABLE_NAME = "pokemones";

  static const String ID = "id";
  static const String NUM = "num";
  static const String NAME = "name";
  static const String IMG = "img";
  static const String HEIGHT = "height";
  static const String WEIGHT = "weight";

  Database _db;

  final String rootPath;
  final String dbName;
  final int dbVersion;

  PokemonesTable({this.rootPath, this.dbName, this.dbVersion});

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _init();
    return _db;
  }

  _init() async{
    String path = join(rootPath, dbName);
    var db = await openDatabase(path, version: dbVersion, onCreate: _onCreate);
    return db;
  }

  String getTableNameVersion(){
    return """${TABLE_NAME}_${dbVersion}""";
  }

  _onCreate(Database db, int version) async{
    String sqlQuery = "CREATE TABLE ${getTableNameVersion()} (${ID} INTEGER PRIMARY KEY, ${NUM} TEXT NOT NULL DEFAULT '', ${NAME} TEXT NOT NULL DEFAULT '', ${IMG} TEXT NOT NULL DEFAULT '', ${HEIGHT} TEXT NOT NULL DEFAULT '0.0', ${WEIGHT} TEXT NOT NULL DEFAULT '0.0'); ";
    await db.execute(sqlQuery);
  }

  Future<Pokemon> save(Pokemon pokemon) async {
    var dbClient = await db;
    /*pokemon.id = await dbClient.insert(TABLE_NAME, pokemon.toMap());
    return pokemon;*/
    await dbClient.transaction((txn) async {
      var query = "INSERT OR IGNORE INTO ${getTableNameVersion()} (${ID}, ${NUM}, ${NAME}, ${IMG}, ${HEIGHT}, ${WEIGHT}) VALUES (${pokemon.id}, '${pokemon.num}', '${pokemon.name}', '${pokemon.img}', '${pokemon.height}', '${pokemon.weight}')";
      return await txn.rawInsert(query);
    });
  }

  Future<List<Pokemon>> getPokemones() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE_NAME, columns: [ID, NAME]);
    List<Map> maps = await dbClient.rawQuery("SELECT ${ID}, ${NUM}, ${NAME}, ${IMG}, ${HEIGHT}, ${WEIGHT} FROM ${getTableNameVersion()}");
    List<Pokemon> pokemones = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Pokemon pokemon = Pokemon();
        Map map = maps[i];
        pokemon.id = map[ID];
        pokemon.num = map[NUM];
        pokemon.name = map[NAME];
        pokemon.img = map[IMG];
        pokemon.height = map[HEIGHT];
        pokemon.weight = map[WEIGHT];
        pokemones.add(pokemon);
      }
    }
    return pokemones;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}

