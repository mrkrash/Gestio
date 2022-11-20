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
import 'package:gestio/domain/setting/SettingAbstract.dart';
import 'package:gestio/infrastructure/services/db/ExtensionDictionary.dart';

class Setting extends SettingAbstract {
  final DictionaryInterface dict;
  Setting(this.dict);

  @override
  String get id => dict.documentId;

  @override
  String get key => dict.value('key')!;

  @override
  DateTime get updatedAt => dict.value('updatedAt')!;

  @override
  String get value => dict.value('value')!;

}