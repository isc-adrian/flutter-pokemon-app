import 'package:app/utils/database/tables/pokemonNextEvolutionsTable.dart';
import 'package:app/utils/database/tables/pokemonTypesTable.dart';
import 'package:app/utils/database/tables/pokemonWeaknessesTable.dart';
import 'package:app/utils/database/tables/pokemonesTable.dart';
import 'package:app/utils/database/tables/tableDataBase.dart';

class MyTableFactory{

  static TableDataBase getTable(String tableName, int versionDb){
    if(tableName == PokemonesTable.TABLE_NAME){
      return PokemonesTable(myDataBase: null, dbVersion: versionDb);
    } else if(tableName == PokemonTypesTable.TABLE_NAME){
      return PokemonTypesTable(myDataBase: null, dbVersion: versionDb);
    } else if(tableName == PokemonWeaknessesTable.TABLE_NAME){
      return PokemonWeaknessesTable(myDataBase: null, dbVersion: versionDb);
    } else if(tableName == PokemonNextEvolutionsTable.TABLE_NAME){
      return PokemonNextEvolutionsTable(myDataBase: null, dbVersion: versionDb);
    }

    return null;
  }
}