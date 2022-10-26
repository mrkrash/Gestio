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

abstract class EngagementAbstract {
  String get id;
  String get ownerID;
  String get firstname;
  String get lastname;
  String get owner;
  String get address;
  String? get phone;
  String get model;
  String get fluel;
  String get number;
  String get registeredCode;
  DateTime get deadline;
  DateTime? get lastDeadline;
  DateTime? get lastMark;
}