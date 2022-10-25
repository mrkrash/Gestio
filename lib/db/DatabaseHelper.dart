import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

class DatabaseHelper {
  Database? database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  init() async {
    await CouchbaseLiteFlutter.init();
    database = Database.openSync('gestio');
    var indexes = await database!.indexes;

    if (!indexes.contains("overviewFTSIndex")) {
      var index = FullTextIndexConfiguration(["firstname", "lastname", "address", "phone", "model", "registeredCode"]);
      try {
        database!.createIndex("overviewFTSIndex", index);
      } catch (error) {
        print(error.toString());
      }
    }
  }
}
