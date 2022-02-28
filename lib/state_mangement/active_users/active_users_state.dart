// @dart=2.9
part of 'active_users_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  factory UserState.initial() => UserInitial();
  factory UserState.sent(User users) => UserSentSuccess(users);
  factory UserState.received(User users) => UserReceivedSuccess(users);
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserSentSuccess extends UserState {
  final User users;
  const UserSentSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class UserReceivedSuccess extends UserState {
  final User users;
  const UserReceivedSuccess(this.users);

  @override
  List<Object> get props => [users];
}
