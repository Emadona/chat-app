import 'package:chatapp/src/models/message.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:flutter/cupertino.dart';

abstract class IMessageService {
  Future<Message> send(Message message);
  Stream<Message> messages({@required User activeUser});
  dispose();
}
