// @dart=2.9
import 'package:chatapp/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IMessageThreadRouter {
  Future<void> onTicTacGame(BuildContext context, User receiver, User me,
      {String chatId});
  onShowGameBoard(BuildContext context);
}

class MessageThreadRouter implements IMessageThreadRouter {
  final Widget Function(User receiver, User me, {String chatId})
  TicTacGame;
  final Widget Function()
  showGameBoard;

  MessageThreadRouter({this.TicTacGame , this.showGameBoard});

  @override
  Future<void> onTicTacGame(BuildContext context, User receiver, User me,
      {String chatId}) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TicTacGame(receiver, me, chatId: chatId)));
  }


  @override
  Future<void> onShowGameBoard(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => showGameBoard()));
  }

}
