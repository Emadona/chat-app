// @dart=2.9
import 'package:flutter/cupertino.dart';

class MessageGroup{
  String get id => _id;
  String name;
  String createdBy;
  List<String> members;
  String _id;

  MessageGroup({
   @required this.createdBy,
   @required this.name,
   @required this.members
});

  toJson() => {
    'created_by' : this.createdBy,
    "name" : this.name,
    "members" : this.members
  };

  factory MessageGroup.fromJson(Map<String,dynamic> json, String id){
    MessageGroup messageGroup = MessageGroup(createdBy: json['created_by'],
        name: json['name'],
        members: List<String>.from(json['members']));
    messageGroup._id = id;
    return messageGroup;
  }
}