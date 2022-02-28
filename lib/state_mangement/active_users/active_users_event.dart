// @dart=2.9
part of 'active_users_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  factory UserEvent.onSubscribed(User user) => Subscribed(user);
  factory UserEvent.onUserSent(User user) => UserSent(user);

  @override
  List<Object> get props => [];
}

class Subscribed extends UserEvent {
  final User user;
  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class UserSent extends UserEvent {
  final User user;
  const UserSent(this.user);

  @override
  List<Object> get props => [user];
}

class _UserReceived extends UserEvent {
  const _UserReceived(this.user);
  final User user;

  @override
  List<Object> get props => [user];
}
