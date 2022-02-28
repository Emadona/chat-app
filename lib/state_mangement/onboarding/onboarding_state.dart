import 'package:chatapp/chat.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {}

class OnboardingIninial extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class Loading extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingSuccess extends OnboardingState {
  final User user;
  OnboardingSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
