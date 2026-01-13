import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    // Use Sao Paulo as default if possible, or local
    try {
        tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
    } catch (e) {
        // Fallback to local if exact timezone not found (though latest_all should have it)
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
     await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleMonthlyReminder({
    required int dayOfMonth,
    required int hour,
    required String title,
    required String body,
  }) async {
     // Schedule for the next occurrence of dayOfMonth at hour:00
    final now = tz.TZDateTime.now(tz.local);
    var nextDate = tz.TZDateTime(tz.local, now.year, now.month, dayOfMonth, hour);
    
    if (nextDate.isBefore(now)) {
       // If today is past the target day, schedule for next month
       // Handling year rollover automatically via DateTime constructor
       nextDate = tz.TZDateTime(tz.local, now.year, now.month + 1, dayOfMonth, hour);
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID 0 for Monthly Review
      title,
      body,
      nextDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'monthly_review_channel',
          'Revisão Mensal',
          channelDescription: 'Lembrete para revisar seus compromissos mensais',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
