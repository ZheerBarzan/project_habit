import 'package:isar/isar.dart';

part 'app_set.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;

  DateTime? firstLunchDate;
}
