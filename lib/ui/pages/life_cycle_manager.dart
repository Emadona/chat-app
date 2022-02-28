// @dart=2.9
import 'dart:async';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/state_mangement/home/chats_cubit.dart';
import 'package:chat/state_mangement/life_cycle_cubit/life_cycle_cubit.dart';
import 'package:chat/state_mangement/message/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  final User user;

  const LifeCycleManager(this.child, this.user);

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin localNotifications;
  User _user;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    _user = widget.user;
    _initStateSetup();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<LifeCycleCubit>().connect();
    _user.active = true;
  }

  _initStateSetup() async {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _user.active = true;

      context.read<LifeCycleCubit>().connect();
    } else if (AppLifecycleState.paused == state ||
        AppLifecycleState.detached == state ||
        AppLifecycleState.inactive == state) {
      context.read<LifeCycleCubit>().disconnect();
      _user.active = false;
    }
  }

  sendGameNotification() {

  }
}