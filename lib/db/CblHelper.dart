import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

class CblHelper {
  static Database? _database;

  Future<Database> initDb() async {
    await CouchbaseLiteFlutter.init();
    return Database.openSync('gestio');
  }

  Future<Database?> getHelper() async {
    _database ??= await initDb();

    return _database;
  }
}
