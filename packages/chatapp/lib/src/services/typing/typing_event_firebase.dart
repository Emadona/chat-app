// @dart=2.9
import 'dart:async';

import 'package:chatapp/chat.dart';
import 'package:chatapp/src/models/typing_event.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:chatapp/src/services/typing/typing_notification_service_contract.dart';
import 'package:chatapp/src/services/user/user_service_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TypingNotificationFirebase implements ITypingNotification {
  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription _changefeed;
  IUserService _userService;
  final CollectionReference collectionTyping =
      FirebaseFirestore.instance.collection('typing_events');

  TypingNotificationFirebase(this._userService);

  @override
  Future<bool> send({@required TypingEvent event}) async {
    final receiver = await _userService.fetch(event.to);
    if (receiver.active == ActiveStatus.offline) return false;
    final record = await collectionTyping.add(event.toJson());
    // final records = await record.firestore.doc(record.id);
    return true;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingTypingEvents(user, userIds);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  TypingEvent _eventFromFeed(QueryDocumentSnapshot feedData) {
    return TypingEvent.fromJson(feedData.data(), feedData.id);
  }

  _removeEvent(TypingEvent event) {
    collectionTyping.doc(event.id).delete();
  }

  _startReceivingTypingEvents(User user, List<String> userIds) {
    _changefeed = collectionTyping
        .where('to', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      event.docs.forEach((feedData) {
        final typing = _eventFromFeed(feedData);
        _controller.sink.add(typing);
        _removeEvent(typing);
      });
    });
  }

  @override
  Future<bool> update({TypingEvent event}) async {
    final record = await collectionTyping.doc(event.id).update(event.toJson());
    return true;
  }
}
