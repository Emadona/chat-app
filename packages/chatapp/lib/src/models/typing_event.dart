//  @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Typing {start , stop}
extension TypingParser on  Typing {
  String value() {
    return this.toString().split('.').last;

  }

  static Typing fromString(String event) {
    return Typing.values.firstWhere((element) => element.value() == event);
  }
}

class TypingEvent {
  String get id => _id;
  final String from;
  final String to;
  final Typing event;
  String _id;

  TypingEvent({
    @required this.from,
    @required this.to,
    @required this.event
});

  Map<String , dynamic>toJson() => {
    'from' : this.from,
    'to' : this.to,
    'event' : this.event.value()
  };

  factory TypingEvent.fromJson(Map<String , dynamic> json,String id) {
    var receipt = TypingEvent(
        from : json['from'],
        to : json['to'],
        event : TypingParser.fromString(json['event']),
    );
    receipt._id = id;
    return receipt;
  }
  factory TypingEvent.fromFirebase(QueryDocumentSnapshot doc) {
    var typing = TypingEvent(
      from : doc['from'],
      to : doc['to'],
      event : TypingParser.fromString(doc['event']),
    );
    typing._id = doc.id;
    return typing;
  }

}