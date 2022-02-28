// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Message {
  String get id => _id;
  final String from;
  final String to;
  String timestamp;
  String contents;
  String _id;

  Message({
  @required this.from,
  @required this.to,
  @required this.timestamp,
  @required this.contents
});
  toJson() => {
    "from" : this.from,
    "to" : this.to,
    "timestamp" : this.timestamp,
    "contents" : this.contents
  };
  factory Message.fromFirebase(QueryDocumentSnapshot doc){
    var message = Message(
      from: doc['from'],
      to: doc['to'],
      contents: doc['contents'],
      timestamp: doc['timestamp'].toString()
    );
    message._id = doc.id;
    return message;
  }


  factory Message.fromJson(Map<String, dynamic>json,String id) {
    var message = Message(
      from : json['from'],
      to: json['to'],
      timestamp: json['timestamp'],
      contents : json['contents'],
    );

    message._id = id;
    return message;
  }

}