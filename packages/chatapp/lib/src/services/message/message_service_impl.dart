// // @dart=2.9
// import 'dart:async';
//
// import 'package:chat/chat.dart';
// import 'package:chat/src/models/message.dart';
// import 'package:chat/src/models/user.dart';
// import 'package:chat/src/services/encryption/encryption_contract.dart';
// import 'package:chat/src/services/message/message_service_contract.dart';
// import 'package:rethinkdb_dart/rethinkdb_dart.dart';
//
// class MessageService implements IMessageService {
//   final Connection _connection;
//   final Rethinkdb r;
//   final IEncryption _encryption;
//   final IUserService _userService;
//   final _controller = StreamController<Message>.broadcast();
//   StreamSubscription _changefeed;
//   MessageService(this.r,this._connection,this._userService ,{IEncryption encryption }) :_encryption = encryption;
//
//   @override
//   dispose() {
//     _changefeed?.cancel();
//   _controller?.close();
//   }
//
//   @override
//   Stream<Message> messages({User activeUser}) {
//     _startReceivingMessages(activeUser);
//     return _controller.stream;
//
//   }
//
//   @override
//   Future<Message> send(Message message) async{
//     var data = message.toJson();
//     if(_encryption != null)
//     data['contents'] = _encryption.encrypt(message.contents);
//     Map record = await r.table('messages').insert(data , {'return_changes' : true}).run(_connection);
//     return Message.fromJson(record['changes'].first['new_val']);
//   }
//   _startReceivingMessages(User user)async {
//
//     _changefeed = r.table('messages').filter({'to': user.id}).changes(
//         {'include_initial': true})
//         .run(_connection).asStream().cast<Feed>().listen((event) {
//       event.forEach((feedData) {
//         if (feedData['new_val'] == null) return;
//
//         final message = _messageFromFeed(feedData);
//         _controller.sink.add(message);
//         _removeDeliverredMessage(message);
//         print('message = '+user.active.toString());
//         if(!user.active) print(message.contents);
//       }).catchError((err) => print(err))
//           .onError((error, stackTrace) => print(error));
//     });
//   }
//     Message _messageFromFeed(feedData) {
//     var data = feedData['new_val'];
//     print('message from feed = '+ data.contents);
//
//     if(_encryption != null)
//     data['contents'] = _encryption.dencrypt(data['contents']);
//     print('message from feed = '+ data.contents);
//
//     return Message.fromJson(data);
//   }
//
//   _removeDeliverredMessage(Message message) {
//     r.table('messages').get(message.id).delete({'return_changes' : false})
//         .run(_connection);
//   }
//
// }