import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_habit/model/app_set.dart';
import 'package:project_habit/model/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

// setup

// initialization

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

// save first date in the database

  Future<void> saveFirstLuanchDate() async {
    final exsitingSettings = await isar.appSettings.where().findFirst();
    if (exsitingSettings == null) {
      final settings = AppSettings()..firstLunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

//get first date at startup
  Future<DateTime?> getFirstLunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLunchDate;
  }
// crud operations

//list of habits

//create

//read

//update check habit on or off

//update edit habit name

// delete habit
}
