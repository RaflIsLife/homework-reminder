
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //SETUP INISIALISASI
  Future<void> initNotification() async {
    if (_isInitialized) return; //MENCEGAH INISIALISASI ULANG

    //INIT TIMEZONE
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    //SETUP INISIALISASI ANDROID
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //SETUP INISIALISASI IOS
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //SETUP INISIALISASI ANDROID & IOS
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    //INISIALISASI
    await notificationsPlugin.initialize(initSettings);
  }

  //SETUP DETAIL NOTIFIKASI
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'pengingat_channel_id',
        'Pengingat Notifikasi',
        channelDescription: 'Pengingat notifikasi deskripsi',
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //SHOW NOTIFICATION
  Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  //SHOW SCHEDULED NOTIFICATION

  Future<void> showScheduleNotifications({
    required index,
    required String title,
    required String body,
    required DateTime dateTimeNoti,
  }) async {
    //Manual time format:
    // final dateNotiString =
    //     dateTimeNoti.toString().replaceRange(10, null, '').split('-');
    // final timeNotiString = dateTimeNoti
    //     .toString()
    //     .replaceRange(0, 11, '')
    //     .replaceRange(5, null, '')
    //     .split(':');
    // final List<int> dateNoti = dateNotiString.map(int.parse).toList();
    // final List<int> timeNoti = timeNotiString.map(int.parse).toList();
 
    // var notificationsDate = tz.TZDateTime(
    //   tz.local,
    //   dateNoti[0],
    //   dateNoti[1],
    //   dateNoti[2],
    //   timeNoti[0],
    //   timeNoti[1],
    // );
    // final now = tz.TZDateTime.now(tz.local);

    var scheduleDate = tz.TZDateTime.from(
      dateTimeNoti.toLocal(),
      tz.local,
    );

    await notificationsPlugin.zonedSchedule(
      index,
      title,
      body,
      scheduleDate,
      notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification({required index}) async {
    notificationsPlugin.cancel(index);
    print("Notifikasi di cancel");
  }
 
  Future<void> cancelAllNotification() async {
    await notificationsPlugin.cancelAll();
    print("semua Notifikasi di hapus");
  }
}
