import 'package:bloc/bloc.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/cache/local_cache.dart';
import 'package:chat/state_mangement/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;
  ILocalCache _localCache;
  HomeCubit(this._userService, this._localCache) : super(HomeInitial());

  // Future<User> connect() async {
  //   final userJson = _localCache.fetch("USER");
  //   userJson['last_seen'] = DateTime.now();
  //   userJson['active'] = true;
  //
  //   final user = User.fromJson(userJson, userJson['id']);
  //   await _userService.connect(user);
  //   return user;
  // }

  Future<User> fetch(String id) async{
    User user = await _userService.fetch(id);
    print('challenger');
    print(user.username);
    return user;
  }
  // Future<void> activeUsers(User user) async{
  //   emit(HomeLoading());
  //   final users = await _userService.online();
  //   users.removeWhere((element) => element.id == user.id);
  //   emit(HomeSuccess(users));
  // }

}
