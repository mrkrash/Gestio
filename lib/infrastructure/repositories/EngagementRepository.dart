import 'package:cbl/cbl.dart';
import 'package:gestio/infrastructure/services/db/DatabaseHelper.dart';
import 'package:gestio/domain/engagement/Engagement.dart';

class EngagementRepository {
  Future<Stream<List<Engagement>>> allDocumentStream(
      DateTime begin,
      DateTime end,
      [String? searchTerm]
      ) async {
    DataSourceInterface machineDS = DataSource
        .database(DatabaseHelper.instance.database!)
        .as("machineDS");
    DataSourceInterface customerDS = DataSource
        .database(DatabaseHelper.instance.database!)
        .as("customerDS");
    ExpressionInterface machineOwnerExpr = Expression.property("owner")
        .from("machineDS");
    ExpressionInterface customerIdExpr = Expression.property("_id")
        .from("customerDS");
    ExpressionInterface joinExpr = machineOwnerExpr.equalTo(customerIdExpr)
        .and(Expression.property("type").from("machineDS").equalTo(Expression.string("machine")))
        .and(Expression.property("type").from("customerDS").equalTo(Expression.string("customer")));
    JoinInterface join = Join.join(customerDS).on(joinExpr);
    ExpressionInterface where = Expression.property("deadline")
        .from("machineDS").between(Expression.date(begin), and: Expression.date(end));

    if (searchTerm != null) {
      where = Function_.lower(Expression.property("firstname").from("customerDS")).like(Function_.lower(Expression.string("%$searchTerm%")))
          .or(Function_.lower(Expression.property("lastname").from("customerDS")).like(Function_.lower(Expression.string("%$searchTerm%"))))
          .or(Function_.lower(Expression.property("address").from("customerDS")).like(Function_.lower(Expression.string("%$searchTerm%"))))
          .or(Function_.lower(Expression.property("model").from("machineDS")).like(Function_.lower(Expression.string("%$searchTerm%"))))
          .or(Function_.lower(Expression.property("registeredCode").from("machineDS")).like(Function_.lower(Expression.string("%$searchTerm%"))))
          .and(Expression.property("deadline").from("machineDS").notNullOrMissing());
    }

    var query = const QueryBuilder()
      .select(
        SelectResult.all().from("machineDS"),
        SelectResult.expression(Expression.property("_id").from("machineDS")).as("id"),
        SelectResult.expression(Expression.property("firstname").from("customerDS")).as("firstname"),
        SelectResult.expression(Expression.property("lastname").from("customerDS")).as("lastname"),
        SelectResult.expression(Expression.property("address").from("customerDS")).as("address"),
        SelectResult.expression(Expression.property("phone").from("customerDS")).as("phone")
      )
      .from(machineDS)
      .join(join)
      .where(where);

    return query.changes().asyncMap(
            (change) => change.results.asStream().map(
                (result) {
                  var machineProps = result.dictionary("machineDS")!;
                  return Engagement(MutableDocument({
                    'id': result.string('id'),
                    'ownerID': machineProps.string('owner'),
                    'firstname': result.string('firstname'),
                    'lastname': result.string('lastname'),
                    'owner': '${result.string('firstname')!} ${result.string('lastname')!}',
                    'address': result.string('address'),
                    'phone': result.string('phone'),
                    'model': machineProps.string('model'),
                    'fluel': machineProps.string('fluel'),
                    'number': machineProps.string('number'),
                    'registeredCode': machineProps.string('registeredCode'),
                    'deadline': machineProps.string('deadline'),
                    'lastDeadline': machineProps.string('lastDeadline'),
                    'lastMark': machineProps.string('lastMark'),
                  }));
                }
            ).toList(),
    );
  }
}