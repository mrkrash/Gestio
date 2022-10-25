import 'package:cbl/cbl.dart';

import 'Machine.dart';

class MachineRepository {
  static const yearMark = 4;
  static const yearDeadline = 2;

  final Database _database;
  MachineRepository(this._database);

  DateTime _deadline(
      DateTime? deadline,
      DateTime? lastMark,
      DateTime? lastDeadline) {
    if (deadline != null) {
      return deadline;
    }
    var _lastMark = lastMark?.add(const Duration(days: 365 * yearMark));
    var _lastDeadline = lastDeadline?.add(const Duration(days: 365 * yearDeadline));
    if (_lastMark != null && _lastDeadline != null) {
      if (_lastMark.isAfter(_lastDeadline)) {
        return _lastDeadline;
      } else {
        return _lastMark;
      }
    }
    if (_lastDeadline != null) {
      return _lastDeadline;
    }
    if (_lastMark != null) {
      return _lastMark;
    }
    return DateTime.now();
  }

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
      'deadline': _deadline(deadline, lastMark, lastDeadline),
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
    mutableDoc.setValue(_deadline(deadline, lastMark, lastDeadline), key: 'deadline');
    return await _database.saveDocument(mutableDoc);
  }
}