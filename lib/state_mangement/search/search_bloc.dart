// @dart=2.9
import 'dart:async';

import 'package:chatapp/chat.dart';
import 'package:chat/state_mangement/search/searchEvent.dart';
import 'package:chat/state_mangement/search/search_state.dart';
import 'package:bloc/bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  IUserService _userService;
  StreamSubscription _subscription;

  SearchBloc(this._userService) : super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchSend) {
      yield SearchLoading();
      final users = await _userService.search(event.name);

      yield SearchLoaded(users);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}
