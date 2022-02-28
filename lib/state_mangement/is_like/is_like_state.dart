// @dart=2.9

part of'is_like_bloc.dart';
abstract class IsLikeState extends Equatable {
  const IsLikeState();
  factory IsLikeState.initial() => IsLikeInitial();
  factory IsLikeState.sent(IsLike isLike) => IsLikeSentSuccess(isLike);
  factory IsLikeState.received(IsLike isLike) =>
      IsLikeReceivedSuccess(isLike);
  @override
  List<Object> get props => [];
}

class IsLikeInitial extends IsLikeState {}

class IsLikeSentSuccess extends IsLikeState {
  final IsLike isLike;
  const IsLikeSentSuccess(this.isLike);

  @override
  List<Object> get props => [isLike];
}

class IsLikeReceivedSuccess extends IsLikeState {
  final IsLike isLike;
  const IsLikeReceivedSuccess(this.isLike);

  @override
  List<Object> get props => [isLike];
}
