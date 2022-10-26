import 'package:cbl/cbl.dart';
import 'package:gestio/infrastructure/services/db/ExtensionDictionary.dart';
import 'package:gestio/domain/log/LogMessageAbstract.dart';

class CblLogMessage extends LogMessageAbstract {
  final DictionaryInterface dict;
  CblLogMessage(this.dict);

  @override
  String get id => dict.documentId;

  @override
  DateTime get createdAt => dict.value('createdAt')!;

  @override
  String get message => dict.value('message')!;
}
