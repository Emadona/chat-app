import 'package:chatapp/chat.dart';
import 'package:chat/cache/local_cache.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'life_cycle_state.dart';

class LifeCycleCubit extends Cubit<LifeCycleState> {
  IUserService _userService;
  ILocalCache _localCache;
  LifeCycleCubit(this._userService, this._localCache)
      : super(LifeCycleInitial());

  void connect() async {
    final userJson = _localCache.fetch("USER");
    print(userJson);
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson, userJson['id']);
    await _userService.connect(user);
  }

  void disconnect() async {
    final userJson = _localCache.fetch("USER");
    print('false');
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = false;

    final user = User.fromJson(userJson, userJson['id']);
    await _userService.disconnect(user);
  }

  // Future<void> activeUsers(User user) async{
  //   emit(LifeCycleLoading());
  //   final users = await _userService.online();
  //   users.removeWhere((element) => element.id == user.id);
  //   emit(LifeCycleSuccess(users));
  // }

}
