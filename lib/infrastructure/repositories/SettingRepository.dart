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
import 'package:gestio/infrastructure/services/db/DatabaseHelper.dart';
import 'package:gestio/domain/setting/Setting.dart';

class SettingRepository {
  Future<Setting> update(String id, String value) async {
    final document = (await DatabaseHelper.instance.database!.document(id))!;
    var mutable = document.toMutable();
    mutable.setString(value, key: 'value');
    await DatabaseHelper.instance.database!.saveDocument(mutable);

    return Setting(document);
  }

  Future<Setting> get(String key) async {
    final query = const QueryBuilder()
        .select(
          SelectResult.expression(Meta.id),
          SelectResult.property('value')
        )
        .from(DataSource.database(DatabaseHelper.instance.database!))
        .where(
            Expression.property('type').equalTo(Expression.value('setting'))
                .and(Expression.property('key').equalTo(Expression.value(key)))
        );
    var resultSet = await query.execute();
    var rAll = await resultSet.allResults();

    return Setting(rAll.first);
  }

  Future<String> getValue(String key) async {
    var setting = await get(key);
    return setting.value;
  }
}