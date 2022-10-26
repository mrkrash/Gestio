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
import 'package:gestio/domain/engagement/EngagementAbstract.dart';

class Engagement extends EngagementAbstract {
  final DictionaryInterface dict;
  Engagement(this.dict);

  @override
  String get id => dict.value('id')!;

  @override
  String get ownerID => dict.value('ownerID')!;

  @override
  String get owner => dict.value('owner')!;

  @override
  String get firstname => dict.value('firstname')!;

  @override
  String get lastname => dict.value('lastname')!;

  @override
  String get address => dict.value('address')!;

  @override
  String? get phone => dict.value('phone');

  @override
  DateTime get deadline => dict.value('deadline')!;

  @override
  DateTime? get lastDeadline => dict.value('lastDeadline');

  @override
  DateTime? get lastMark => dict.value('lastMark');

  @override
  String get model => dict.value('model')!;

  @override
  String get fluel => dict.value('fluel')!;

  @override
  String get number => dict.value('number')!;

  @override
  String get registeredCode => dict.value('registeredCode')!;
}
