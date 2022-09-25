import 'package:cbl/cbl.dart';
import 'package:gestio/db/ExtensionDictionary.dart';
import 'package:gestio/log/LogMessageAbstract.dart';

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
