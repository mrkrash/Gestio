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

  Future<bool> updateMachine(String id, String owner, String model, String fluel,
      String? number, String? registeredCode, DateTime? lastMark,
      DateTime? lastDeadline, DateTime? deadline) async {
    final doc = await _database.document(id);
    final mutableDoc = doc!.toMutable();

    mutableDoc.setValue(owner, key: 'owner');
    mutableDoc.setValue(model, key: 'model');
    mutableDoc.setValue(fluel, key: 'fluel');
    mutableDoc.setValue(number, key: 'number');
    mutableDoc.setValue(registeredCode, key: 'registeredCode');
    mutableDoc.setValue(lastMark, key: 'lastMark');
    mutableDoc.setValue(lastDeadline, key: 'lastDeadline');
    mutableDoc.setValue(deadline, key: 'deadline');
    return await _database.saveDocument(mutableDoc);
  }
}