import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.actionId == 'disconnect_vpn') {
    final openVPN = OpenVPN();
    openVPN.disconnect();
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'disconnect_vpn') {
          OpenVPN().disconnect();
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showVpnNotification(
    String title,
    String body, {
    bool connected = false,
  }) async {
    final List<AndroidNotificationAction> actions = [];
    if (connected) {
      actions.add(
        const AndroidNotificationAction(
          'disconnect_vpn',
          'Disconnect',
          cancelNotification: true,
          showsUserInterface: false,
        ),
      );
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'vpn_status_channel',
          'VPN Status',
          channelDescription: 'Shows the current status of the VPN connection',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          actions: actions,
        );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 888,
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(id: 888);
  }
}
