import 'package:cbl/cbl.dart';
import 'package:gestio/db/ExtensionDictionary.dart';
import 'package:gestio/document/EngagementAbstract.dart';

class Engagement extends EngagementAbstract {
  final DictionaryInterface dict;
  Engagement(this.dict);

  @override
  String get id => dict.documentId;

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
