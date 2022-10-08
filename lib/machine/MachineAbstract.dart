abstract class MachineAbstract {
  String get id;
  DateTime get createdAt;
  String get owner;
  String get model;
  String get fluel;
  String? get number;
  String? get registeredCode;
  DateTime? get deadline;
  List<DateTime>? get deadlines;
  List<DateTime>? get marks;
}