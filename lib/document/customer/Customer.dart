import 'package:cbl/cbl.dart';
import 'package:gestio/db/ExtensionDictionary.dart';
import 'package:gestio/document/customer/CustomerAbstract.dart';

class Customer extends CustomerAbstract {
  final DictionaryInterface dict;
  Customer(this.dict);

  @override
  String get id => dict.documentId;

  @override
  DateTime get createdAt => dict.value('createdAt')!;

  @override
  String get firstname => dict.value('firstname')!;
  @override
  String get lastname => dict.value('lastname')!;

  @override
  String get address => dict.value('address')!;

  @override
  String? get email => dict.value('email');

  @override
  String? get phone => dict.value('phone');
}
