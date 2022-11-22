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
import 'package:gestio/domain/customer/Customer.dart';
import 'package:gestio/infrastructure/services/db/DatabaseHelper.dart';

class CustomerRepository {

  Future<Customer> createCustomer(
      String firstname, String lastname, String address, String? phone) async {
    final document = MutableDocument({
      'type': 'customer',
      'createdAt': DateTime.now(),
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'phone': phone,
    });
    await DatabaseHelper.instance.database!.saveDocument(document);
    return Customer(document);
  }

  Future<bool> updateCustomer(String id, String firstname, String lastname,
      String address, String? phone) async {
    final doc = await DatabaseHelper.instance.database!.document(id);
    final mutableDoc = doc!.toMutable();

    mutableDoc.setValue(firstname, key: 'firstname');
    mutableDoc.setValue(lastname, key: 'lastname');
    mutableDoc.setValue(address, key: 'address');
    mutableDoc.setValue(phone, key: 'phone');
    return await DatabaseHelper.instance.database!.saveDocument(mutableDoc);
  }

  Future<bool> deleteCustomer(String id) async {
    final doc = await DatabaseHelper.instance.database!.document(id);
    return await DatabaseHelper.instance.database!.deleteDocument(doc!);
  }

  Stream<List<Customer>> allCustomerStream() {
    final query = const QueryBuilder()
        .select(
          SelectResult.expression(Meta.id),
          SelectResult.property('createdAt'),
          SelectResult.property('firstname'),
          SelectResult.property('lastname'),
          SelectResult.property('address'),
          SelectResult.property('phone'),
        )
        .from(DataSource.database(DatabaseHelper.instance.database!))
        .where(
          Expression.property('type').equalTo(Expression.value('customer')),
        )
        .orderBy(Ordering.property('createdAt'));

    return query.changes().asyncMap(
          (change) => change.results.asStream().map(Customer.new).toList(),
        );
  }
}
