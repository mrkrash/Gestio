import 'package:cbl/cbl.dart';
import 'package:gestio/db/DatabaseHelper.dart';
import 'package:gestio/document/Engagement.dart';
import 'package:gestio/document/customer/CustomerRepository.dart';
import 'package:gestio/document/machine/MachineRepository.dart';

class EngagementRepository {
  late final CustomerRepository _customerRepository;
  late final MachineRepository _machineRepository;

  EngagementRepository() {
    _customerRepository = CustomerRepository(DatabaseHelper.instance.database!);
    _machineRepository = MachineRepository(DatabaseHelper.instance.database!);
  }

  Future<Stream<List<Engagement>>> allDocumentStream(DateTime begin, DateTime end) async {
    String _begin = begin.toIso8601String();
    String _end = end.toIso8601String();
    final query = await Query.fromN1ql(DatabaseHelper.instance.database!,
      '''
      SELECT
        _._id AS id,
        _.owner AS ownerID,
        customer.firstname AS firstname,
        customer.lastname AS lastname,
        customer.address AS address,
        customer.phone AS phone,
        _.model AS model,
        _.fluel AS fluel,
        _.number AS number,
        _.registeredCode AS registeredCode,
        _.lastMark AS lastMark,
        _.lastDeadline AS lastDeadline,
        _.deadline AS deadline
      FROM _ JOIN _ AS customer ON _.owner = customer._id
      WHERE _.deadline >= "$_begin" AND _.deadline <= "$_end"
      ORDER BY _.deadline ASC
      '''
    );

    Future(query.explain).then(print);
    final resultSet = await query.execute();

    print(resultSet);

    return query.changes().asyncMap(
            (change) => change.results.asStream().map(
                (result) => Engagement(MutableDocument({
                  'id': result.string('id'),
                  'ownerID': result.string('ownerID'),
                  'firstname': result.string('firstname'),
                  'lastname': result.string('lastname'),
                  'owner': '${result.string('firstname')!} ${result.string('lastname')!}',
                  'address': result.string('address'),
                  'phone': result.string('phone'),
                  'model': result.string('model'),
                  'fluel': result.string('fluel'),
                  'number': result.string('number'),
                  'registeredCode': result.string('registeredCode'),
                  'deadline': result.string('deadline'),
                  'lastDeadline': result.array('deadlines')?.last.toString(),
                  'lastMark': result.array('marks')?.last.toString(),
                }))
            ).toList(),
    );
  }
}