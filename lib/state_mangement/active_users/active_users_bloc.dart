// @dart=2.9
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/chat.dart';
import 'package:equatable/equatable.dart';

part 'active_users_event.dart';
part 'active_users_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserService _userService;
  StreamSubscription _subscription;

  UserBloc(this._userService) : super(UserState.initial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription =
          _userService.online().listen((user) => add(_UserReceived(user)));
    }

    if (event is _UserReceived) {
      print('message received feed = ' + event.user.toString());

      yield UserState.received(event.user);
    }
    if (event is UserSent) {
      print('message send feed = ' + event.user.toString());

      final user_ = await _userService.search(event.user.id);
      yield UserState.sent(user_);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _userService.dispose();
    return super.close();
  }
}
