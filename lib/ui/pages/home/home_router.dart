// @dart=2.9
import 'package:chatapp/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {String chatId});
  onShowGameBoard(BuildContext context, User me, User receiver, {String gameId});
}

class HomeRouter implements IHomeRouter {
  final Widget Function(User receiver, User me, {String chatId})
      showMessageThread;
  final Widget Function(User me, User receiver, {String gameId})
  showGameBoard;

  HomeRouter({this.showMessageThread, this.showGameBoard});

  @override
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {String chatId}) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => showMessageThread(receiver, me, chatId: chatId)));
  }

  @override
  Future<void> onShowGameBoard(BuildContext context, User me, User receiver, {String gameId}) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => showGameBoard(me,receiver, gameId: gameId)));
  }
}
