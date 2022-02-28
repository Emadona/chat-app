// @dart=2.9
import 'dart:async';

import 'package:chatapp/src/models/message.dart';

import 'package:chatapp/src/models/user.dart';
import 'package:chatapp/src/services/encryption/encryption_contract.dart';
import 'package:chatapp/src/services/encryption/encryption_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';

import 'message_service_contract.dart';

// import 'message_service_contract.dart';

class MessageFirebase implements IMessageService {
  // IEncryption _encryption;
  StreamSubscription _changefeed;
  MessageFirebase({IEncryption encryption});
  // :_encryption = encryption;
  final _controller = StreamController<Message>.broadcast();

  final _encryption = EncryptionService(Encrypter(AES(Key.fromLength(32))));
  final CollectionReference collectionMessages =
      FirebaseFirestore.instance.collection('messages');
  // @override
  // dispose() {
  //   // TODO: implement dispose
  //   throw UnimplementedError();
  // }

  @override
  dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  @override
  Stream<Message> messages({User activeUser}) {
    _startReceivingMessages(activeUser.id);
    return _controller.stream;
    // return _controller.stream;
  }

  @override
  Future<Message> send(Message message) async {
    print('send first');
    var data = message.toJson();
    print('data = ' + data.toString());
    print(_encryption);
    if (_encryption != null)
      data['contents'] = _encryption.encrypt(message.contents);
    print('to = ' + data['to']);
    final record = await collectionMessages.add(data);
    final returnMessage = await collectionMessages.doc(record.id).get();

    print('record = ' + record.id);
    return Message.fromJson(message.toJson(), returnMessage.id);
  }

  // _startReceivingMessages(){
  //   print('user id = ');
  //   collectionMessages
  //       // .where('to',isEqualTo: user)
  //       .snapshots().listen((event) {
  //         _controller.sink.add(event);
  //   }
  //   );
  //   print('message firebase');
  // }

  _startReceivingMessages(String id) {
    print('user id = ');
    _changefeed = collectionMessages
        .where('to', isEqualTo: id)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        final message = _fromfeed(element);
        _controller.sink.add(message);
        _removeDeliverredMessage(message);
      });
    });
  }

  _fromfeed(QueryDocumentSnapshot element) {
    final data = Message.fromFirebase(element);
    if (_encryption != null)
      data.contents = _encryption.dencrypt(data.contents);
    return data;
  }

  _removeDeliverredMessage(Message message) {
    collectionMessages.doc(message.id).delete();
  }
}
