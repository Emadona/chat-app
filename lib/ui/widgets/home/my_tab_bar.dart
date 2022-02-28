import 'package:chat/colors.dart';
import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../theme.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 16),
      height: 80,
      color: isLightTheme(context) ? kPrimary : kPrimaryColor,
      child: TabBar(
        indicator: ShapeDecoration(
            color: MyTheme.kAccentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        tabs: [
          Tab(
            icon: Text('Chats',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          Tab(
            icon: Text(
              'Search',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
