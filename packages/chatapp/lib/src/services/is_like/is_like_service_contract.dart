import 'package:chatapp/src/models/isLike.dart';
import 'package:chatapp/src/models/user.dart';

abstract class IIsLikeService {
  Future<IsLike> send(IsLike isLike);
  Future<IsLike> update(IsLike isLike);
  Stream<IsLike> likes(User user);
  void dispose();
}
