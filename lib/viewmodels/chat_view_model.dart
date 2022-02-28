import 'package:chatapp/chat.dart';
import 'package:chat/data/datasource/datasource_contract.dart';
import 'package:chat/models/local_message.dart';
import 'package:chat/viewmodels/base_wiew_model.dart';

class ChatViewModel extends BaseViewModel {
  IDatasource _datasource;
  String _chatId = '';
  int otherMessages = 0;
  String get chatId => _chatId;
  ChatViewModel(this._datasource) : super(_datasource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _datasource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
        message.to, message, ReceiptStatus.sent, IsLikeStatus.notLike);
    if (_chatId.isNotEmpty) return await _datasource.addMessage(localMessage);
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
        message.from, message, ReceiptStatus.deliverred, IsLikeStatus.notLike);
    if (_chatId.isEmpty) _chatId = localMessage.chatId;
    if (localMessage.chatId != _chatId) otherMessages++;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _datasource.updateMessageReceipt(receipt.messageId, receipt.status);
  }

  Future<void> updateMessageLikes(IsLike isLike) async {
    await _datasource.updateMessageLikes(isLike.messageId, isLike.status);
  }
}
