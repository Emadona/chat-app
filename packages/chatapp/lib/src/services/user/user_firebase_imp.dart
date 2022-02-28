// @dart=2.9
import 'dart:async';
import 'package:chatapp/src/models/user.dart';
import 'package:chatapp/src/services/user/firebase_auth.dart';
import 'package:chatapp/src/services/user/user_service_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserFirebase implements IUserService {
  final _controller = StreamController<User>.broadcast();
  StreamSubscription _changefeed;
  FirebaseMessaging _firebaseMessages;

  final CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection('users');
  @override
  Future<User> connect(User user) async {
    _firebaseMessages = FirebaseMessaging.instance;

    user.token = await _firebaseMessages.getToken();
    print('token = ' + user.token);
    await collectionUsers.doc(user.id).set(user.tojson());
    var user1 = await collectionUsers.doc(user.id).get();
    print('create firebase = ' + user1.data().toString());
    final users = User.fromJson(user1.data(), user1.id);
    print('connect firebase = ' + user1.id.toString());
    return users;
  }

  @override
  Future<void> disconnect(User user) async {
    collectionUsers.doc(user.id).set({
      'username': user.username,
      'photo_url': user.photoUrl,
      "active": false,
      "last_seen": user.lastseen,
      'token' : user.token,
      'city': user.city
    });
  }

  @override
  Future<User> fetch(String id) async {
    final user = await collectionUsers.doc(id).get();
    return User.fromJson(user.data(), user.id);
  }

  @override
  Future<User> isOnline(User user) {
    // TODO: implement isOnline
    throw UnimplementedError();
  }

  @override
  Stream<QuerySnapshot> users() {
    return collectionUsers.snapshots();
  }

  @override
  Future<User> search(String name) async {
    final user = await collectionUsers.where('username', isEqualTo: name).get();
    print(user);
    return User.fromJson(user.docs.first.data(), user.docs.first.id);
  }

  @override
  Future<User> create(User user) async {
    _firebaseMessages = FirebaseMessaging.instance;

    try {
      user.token = await _firebaseMessages.getToken();
      print('token = ' + user.token);
      final _user = await collectionUsers.add(user.tojson());
      print(_user.id);
      final users = await collectionUsers.doc(_user.id).get();
      print('user_');
      print(_user.id);
      print(users['username']);
      print('create data = ' + users.data().toString());
      var use = User.fromJson(users.data(), users.id);
      // print('use');
      print('use id' + use.id.toString());
      return use;
    } catch (e) {
      return e;
    }
  }

  @override
  Stream<User> online() {
    _startReceivingActiveUsers();
    return _controller.stream;
  }

  _startReceivingActiveUsers() {
    _changefeed = collectionUsers.snapshots().listen((event) {
      event.docs.forEach((element) {
        final user = _fromfeed(element);
        _controller.sink.add(user);
      });
    });
  }

  _fromfeed(QueryDocumentSnapshot element) {
    return User.fromJson(element.data(), element.id);
  }

  @override
  dispose() {
    _controller?.close();
    _changefeed?.cancel();
  }

}
