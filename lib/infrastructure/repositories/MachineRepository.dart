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
import 'package:gestio/domain/machine/Machine.dart';
import 'package:gestio/infrastructure/services/db/DatabaseHelper.dart';
import 'SettingRepository.dart';

class MachineRepository {

  Future<DateTime> _deadline(
      DateTime? deadline,
      DateTime? lastMark,
      DateTime? lastDeadline) async {
    if (deadline != null) {
      return deadline;
    }
    final SettingRepository settingRepository = SettingRepository();
    var yearDeadline = int.parse(await settingRepository.getValue('yearDeadline'));
    var yearMark = int.parse(await settingRepository.getValue('yearMark'));

    var _lastMark = lastMark?.add(Duration(days: 365 * yearMark));
    var _lastDeadline = lastDeadline?.add(Duration(days: 365 * yearDeadline));
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
    final newDeadline = await _deadline(deadline, lastMark, lastDeadline);
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
      'deadline': newDeadline,
    });
    await DatabaseHelper.instance.database!.saveDocument(document);
    return Machine(document);
  }

  Future<bool> updateDeadline(String id, DateTime deadline) async {
    final doc = await DatabaseHelper.instance.database!.document(id);
    final mutableDoc = doc!.toMutable();
    final newDeadline = await _deadline(null, null, deadline);
    mutableDoc.setValue(deadline, key: 'lastDeadline');
    mutableDoc.setValue(newDeadline, key: 'deadline');

    return await DatabaseHelper.instance.database!.saveDocument(mutableDoc);
  }

  Future<bool> updateMachine(String id, String owner, String model, String fluel,
      String? number, String? registeredCode, DateTime? lastMark,
      DateTime? lastDeadline, DateTime? deadline) async {
    final doc = await DatabaseHelper.instance.database!.document(id);
    final mutableDoc = doc!.toMutable();
    final newDeadline = await _deadline(null, null, deadline);

    mutableDoc.setValue(owner, key: 'owner');
    mutableDoc.setValue(model, key: 'model');
    mutableDoc.setValue(fluel, key: 'fluel');
    mutableDoc.setValue(number, key: 'number');
    mutableDoc.setValue(registeredCode, key: 'registeredCode');
    mutableDoc.setValue(lastMark, key: 'lastMark');
    mutableDoc.setValue(lastDeadline, key: 'lastDeadline');
    mutableDoc.setValue(newDeadline, key: 'deadline');
    return await DatabaseHelper.instance.database!.saveDocument(mutableDoc);
  }
}