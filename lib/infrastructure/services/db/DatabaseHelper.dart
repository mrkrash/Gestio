/*
 * This file is part of Gestio.
 *
 * Copyright (c) 2022 Mario Ravalli.
 *
 * Gestio is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Gestio is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Gestio. If not, see <https://www.gnu.org/licenses/>.
 */

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
