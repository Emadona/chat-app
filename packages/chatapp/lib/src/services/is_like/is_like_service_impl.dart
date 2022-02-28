// // @dart=2.9
// import 'dart:async';
//
// import 'package:chat/src/models/isLike.dart';
// import 'package:chat/src/models/user.dart';
// import 'package:rethinkdb_dart/rethinkdb_dart.dart';
//
// import 'is_like_service_contract.dart';
//
// class IsLikeService implements IIsLikeService{
//   final Connection _connection;
//   final Rethinkdb r;
//
//   final _controller = StreamController<IsLike>.broadcast();
//   StreamSubscription _changefeed;
//   IsLikeService(this.r,this._connection);
//
//   @override
//   dispose() {
//     _changefeed?.cancel();
//     _controller?.close();
//   }
//
//   @override
//   Stream<IsLike> likes(User user) {
//     _startReceivingLikes(user);
//     return _controller.stream;
//   }
//
//   @override
//   Future<IsLike> send(IsLike isLike) async{
//     var data = isLike.toJson();
//     Map record = await r.table('likes').insert(data,{'return_changes' : true}).run(_connection);
//     return IsLike.fromJson(record['changes'].first['new_val']);
//   }
//   _startReceivingLikes(User user) {
//     _changefeed = r.table('likes').filter({'recipient': user.id}).changes(
//         {'include_initial': true})
//         .run(_connection).asStream().cast<Feed>().listen((event) {
//       event.forEach((feedData) {
//         if (feedData['new_val'] == null) return;
//
//         final isLike = _likesFromFeed(feedData);
//         _removeDeliverredLikes(isLike);
//         _controller.sink.add(isLike);
//       }).catchError((err) => print(err))
//           .onError((error, stackTrace) => print(error));
//     });
//   }
//   IsLike _likesFromFeed(feedData) {
//     var data = feedData['new_val'];
//
//     return IsLike.fromJson(data);
//   }
//
//   _removeDeliverredLikes(IsLike isLike) {
//     r.table('likes').get(isLike.id)
//         .delete({'return_changes' : false})
//         .run(_connection);
//   }
//
//   @override
//   Future<IsLike> update(IsLike isLike) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }
// }