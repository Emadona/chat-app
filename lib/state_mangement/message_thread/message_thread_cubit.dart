import 'package:bloc/bloc.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/cache/local_cache.dart';
import 'package:chat/models/local_message.dart';
import 'package:chat/viewmodels/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;
  ILocalCache _localCache;
  IUserService _userService;
  MessageThreadCubit(this.viewModel, this._localCache, this._userService)
      : super([]);

  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }

  void disconnect() async {
    final userJson = _localCache.fetch("USER");
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson, userJson['id']);
    await _userService.disconnect(user);
  }
}
