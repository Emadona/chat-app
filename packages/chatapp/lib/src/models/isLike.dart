// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum IsLikeStatus {
  notLike,
  like
}

extension IsLikeParsing on  IsLikeStatus {
  String value() {
    return this.toString().split('.').last;

  }

  static IsLikeStatus fromString(String status) {
    return IsLikeStatus.values.firstWhere((element) => element.value() == status);
  }
}
class IsLike {
  final String recipient;
  final String messageId;
  final IsLikeStatus status;
  final String timestamp;
  String _id;
  String get id => _id;

  IsLike({
    @required this.recipient,
    @required this.messageId,
    @required this.status,
    @required this.timestamp
  });

  Map<String , dynamic>toJson() => {
    'recipient' : this.recipient,
    'message_id' : this.messageId,
    'status' : this.status.value(),
    'timestamp' : this.timestamp
  };

  factory IsLike.fromJson(Map<String , dynamic> json,String id) {
    var isLike = IsLike(
        recipient : json['recipient'],
        messageId : json['message_id'],
        status : IsLikeParsing.fromString(json['status']),
        timestamp : json['timestamp'].toString());
    isLike._id = id;
    return isLike;
  }

  factory IsLike.fromFirebase(QueryDocumentSnapshot doc) {
    var isLike = IsLike(
        recipient : doc['recipient'],
        messageId : doc['message_id'],
        status : IsLikeParsing.fromString(doc['status']),
        timestamp : doc['timestamp'].toString());
    isLike._id = doc.id;
    return isLike;
  }
}