import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> init() async {
    tz.initializeTimeZones(); // Initialize timezones for local notifications

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid, // Only Android initialization
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permissions
    await requestNotificationPermission();

    // Initialize the notification channel
    await _createNotificationChannel();
  }

  // Request notification permission
  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Create a notification channel for Android (required for API 26+)
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'habit_channel', // Channel ID
      'Habit Tracker', // Channel name
      description: 'Channel for habit notifications', // Channel description
      importance: Importance.max, // High importance to show notifications
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show a simple notification
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_channel', // Unique channel ID
      'Habit Tracker', // Channel name
      channelDescription: 'Channel for habit notifications', // Channel description
      importance: Importance.max, // High priority for immediate notification
      priority: Priority.high, // High priority to show immediately
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  // Schedule motivational notifications at regular intervals
  void scheduleMotivationNotifications() {
    const messages = [
       "Keep going! Every day counts!",
      "You're doing great, stay on track!",
      "Progress is progress, no matter how small!",
      "Believe in yourself and all that you are.",
      "Every step forward is a step towards success.",
      "Small progress is still progress.",
      "Don’t watch the clock; do what it does. Keep going.",
      "Stay focused on your goals, and make every day count.",
      "Persistence is the path to achievement.",
      "The journey of a thousand miles begins with a single step.",
      "You are capable of amazing things.",
      "Your only limit is you.",
      "Success is built on small, daily efforts.",
      "The only bad workout is the one you didn’t do.",
      "Strive for progress, not perfection.",
      "Dream big and dare to fail.",
      "Consistency is the key to growth.",
      "Be stronger than your excuses.",
      "Focus on your goal. Don’t look in any direction but ahead.",
      "Remember why you started.",
      "Make today count.",
      "Believe you can, and you’re halfway there.",
      "It’s never too late to start.",
      "Good things come to those who hustle.",
      "You’re doing better than you think.",
      "Success is the sum of small efforts repeated daily.",
      "Keep pushing, you’re almost there.",
      "Take it one day at a time.",
      "Your hard work will pay off.",
      "Don’t let yesterday take up too much of today.",
      "Great things never come from comfort zones.",
      "Work hard in silence, let your success make the noise.",
      "Push yourself, because no one else is going to do it for you.",
      "The difference between ordinary and extraordinary is that little extra.",
      "You don’t have to be great to start, but you have to start to be great.",
      "It always seems impossible until it’s done.",
      "Success doesn’t come to you; you go to it.",
      "Dream it. Believe it. Build it.",
      "The struggle you’re in today is developing the strength you need for tomorrow.",
      "The harder you work for something, the greater you’ll feel when you achieve it.",
      "You are stronger than you know.",
      "Start where you are. Use what you have. Do what you can.",
      "Keep believing in yourself.",
      "Small steps every day add up to big results.",
      "Set your goals high, and don’t stop until you get there.",
      "You are closer than you were yesterday.",
      "Stay positive, work hard, make it happen.",
      "Success is a journey, not a destination.",
      "Your dreams are worth it.",
      "Stay committed to your goals.",
      "The best way to predict the future is to create it.",
      "What you get by achieving your goals is not as important as what you become by achieving your goals.",
      "Focus on where you want to be, not where you were.",
      "Be proud of every step you take toward your goals.",
      "One day or day one. You decide.",
      "Believe in your vision and make it a reality.",
      "Never give up on a dream just because of the time it will take to accomplish it. The time will pass anyway.",
      "Success is the result of preparation, hard work, and learning from failure.",
      "Challenges are what make life interesting, and overcoming them is what makes life meaningful.",
      "Dream big, start small, act now.",
      "Your energy introduces you before you even speak.",
      "Today is another chance to get closer to your goals.",
      "Be the person who decided to go for it.",
      "You’re one step closer every day.",
      "Stay motivated, stay consistent, and you’ll reach your goals.",
      "The best project you’ll ever work on is yourself.",
      "Every accomplishment starts with the decision to try.",
      "Don’t stop when you’re tired. Stop when you’re done.",
      "Your goals don’t care about your excuses.",
      "Make yourself a priority.",
      "Focus on the journey, not just the destination.",
      "Wake up with determination; go to bed with satisfaction.",
      "Fall down seven times, stand up eight.",
      "Your future depends on what you do today.",
      "One day at a time, one goal at a time.",
      "Each day is a new opportunity to improve yourself.",
      "Success is not final; failure is not fatal: It is the courage to continue that counts.",
      "You are capable of more than you know.",
      "Every day brings new choices.",
      "Stay focused, stay humble, stay positive.",
      "Keep challenging yourself.",
      "The road to success is always under construction.",
      "Never lose sight of what matters most.",
      "Celebrate your small victories.",
      "Focus on progress, not perfection.",
      "Don't be afraid to start over. It's a new chance to rebuild what you want.",
      "You got this!",
      "Success is not for the lazy.",
      "Hard work beats talent when talent doesn’t work hard.",
      "It’s not about being the best. It’s about being better than you were yesterday.",
      "What you do today can improve all your tomorrows.",
      "Start each day with a positive thought and a grateful heart.",
      "Focus on your strengths, not your weaknesses.",
      "The best revenge is massive success.",
      "You are your only limit.",
      "Work hard, stay humble.",
      "Success is not for the ones who desire it; it’s for the ones who go out and work for it.",
      "Embrace the journey, even when it’s hard.",
      "Do something today that your future self will thank you for.",
      "Success is liking yourself, liking what you do, and liking how you do it.",
      "Keep your eyes on the stars and your feet on the ground.",
      "Trust the process."
    ];

    for (var i = 0; i < messages.length; i++) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        'Motivational Message', // Title for the notification
        messages[i], // Message content
        tz.TZDateTime.now(tz.local).add(Duration(hours: i * 3 + 8)), // Schedule time
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_channel', // Channel ID
            'Habit Tracker', // Channel name
            channelDescription: 'Motivational messages to keep you on track', // Channel description
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // New parameter added
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Trigger based on time of the day
      );
    }
  }
}
