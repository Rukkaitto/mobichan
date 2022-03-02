import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  GlobalKey<NavigatorState> navigatorKey;

  NotificationManager({required this.navigatorKey});

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(token).set(
      {
        'getsNotifications': prefs.getBool('notifications') ?? true,
      },
      SetOptions(merge: true),
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_name');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.id,
              channelDescription: channel.description,
              importance: channel.importance,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _onSelectNotification(String? payload) {
    if (payload == null) return;
    final data = Map<String, dynamic>.from(jsonDecode(payload));
    _handleNotificationTap(data);
  }

  void _handleMessage(RemoteMessage message) {
    _handleNotificationTap(message.data);
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final String board = data['board_id'];
    final String title = data['board_title'];
    final wsBoard = int.parse(data['board_ws']);
    final thread = int.parse(data['thread']);

    navigatorKey.currentState?.pushNamed(
      ThreadPage.routeName,
      arguments: ThreadPageArguments(
        board: Board(board: board, title: title, wsBoard: wsBoard),
        thread: Post(no: thread),
      ),
    );
  }
}
