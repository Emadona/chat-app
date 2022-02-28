// @dart=2.9
import 'package:chatapp/chat.dart';
import 'package:chat/data/datasource/datasource_contract.dart';
import 'package:chat/models/chat.dart';
import 'package:chat/models/local_message.dart';
import 'package:chat/viewmodels/base_wiew_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;
  IUserService _userService;
  ChatsViewModel(this._datasource, this._userService) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();
    await Future.forEach(chats, (chat) async {
      final user = await _userService.fetch(chat.id);
      chat.from = user;
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
        message.from, message, ReceiptStatus.deliverred, IsLikeStatus.notLike);
    await addMessage(localMessage);
  }
}
