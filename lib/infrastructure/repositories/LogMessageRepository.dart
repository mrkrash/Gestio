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
import 'package:gestio/domain/log/CblLogMessage.dart';
import 'package:gestio/domain/log/LogMessageAbstract.dart';

class LogMessageRepository {
  final Database _database;

  LogMessageRepository(this._database);

  Future<LogMessageAbstract> createLogMessage(String message) async {
    final document = MutableDocument({
      'type': 'logMessage',
      'createdAt': DateTime.now(),
      'message': message
    });
    await _database.saveDocument(document);
    return CblLogMessage(document);
  }

  Stream<List<LogMessageAbstract>> allLogMessageStream() {
    final query = const QueryBuilder()
        .select(
          SelectResult.expression(Meta.id),
          SelectResult.property('createdAt'),
          SelectResult.property('message'),
        )
        .from(DataSource.database(_database))
        .where(
          Expression.property('type').equalTo(Expression.value('logMessage')),
        )
        .orderBy(Ordering.property('createdAt'));

    // The line below prints an explanation of how the query will be executed.
    // This explanation should contain this line, which tells us that the query
    // uses the index we created in the `initApp` function:
    // 4|0|0| SEARCH TABLE kv_default AS example USING INDEX type+createdAt (<expr>=?)
    Future(query.explain).then(print);

    return query.changes().asyncMap(
          (change) => change.results.asStream().map(CblLogMessage.new).toList(),
        );
  }
}
