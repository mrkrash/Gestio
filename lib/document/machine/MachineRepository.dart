import 'package:cbl/cbl.dart';

import 'Machine.dart';

class MachineRepository {
  final Database _database;
  MachineRepository(this._database);

  Future<Machine> createMachine(
      String owner, String model, String fluel, String? number,
      String? registeredCode, DateTime? lastMark, DateTime? lastDeadline,
      DateTime? deadline
      ) async {
    final document = MutableDocument({
      'type': 'machine',
      'createdAt': DateTime.now(),
      'owner': owner,
      'model': model,
      'fluel': fluel,
      'number': number,
      'registeredCode': registeredCode,
      'lastMark': lastMark,
      'lastDeadline': lastDeadline,
      'deadline': deadline,
    });
    await _database.saveDocument(document);
    return Machine(document);
  }
}