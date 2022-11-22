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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:gestio/domain/setting/Setting.dart';
import 'package:gestio/infrastructure/repositories/SettingRepository.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late AppLocalizations t;
  late Setting yearDeadline;
  late Setting yearMark;

  final TextEditingController _deadlineCheckController = TextEditingController();
  final TextEditingController _deadlineMarkController = TextEditingController();
  final SettingRepository _settingRepository = SettingRepository();

  @override
  Widget build(BuildContext context) {
    t = AppLocalizations.of(context)!;

    _settingRepository.get('yearDeadline').then(
            (setting) {
              yearDeadline = setting;
              _deadlineCheckController.text = setting.value;
            }
    );
    _settingRepository.get('yearMark').then(
            (setting) {
              yearMark = setting;
              _deadlineMarkController.text = setting.value;
            }
    );
    return Scaffold(
      appBar: AppBar(title: Text(t.settings),),
      body: SettingsList(
        platform: DevicePlatform.windows,
        sections: [
          SettingsSection(
              tiles: [
                CustomSettingsTile(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsetsDirectional.only(
                          start: 14,
                          top: 12,
                          bottom: 30,
                          end: 14
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.deadlineMark,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    t.deadlineMarkDescription,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.5,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                              width: 100,
                              child: TextField(
                                controller: _deadlineMarkController,
                                onChanged: (value) async {
                                  _settingRepository.update(yearMark.id, value);
                                },
                              ),
                          ),
                        ],
                      ),
                    ),
                ),
                CustomSettingsTile(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsetsDirectional.only(
                        start: 14,
                        top: 12,
                        bottom: 30,
                        end: 14
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.deadlineCheck,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  t.deadlineCheckDescription,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.5,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            )
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _deadlineCheckController,
                            onChanged: (value) async {
                              _settingRepository.update(yearDeadline.id, value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          )
        ],
      )
    );
  }
}