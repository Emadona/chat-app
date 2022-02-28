// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum ReceiptStatus {
  sent , deliverred , read
}

extension EnumParsing on  ReceiptStatus {
  String value() {
    return this.toString().split('.').last;

  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values.firstWhere((element) => element.value() == status);
  }
}
class Receipt {
  final String recipient;
  final String messageId;
  final ReceiptStatus status;
  final String timestamp;
  String _id;
  String get id => _id;

  Receipt({
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

  factory Receipt.fromJson(Map<String , dynamic> json,String id) {
    var receipt = Receipt(
        recipient : json['recipient'],
        messageId : json['message_id'],
        status : EnumParsing.fromString(json['status']),
        timestamp : json['timestamp'].toString());
    receipt._id = id;
    return receipt;
  }

  factory Receipt.fromFirebase(QueryDocumentSnapshot doc) {
    var receipt = Receipt(
        recipient : doc['recipient'],
        messageId : doc['message_id'],
        status : EnumParsing.fromString(doc['status']),
        timestamp : doc['timestamp'].toString());
    receipt._id = doc.id;
    return receipt;
  }
}