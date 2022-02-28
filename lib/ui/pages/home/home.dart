// @dart=2.9
import 'dart:async';
import 'dart:ui';
import 'package:chat/composition_root.dart';
import 'package:chat/main.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/app_theme.dart';
import 'package:chat/colors.dart';
import 'package:chat/state_mangement/home/chats_cubit.dart';
import 'package:chat/state_mangement/home/home_cubit.dart';
import 'package:chat/state_mangement/home/home_state.dart';
import 'package:chat/state_mangement/message/message_bloc.dart';
import 'package:chat/ui/pages/home/home_router.dart';
import 'package:chat/ui/widgets/home/active/active_users.dart';
import 'package:chat/ui/widgets/home/chats/chats.dart';
import 'package:chat/ui/widgets/home/my_tab_bar.dart';
import 'package:chat/ui/widgets/home/new_search.dart';
import 'package:chat/ui/widgets/home/profile_image.dart';
import 'package:chat/ui/widgets/home/search/search.dart';
import 'package:chat/ui/widgets/shared/header_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  const Home(this.me, this.router);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User _user;
  var chats = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();
    _initGameNotification();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: ProfileImage(
            imageUrl: _user.photoUrl,
            online: _user.active,
          ),
          title: Text(
            'Chat App',
            style: MyTheme.kAppTitle,
          ),
        ),
        backgroundColor: isLightTheme(context) ? kPrimary : kPrimaryColor,
        body: Column(
          children: [
            MyTabBar(),
            Expanded(
                child: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isLightTheme(context) ? Colors.white : Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: TabBarView(
                children: [
                  Chats(_user, widget.router, chats),

                  SearchBar(_user, widget.router)
                ],
              ),
            )),
          ],
        ),

      ),
    );
  }

  _initialSetup() async {
    // final user =
    //     (!_user.active) ? await context.read<HomeCubit>().connect() : _user;

    context.read<ChatsCubit>().chats();
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(_user));
  }

  @override
  bool get wantKeepAlive => true;







  _initGameNotification() async{
    FirebaseMessaging.onBackgroundMessage((message)async{
      RemoteNotification notification = message.notification;

      if (notification != null
      // && android != null
      ) {
        if (message.data['notificationType'] == 'message'){
          final senderId = message.data['senderId'];
          User challenger = await context.read<HomeCubit>().fetch(senderId);
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
          // handleMessage(message.data);
          // _showAcceptanceDialog(challenger);
          print(message.data);

        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
      RemoteNotification notification = message.notification;

      // AndroidNotification android = message.notification?.android;
      if (notification != null
          // && android != null
      ) {


    }});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      print(notification.body);
      // AndroidNotification android = message.notification?.android;
      if (notification != null
          // && android != null
      ) {
        if (message.data['notificationType'] == 'message'){
          final senderId = message.data['senderId'];
          User challenger = await context.read<HomeCubit>().fetch(senderId);
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
          // handleMessage(message.data);
          // _showAcceptanceDialog(challenger);
          print(message.data);

        }
      }
    });


  }
}

