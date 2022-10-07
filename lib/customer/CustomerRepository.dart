import 'package:cbl/cbl.dart';
import 'package:gestio/customer/Customer.dart';

import '../machine/Machine.dart';
import 'CustomerAbstract.dart';

class CustomerRepository {
  final Database _database;

  CustomerRepository(this._database);

  Future<Customer> createCustomer(
      String firstname, String lastname, String address, String? email, List<Machine>? machines) async {
    final document = MutableDocument({
      'type': 'customer',
      'createdAt': DateTime.now(),
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'email': email,
      'machines' : machines,
    });
    print(document);
    await _database.saveDocument(document);
    return Customer(document);
  }

  Future<bool> updateCustomer(String id, String firstname, String lastname,
      String address, String? email) async {
    final doc = await _database.document(id);
    final mutableDoc = doc!.toMutable();

    mutableDoc.setValue(firstname, key: 'firstname');
    mutableDoc.setValue(lastname, key: 'lastname');
    mutableDoc.setValue(address, key: 'address');
    mutableDoc.setValue(email, key: 'email');
    return await _database.saveDocument(mutableDoc);
  }

  Future<bool> deleteCustomer(String id) async {
    final doc = await _database.document(id);
    return await _database.deleteDocument(doc!);
  }

  Stream<List<Customer>> allCustomerStream() {
    final query = const QueryBuilder()
        .select(
          SelectResult.expression(Meta.id),
          SelectResult.property('createdAt'),
          SelectResult.property('firstname'),
          SelectResult.property('lastname'),
          SelectResult.property('address'),
          SelectResult.property('email'),
        )
        .from(DataSource.database(_database))
        .where(
          Expression.property('type').equalTo(Expression.value('customer')),
        )
        .orderBy(Ordering.property('createdAt'));

    Future(query.explain).then(print);

    return query.changes().asyncMap(
          (change) => change.results.asStream().map(Customer.new).toList(),
        );
  }
}
