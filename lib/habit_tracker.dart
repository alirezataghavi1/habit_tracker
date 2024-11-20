import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HabitTracker {
  List<Map<String, dynamic>> habits = [];

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('habits', jsonEncode(habits)); // Save directly without assigning prefs again
  }

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      habits = List<Map<String, dynamic>>.from(jsonDecode(habitsJson));
    }
  }

  Future<void> addHabit(String habitName) async {
    habits.add({
      'name': habitName,
      'startDate': DateTime.now().toIso8601String(),
      'lastChecked': DateTime.now().toIso8601String(),
      'streak': 0,
      'totalDays': 365,
    });
    await _saveHabits();
  }

  Future<bool> markHabitProgress(int index) async {
    final habit = habits[index];
    final currentTime = DateTime.now();
    final lastChecked = DateTime.parse(habit['lastChecked'] as String);
    final timeDifference = currentTime.difference(lastChecked).inHours;

    if (timeDifference >= 24 || habit['streak'] == 0) {
      habit['streak'] += 1;
      habit['lastChecked'] = currentTime.toIso8601String();
      await _saveHabits(); // Only save after updating habit
      return true;
    } else {
      return false;
    }
  }

  String calculateDaysSinceStart(int index) {
    final habit = habits[index];
    final startDate = DateTime.parse(habit['startDate']);
    final difference = DateTime.now().difference(startDate).inDays;
    return '$difference days since start';
  }

  String getTimeLeft(int index) {
    final habit = habits[index];
    final lastChecked = DateTime.parse(habit['lastChecked']);
    final timeDifference = DateTime.now().difference(lastChecked);
    final remainingTime = Duration(hours: 24) - timeDifference;

    if (remainingTime.isNegative) {
      return "Now";
    } else {
      final hours = remainingTime.inHours;
      final minutes = remainingTime.inMinutes % 60;
      return '$hours hours $minutes minutes left';
    }
  }
}
