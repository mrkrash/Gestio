import '../machine/Machine.dart';

abstract class CustomerAbstract {
  String get id;
  DateTime get createdAt;
  String get firstname;
  String get lastname;
  String get address;
  String? get phone;
  String? get email;
}
