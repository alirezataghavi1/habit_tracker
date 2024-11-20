import 'package:flutter/material.dart';
import 'dart:async';
import 'habit_tracker.dart';
import 'add_habit_screen.dart';
import 'notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HabitTracker _habitTracker = HabitTracker();
  final NotificationService _notificationService = NotificationService();
  Timer? _timer;
  DateTime? _lastResetTime;

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    _habitTracker.loadHabits().then((_) {
      setState(() {});
    });
    _initializeTimers();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (_lastResetTime == null ||
          now.difference(_lastResetTime!).inHours >= 24) {
        _resetDailyProgress();
      }
      setState(() {});
    });
  }

  void _resetDailyProgress() {
    _lastResetTime = DateTime.now();
    setState(() {
      for (var habit in _habitTracker.habits) {
        if (habit['completedToday'] == true) {
          habit['streak'] += 1;
        } else {
          habit['streak'] = 0;
        }
        habit['completedToday'] = false;
      }
    });
  }

  void _trackHabit(int index) {
    setState(() {
      final habit = _habitTracker.habits[index];
      habit['completedToday'] = !(habit['completedToday'] ?? false);
    });
  }

  void _deleteHabit(BuildContext context, int index) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text(
            "Confirm Deletion",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this habit?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      setState(() {
        _habitTracker.habits.removeAt(index);
      });
    }
  }

  String _getTimeRemainingUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final difference = midnight.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final totalHabits = _habitTracker.habits.length;
    final completedToday = _habitTracker.habits
        .where((habit) => habit['completedToday'] == true)
        .length;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Column(
        children: [
          _buildSummarySection(totalHabits, completedToday),
          Expanded(
  child: _habitTracker.habits.isEmpty
      ? _buildEmptyState()
      : ListView.builder(
          itemCount: _habitTracker.habits.length,
          itemBuilder: (context, index) {
            final habit = _habitTracker.habits[index];
            final streak = habit['streak'] ?? 0;
            final progress = streak / 365;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: streak >= 365 ? Colors.amber : Colors.grey[850],
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // گوشه‌های گرد
                ),
                elevation: 5, // اضافه کردن سایه برای زیبایی بیشتر
                child: Dismissible(
                  key: Key(habit['name']),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF333333),
                              title: const Text(
                                "Confirm Deletion",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                "Are you sure you want to delete this habit?",
                                style: TextStyle(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                  },
                  onDismissed: (_) {
                    setState(() {
                      _habitTracker.habits.removeAt(index);
                    });
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 41, 26),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      habit['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Streak: $streak',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[700],
                          color: streak >= 365 ? Colors.yellow : Colors.green,
                        ),
                      ],
                    ),
                    trailing: Checkbox(
                      value: habit['completedToday'] ?? false,
                      onChanged: (_) => _trackHabit(index),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time until midnight: ${_getTimeRemainingUntilMidnight()}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewHabit,
        backgroundColor: const Color(0xFFFFD700),
        tooltip: 'Add a new habit',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewHabit() async {
    final newHabit = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddHabitScreen()),
    );
    if (newHabit != null) {
      await _habitTracker.addHabit(newHabit);
      setState(() {});
    }
  }

  Widget _buildSummarySection(int totalHabits, int completedToday) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard('Total Habits', '$totalHabits'),
          _buildSummaryCard('Completed Today', '$completedToday/$totalHabits'),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.hourglass_empty, size: 100, color: Color(0xFFFFD700)),
          SizedBox(height: 20),
          Text(
            "No habits added yet.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
