import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    // Ios initialization
    const initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(iOS: initializationSettingsIOS);

    // the initialization settings are initialized after they are setted
    await _notifications.initialize(initializationSettings);
  }

  //showing notification function
  Future<void> showDailyNotification({required String setTime}) async {
    //Notification setting main function
    setNotification() async {
      final pref = await SharedPreferences.getInstance();
      final currentTime = DateTime.now();
      final notTimeMng = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 10, 00);
      final notTimeEvg = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 14, 00);

      const detail = NotificationDetails(
        iOS: DarwinNotificationDetails(
          sound: 'notification.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      const title = '🔥Refreshment is coming!!';
      const body = 'Place your order for refreshment';
      // 10 AM

      for (int i = 0; i < 8; i++) {
        final notificationTimeMorning = notTimeMng.add(Duration(days: i));
        final notificationTimeEvening = notTimeEvg.add(Duration(days: i));

        //Morning notification
        if (notificationTimeMorning.weekday != 7) {
          if (currentTime.hour >= 10 && i == 0) {
            print('Morning time already passed');
          } else {
            log("Notification set for mng $notificationTimeMorning");
            _notifications.zonedSchedule(
              i + 1,
              title,
              body,
              tz.TZDateTime.from(notificationTimeMorning, tz.local),
              detail,
              uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true,
            );
          }
        }

        //Evening notificaiton
        if (notificationTimeEvening.weekday != 7) {
          if (currentTime.hour >= 14 && i == 0) {
            print('Evening time already passed');
          } else {
            log("Notification set for Evg $notificationTimeEvening");
            _notifications.zonedSchedule(
              i + 10,
              title,
              body,
              tz.TZDateTime.from(notificationTimeEvening, tz.local),
              detail,
              uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true,
            );
          }
        }
      }

      //Setting time in shared preference
      await pref.setString('NotificationSetTime', currentTime.toString());
    }

    DateTime currentTime = DateTime.now();
    if (setTime.isNotEmpty) {
      final notificationSetTime = DateTime.parse(setTime);
      if (currentTime
          .compareTo(notificationSetTime.add(const Duration(days: 6))) >
          0) {
        //notification set time is passed
        setNotification();
      }
    } else {
      //first time notification setting
      setNotification();
    }
  }
}