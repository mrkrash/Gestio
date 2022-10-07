import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

class DatabaseHelper {
  Database? database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  init() async {
    await CouchbaseLiteFlutter.init();
    database = Database.openSync('gestio');
  }
}
