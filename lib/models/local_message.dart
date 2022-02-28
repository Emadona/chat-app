// @dart=2.9
import 'package:chatapp/chat.dart';

class LocalMessage {
  String chatId;
  String get id => _id;
  String _id;
  Message message;
  ReceiptStatus receipt;
  IsLikeStatus isLike;

  LocalMessage(this.chatId, this.message, this.receipt, this.isLike);

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        "id": message.id,
        "sender": message.from,
        "receiver": message.to,
        'contents': message.contents,
        'receipt': receipt.value(),
        'isLike': isLike.value(),
        'received_at': message.timestamp.toString()
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['sender'],
        to: json['receiver'],
        contents: json['contents'],
        timestamp: json['received_at']);
    final localmessage = LocalMessage(
        json['chat_id'],
        message,
        EnumParsing.fromString(json['receipt']),
        IsLikeParsing.fromString(json['isLike']));
    localmessage._id = json['id'];

    return localmessage;
  }
}
