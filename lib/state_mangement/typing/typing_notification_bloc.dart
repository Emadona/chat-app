// @dart=2.9
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/chat.dart';
import 'package:equatable/equatable.dart';
part 'typing_notification_event.dart';
part 'typing_notification_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotification _iTypingNotification;
  StreamSubscription _subscription;

  TypingNotificationBloc(this._iTypingNotification)
      : super(TypingNotificationState.initial());

  @override
  Stream<TypingNotificationState> mapEventToState(
      TypingNotificationEvent typingEvent) async* {
    if (typingEvent is Subscribed) {
      if (typingEvent.usersWithChat == null) {
        add(NotSubscribed());
        return;
      }
      await _subscription?.cancel();
      _subscription = _iTypingNotification
          .subscribe(typingEvent.user, typingEvent.usersWithChat)
          .listen(
              (typingEvent) => add(_TypingNotificationReceived(typingEvent)));
    }

    if (typingEvent is _TypingNotificationReceived) {
      yield TypingNotificationState.received(typingEvent.event);
    }
    if (typingEvent is TypingNotificationSent) {
      await _iTypingNotification.send(event: typingEvent.event);
      yield TypingNotificationState.sent();
    }

    if (typingEvent is NotSubscribed) {
      yield TypingNotificationState.initial();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _iTypingNotification.dispose();
    return super.close();
  }
}
