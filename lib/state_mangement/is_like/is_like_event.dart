// @dart=2.9
part of'is_like_bloc.dart';
abstract class IsLikeEvent extends Equatable {
  const IsLikeEvent();
  factory IsLikeEvent.onSubscribed(User user) => Subscribed(user);
  factory IsLikeEvent.onMessageSent(IsLike isLike) => IsLikeSent(isLike);

  @override
  List<Object> get props => [];
}

class Subscribed extends IsLikeEvent {
  final User user;
  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class IsLikeSent extends IsLikeEvent {
  final IsLike isLike;
  const IsLikeSent(this.isLike);

  @override
  List<Object> get props => [isLike];
}

class _LikesReceived extends IsLikeEvent {
  const _LikesReceived(this.isLike);
  final IsLike isLike;

  @override
  List<Object> get props => [isLike];
}
