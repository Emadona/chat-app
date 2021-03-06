// @dart=2.9
import 'package:chatapp/chat.dart';
import 'package:chat/state_mangement/home/home_cubit.dart';
import 'package:chat/state_mangement/home/home_state.dart';
import 'package:chat/theme.dart';
import 'package:chat/ui/pages/home/home_router.dart';
import 'package:chat/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveUsers extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  const ActiveUsers(this.me, this.router);

  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
      if (state is HomeLoading)
        return Center(child: CircularProgressIndicator());
      if (state is HomeSuccess) return _buildList(state.onlineUsers);
      return Container();
    });
  }

  _listItem(User user) => ListTile(
        leading: ProfileImage(
          imageUrl: user.photoUrl,
          online: user.active,
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
        padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, index) => GestureDetector(
          child: _listItem(users[index]),
          onTap: () {
            this.widget.router.onShowMessageThread(
                context, users[index], widget.me,
                chatId: users[index].id);
          },
        ),
        separatorBuilder: (_, __) => Divider(),
        itemCount: users.length,
      );
}
