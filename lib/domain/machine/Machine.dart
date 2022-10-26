import 'package:cbl/cbl.dart';
import 'package:gestio/domain/machine/MachineAbstract.dart';
import 'package:gestio/infrastructure/services/db/ExtensionDictionary.dart';

class Machine extends MachineAbstract {
  final DictionaryInterface dict;
  Machine(this.dict);

  @override
  String get id => dict.documentId;

  @override
  DateTime get createdAt => dict.value('createdAt')!;

  @override
  String get fluel => dict.value('fluel')!;

  @override
  String? get number => dict.value('number');

  @override
  String? get registeredCode => dict.value('registeredCode');

  @override
  String get model => dict.value('model')!;

  @override
  DateTime? get lastDeadline => dict.value('lastDeadline');

  @override
  DateTime? get deadline => dict.value('deadline');

  @override
  DateTime? get lastMark => dict.value('lastMark');

  @override
  String get owner => dict.value('owner')!;
}