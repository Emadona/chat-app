// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
enum ActiveStatus {
  online , playing , offline
}

extension ActiveParsing on  ActiveStatus {
  String value() {
    return this.toString().split('.').last;
    

  }

  static ActiveStatus fromString(String status) {
    return ActiveStatus.values.firstWhere((element) => element.value() == status);
}}

class User {
  String get id => _id;
  String username;
  String photoUrl;
  String _id;
  bool active;
  String lastseen;
  String city;
  String token;
  User(
      {@required this.username,
      @required this.photoUrl,
      @required this.active,
      @required this.lastseen,
      @required this.city,
      this.token});

  tojson() => {
        'username': this.username,
        'photo_url': this.photoUrl,
        "active": this.active,
        "last_seen": this.lastseen,
        'city': this.city,
        'token' : this.token
      };
  // ignore: unnecessary_statements
  factory User.fromJson(Map<String, dynamic> json,String id) {
    final user = User(
        username: json['username'] ?? '',
        photoUrl: json['photo_url']??'',
        active: json['active'],
        lastseen: json['last_seen'].toString(),
        city: json['city'],
        token: json['token']);
    user._id = id;
    return user;
  }
  // factory User.fromFirebase(QueryDocumentSnapshot doc) {
  //   // Timestamp timestamp = doc['timestamp'];
  //
  //   final user = User(
  //       username: doc['username'],
  //       photoUrl: doc['photo_url']??'',
  //       active: doc['active'],
  //       lastseen:  doc['timestamp'],
  //       city: doc['city']);
  //   user._id = doc.id;
  //   return user;
  // }


  // factory User.fromFireStore(DocumentSnapshot doc) {
  //
  //   User user = User(
  //       username: doc['username'],
  //       photoUrl: doc['photo_url']??'',
  //       active: doc['active'],
  //       lastseen: doc['last_seen'],
  //       city: doc['city']);
  //   user._id = doc.id;
  //   return user;
  //
  // }


}
