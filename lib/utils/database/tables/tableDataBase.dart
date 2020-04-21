abstract class TableDataBase{

  final int dbVersion;

  TableDataBase({this.dbVersion});

  String createSchemaQuery(int version){
    return "";
  }

  String dropSchemaQuery(int version){
    return "";
  }

  String cleanDataQuery(int version){
    return "";
  }
}