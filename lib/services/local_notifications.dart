import 'package:dronebag/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initState() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings);
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    _notificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
            android: AndroidNotificationDetails('channelid', 'channelname',
                importance: Importance.max, priority: Priority.high)));
  }
}
