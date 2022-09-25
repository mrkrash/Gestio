import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

class CblHelper {
  late Database _database;

  Future<void> initDb() async {
    await CouchbaseLiteFlutter.init();
    _database = Database.openSync('gestio');
  }

  Database getHelper() {
    if (_database.isClosed) {
      initDb();
    }
    return _database;
  }
}
