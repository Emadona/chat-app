import 'package:chatapp/src/models/user.dart';

abstract class IUserService {
  Future<User> connect(User user);
  // Future<UserPlayer> getCurrentUser();
  Future<User> create(User user);
  Future<User> isOnline(User user);
  Stream<User> online();
  Future<void> disconnect(User user);
  Future<User> search(String name);
  Future<User> fetch(String id);
  dispose();
}
