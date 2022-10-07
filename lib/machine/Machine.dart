import 'package:cbl/cbl.dart';
import 'package:gestio/machine/MachineAbstract.dart';
import 'package:gestio/db/ExtensionDictionary.dart';

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
  String get type => dict.value('type')!;

  @override
  List<DateTime>? get deadlines => dict.value('deadlines');

  @override
  // TODO: implement deadline
  DateTime? get deadline => dict.value('deadline');

  @override
  // TODO: implement marks
  List<DateTime>? get marks => dict.value('marks');
}