import 'package:chat/models/chat.dart';
import 'package:chat/models/local_message.dart';
import 'package:chatapp/chat.dart';

abstract class IDatasource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage(LocalMessage message);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status);
  Future<void> updateMessageLikes(String messageId, IsLikeStatus status);
}
