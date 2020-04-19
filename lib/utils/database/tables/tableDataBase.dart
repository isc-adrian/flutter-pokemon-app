import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class TableDataBase{

  Database _db;

  final String rootPath;
  final String dbName;
  int dbVersion;

  TableDataBase({this.rootPath, this.dbName, this.dbVersion});

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _init();
    return _db;
  }

  _init() async{
    String path = join(rootPath, dbName);
    var db = await openDatabase(path
        , version: dbVersion
        , onCreate: create
        , onUpgrade: update
    );
    return db;
  }

  @protected
  create(Database db, int version) async {}

  @protected
  update(Database db, int oldVersion, int newVersion) async {}

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}