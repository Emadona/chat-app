// @dart=2.9
import 'dart:async';

import 'package:chatapp/src/models/isLike.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'is_like_service_contract.dart';

class IsLikeFirebase implements IIsLikeService {
  final CollectionReference collectionIsLike =
      FirebaseFirestore.instance.collection('likes');
  final _controller = StreamController<IsLike>.broadcast();
  StreamSubscription _changefeed;

  @override
  dispose() {
    _changefeed?.cancel();
    _controller?.close();
  }

  @override
  Stream<IsLike> likes(User user) {
    _startReceivingLikes(user);
    print('end receiving likes');
    return _controller.stream;
  }

  @override
  Future<IsLike> send(IsLike isLike) async {
    var data = isLike.toJson();
    final record = await collectionIsLike.add(data);
    return IsLike.fromJson(data, record.id);
  }
  // _startReceivingLikes(User user) {
  //   print('start received');
  //   _changefeed =
  //       collectionIsLike.where('to', isEqualTo: user.id).snapshots().listen((event) {
  //     event.docs.forEach((feedData) {
  //       // if (feedData['new_val'] == null) return;
  //         print('controller');
  //       final isLike = IsLike.fromJson(feedData.data(), feedData.id);
  //       _removeDeliverredLikes(isLike);
  //       _controller.sink.add(isLike);
  //     });
  //         // .catchError((err) => print(err))
  //         // .onError((error, stackTrace) => print(error));
  //   });
  // }

  _startReceivingLikes(User user) {
    _changefeed = collectionIsLike
        .where('recipient', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        final isLike = IsLike.fromJson(element.data(), element.id);
        print('firebase receipt = ' + isLike.status.toString());
        _controller.sink.add(isLike);
        _removeDeliverredLikes(isLike);
      });
    });
  }

  IsLike _likesFromFeed(QueryDocumentSnapshot feedData) {
    print('like 3 from feed');
    return IsLike.fromJson(feedData.data(), feedData.id);
  }

  _removeDeliverredLikes(IsLike isLike) {
    collectionIsLike.doc(isLike.id).delete();
  }

  @override
  Future<IsLike> update(IsLike isLike) async {
    final record =
        await collectionIsLike.doc(isLike.id).update(isLike.toJson());
    return isLike;
  }
}
