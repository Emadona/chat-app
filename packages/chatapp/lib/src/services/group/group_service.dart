// @dart=2.9
import 'dart:async';

import 'package:chatapp/src/models/message_group.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class IGroupService {
  Future<MessageGroup> create(MessageGroup group);
  Stream<MessageGroup> groups({@required User me});
  dispose();
}

class MessageGroupService implements IGroupService {
  final _controller = StreamController<MessageGroup>.broadcast();
  StreamSubscription _changefeed;
  CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('message_groups');

  @override
  Future<MessageGroup> create(MessageGroup group) async {
    final record = await groupCollection.add(group.toJson());
    return MessageGroup.fromJson(group.toJson(), record.id);
  }

  @override
  dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  @override
  Stream<MessageGroup> groups({User me}) {
    startReceivingGroups(me);
    return _controller.stream;
  }

  startReceivingGroups(User me) {
    _changefeed = groupCollection
        .where('members', arrayContains: me.id)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        final group = MessageGroup.fromJson(element.data(), element.id);
        _controller.sink.add(group);
        _updateReceivedGroupCreated(group, me);
      });
    });
  }

  _updateReceivedGroupCreated(MessageGroup group, User me) {}
}
