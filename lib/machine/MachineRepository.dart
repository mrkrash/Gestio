import 'package:cbl/cbl.dart';

import 'Machine.dart';

class MachineRepository {
  final Database _database;
  MachineRepository(this._database);

  Future<Machine> createMachine(
      String owner, String model, String fluel, String? number,
      String? registeredCode
      ) async {
    final document = MutableDocument({
      'type': 'machine',
      'createdAt': DateTime.now(),
      'owner': owner,
      'model': model,
      'fluel': fluel,
      'number': number,
      'registeredCode': registeredCode,
    });
    await _database.saveDocument(document);
    return Machine(document);
  }
}