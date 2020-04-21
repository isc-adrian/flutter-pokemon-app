import 'package:app/sources/pokemonNextEvolutionsSource.dart';
import 'package:app/utils/database/myTableFactory.dart';
import 'package:app/utils/database/tables/pokemonNextEvolutionsTable.dart';
import 'package:app/utils/database/tables/pokemonTypesTable.dart';
import 'package:app/utils/database/tables/pokemonWeaknessesTable.dart';
import 'package:app/utils/database/tables/pokemonesTable.dart';
import 'package:app/utils/database/tables/tableDataBase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class MyDataBase{
  static const String NAME = "pokemones.db";
  static const int VERSION = 5;

  final List<String> registeredTables = [
    PokemonesTable.TABLE_NAME,
    PokemonTypesTable.TABLE_NAME,
    PokemonWeaknessesTable.TABLE_NAME,
    PokemonNextEvolutionsTable.TABLE_NAME,
  ];

  String rootPath = "";
  Database _db;

  MyDataBase({this.rootPath});

  Future<Database> getDataBase() async {
    if (_db != null) {
      return _db;
    }
    _db = await _init();
    return _db;
  }

  _init() async{
    if(rootPath == null || rootPath.isEmpty){
      //io.Directory dir = io.Directory("/storage/emulated/0/pokemonApp/");
      io.Directory dir = await getExternalStorageDirectory();
      rootPath = dir.path;
    }

    String path = join(rootPath, NAME);
    var db = await openDatabase(path
        , version: VERSION
        , onCreate: _onCreate
        , onUpgrade: _onUpgrade
    );
    return db;
  }

  void createDataBase() async{
    await getDataBase();
  }

  FutureOr<void> _onCreate(Database db, int version) async{
    for(String tableName in registeredTables){
      TableDataBase tableDataBase = MyTableFactory.getTable(tableName, VERSION);
      if(tableDataBase != null){
        await db.execute(tableDataBase.createSchemaQuery(version));
      }
    }
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    for(String tableName in registeredTables){
      TableDataBase tableDataBase = MyTableFactory.getTable(tableName, VERSION);
      if(tableDataBase != null){
        await db.execute(tableDataBase.dropSchemaQuery(oldVersion));
        await db.execute(tableDataBase.createSchemaQuery(newVersion));
      }
    }
  }
}