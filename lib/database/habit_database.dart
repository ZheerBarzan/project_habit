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
  final List<Habit> currentHabits = [];

//create

  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

//read

  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    notifyListeners();
  }

//update check habit on or off
  Future<void> updateHabitCompletion(int id, bool completed) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        if (completed && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }

        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

//update edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

// delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      isar.habits.delete(id);
    });
    readHabits();
  }
}
