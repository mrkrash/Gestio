import 'package:cbl/cbl.dart';
import 'package:gestio/log/CblLogMessage.dart';
import 'package:gestio/log/LogMessageAbstract.dart';

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
