import 'package:cbl/cbl.dart';
import 'package:gestio/document/EngagementAbstract.dart';

class Engagement extends EngagementAbstract {
  final DictionaryInterface dict;
  Engagement(this.dict);

  @override
  String get address => dict.value('address')!;

  @override
  DateTime get deadline => dict.value('deadline')!;

  @override
  DateTime? get lastDeadline => dict.value('lastDeadline');

  @override
  DateTime? get lastMark => dict.value('lastMark');

  @override
  String get model => dict.value('model')!;

  @override
  String get number => dict.value('number')!;

  @override
  String get owner => dict.value('owner')!;

  @override
  String get registeredCode => dict.value('registeredCode')!;
}
