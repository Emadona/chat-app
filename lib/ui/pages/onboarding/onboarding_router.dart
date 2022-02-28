// @dart=2.9
import 'package:chatapp/chat.dart';
import 'package:flutter/material.dart';

abstract class IOnboardingRouter {
  void onSessionSuccess(BuildContext context, User me);
}

class OnboardingRouter implements IOnboardingRouter {
  final Widget Function(User me) onSessionConnected;

  OnboardingRouter(this.onSessionConnected);

  @override
  void onSessionSuccess(context, me) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => onSessionConnected(me)),
        (Route<dynamic> route) => false);
  }
}
