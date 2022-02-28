import 'package:chatapp/chat.dart';
import 'package:equatable/equatable.dart';

abstract class LifeCycleState extends Equatable {}

class LifeCycleInitial extends LifeCycleState {
  @override
  List<Object> get props => [];
}

class LifeCycleLoading extends LifeCycleState {
  @override
  List<Object> get props => [];
}

class LifeCycleSuccess extends LifeCycleState {
  final List<User> onlineUsers;
  LifeCycleSuccess(this.onlineUsers);

  @override
  List<Object> get props => [onlineUsers];
}
