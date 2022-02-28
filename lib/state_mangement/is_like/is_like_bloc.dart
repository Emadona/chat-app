// @dart=2.9
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:chatapp/chat.dart';

part 'is_like_event.dart';
part 'is_like_state.dart';

class IsLikeBloc extends Bloc<IsLikeEvent, IsLikeState> {
  final IIsLikeService _isLikeService;
  StreamSubscription _subscription;

  IsLikeBloc(this._isLikeService) : super(IsLikeState.initial());

  @override
  Stream<IsLikeState> mapEventToState(IsLikeEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _isLikeService
          .likes(event.user)
          .listen((isLike) => add(_LikesReceived(isLike)));
    }

    if (event is _LikesReceived) {
      yield IsLikeState.received(event.isLike);
    }
    if (event is IsLikeSent) {
      IsLike isLike = await _isLikeService.send(event.isLike);
      yield IsLikeState.sent(isLike);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _isLikeService.dispose();
    return super.close();
  }
}
