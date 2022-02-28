import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/cache/local_cache.dart';
import 'package:chat/data/services/image_uploader.dart';
import 'package:chat/state_mangement/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _iUserService;
  final ILocalCache _localCache;
  OnboardingCubit(this._iUserService, this._localCache)
      : super(OnboardingIninial());
  Future<void> connect(String name, String city,File profileImage) async {
    emit(Loading());
    final url = base64Encode(profileImage.readAsBytesSync());
    final user = User(
      username: name,
      photoUrl: url,
      active: false,
      lastseen: DateTime.now().toString(),
      city: city,
    );
    final createdUser = await _iUserService.create(user);

    final userJson = {
      "username": createdUser.username,
      "active": createdUser.active,
      "photo_url": createdUser.photoUrl,
      "id": createdUser.id,
      'city': createdUser.city,
      'token' : createdUser.token
    };
    await _localCache.save('USER', userJson);
    emit(OnboardingSuccess(createdUser));
  }
}
