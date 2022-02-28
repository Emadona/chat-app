// // @dart=2.9
// import 'package:chat/src/models/user.dart';
// import 'package:chat/src/services/user/user_service_contract.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:rethinkdb_dart/rethinkdb_dart.dart';
//
// class UserService implements IUserService {
//   Connection _connection;
//   final Rethinkdb r;
//   UserService(this.r, this._connection);
//
//   @override
//   Future<User> connect(User user) async {
//     if(_connection.isClosed)try{_connection = await r.connect(user: 'ccf81670-738b-4f77-832a-d39fb29f1901',
//         password: 'a139effb3908a727c151a386f121fc163cdae7d3',
//         db: 'ccf81670-738b-4f77-832a-d39fb29f1901',
//         host: 'ccf81670-738b-4f77-832a-d39fb29f1901.rdb.rethinkdb.cloud',
//         port: 28015);}catch (e){
//       print(e);
//     }
//     var data = user.tojson();
//     if (user.id != null) data['id'] = user.id;
//
//     final result = await r.table('users').insert(
//         data, {"conflict": "update",
//       "return_changes": true
//         })
//         .run(_connection);
//
//     return User.fromJson(result['changes'].first['new_val']);
//   }
//
//   @override
//   Future<void> disconnect(User user) async{
//     await r.table('users').update({'id':user.id , "active" : false ,'photo_url' :user.photoUrl
//       , 'last_seen' : DateTime.now(),
//     'city' : 'medina'})
//         .run(_connection);
//     _connection.close();
//
//
//     print(_connection.isClosed);
//   }
//
//   @override
//   Future<User> isOnline(User user) async{
//     final _user = await r.table('users').filter({'id':user.id}).run(_connection);
//     return User.fromJson(_user);
//   }
//
//   // @override
//   // Stream<List<User>> online() async{
//   //   Cursor users = await r.table('users').filter({'active':true}).run(_connection);
//   //   final userList = await users.toList();
//   //   return userList.map((item) => User.fromJson(item)).toList();
//   // }
//
//   @override
//   Future<User> fetch(String id)async {
//     final user = await r.table('users').get(id).run(_connection);
//     return User.fromJson(user);
//   }
//
//   @override
//   Future<List<User>> search(String name) async{
//     Cursor users = await r.table('users').filter({'username':name}).run(_connection);
//     final userList = await users.toList();
//     return userList.map((item) => User.fromJson(item)).toList();
//   }
//
//   @override
//   void create(User user) {
//     // TODO: implement create
//   }
//
//   @override
//   Stream<List<User>> online() {
//     // TODO: implement online
//     throw UnimplementedError();
//   }
// }
