import 'package:dairytenantapp/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showDownloadNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'download_channel',
        'Download Notifications',
        // 'Channel for download notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await localNotificationsPlugin.show(
    0,
    'Download Complete',
    'Your file has been downloaded successfully.',
    platformChannelSpecifics,
    payload: 'item x',
  );
}
