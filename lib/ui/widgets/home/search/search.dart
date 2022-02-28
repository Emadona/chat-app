// @dart=2.9
import 'package:chat/colors.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/state_mangement/search/searchEvent.dart';
import 'package:chat/state_mangement/search/search_bloc.dart';
import 'package:chat/state_mangement/search/search_state.dart';
import 'package:chat/theme.dart';
import 'package:chat/ui/pages/home/home_router.dart';
import 'package:chat/ui/widgets/home/profile_image.dart';
import 'package:chat/ui/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  const SearchBar(this.me, this.router);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (_, state) {
          if (state is SearchInitial) {
            return buildInitialInput();
          } else if (state is SearchLoading) {
            return buildLoading();
          } else if (state is SearchLoaded) {
            if (state.users == null) {
              return Column(
                children: [
                  Center(
                    child: Text('try another name!'),
                  ),
                  buildInitialInput()
                ],
              );
            } else {
              return columnWithData(context, state.users);
            }
          }
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column columnWithData(BuildContext context, User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: buildContainer(user),
        ),
        CityInputField(),
      ],
    );
  }

  buildContainer(User user) {
    return GestureDetector(
      // child: Container(
      // child: Row(
      //   children: [
      //     ProfileImage(
      //       imageUrl: user.photoUrl.toString(),
      //       online: false,),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Center(
      //         child: Text(
      //           user.username.toString(),
      //           style: Theme.of(context).textTheme.subtitle2!.copyWith(
      //               fontSize: 14.0,
      //               fontWeight: FontWeight.bold,
      //               color:isLightTheme(context) ? Colors.black : Colors.white
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // ),
      child: ListTile(
        leading: ProfileImage(
          imageUrl: user.photoUrl.toString(),
          online: user.active,
        ),
        title: Text(
          user.username.toString(),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white),
        ),
      ),
      onTap: () {
        this
            .widget
            .router
            .onShowMessageThread(context, user, widget.me, chatId: user.id);
      },
    );
  }

  buildList(List<User> users) => ListView.separated(
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

  _listItem(User user) => ListTile(
        leading: ProfileImage(
          imageUrl: user.photoUrl.toString(),
          online: false,
        ),
        title: Text(
          user.username.toString(),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white),
        ),
      );
}

class CityInputField extends StatelessWidget {
  CityInputField();
  String _searchname = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child:Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child:
        Container(
          decoration: BoxDecoration(
              color: isLightTheme(context) ? Colors.white : kBubbleDark,
              borderRadius: BorderRadius.circular(45.0),
              border: Border.all(
                color:
                isLightTheme(context) ? Color(0xFFC4C4C4) : Color(0xFF393737),
                width: 1.5,
              )),
          child: TextField(
            keyboardType: TextInputType.text,
            cursorColor: kPrimary,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              hintText: 'Search by name',
              border: InputBorder.none,
            ),
            style: TextStyle(color: isLightTheme(context)? Colors.black87:Colors.white),
            onSubmitted: (value) => submitCityName(context, value),
                  textInputAction: TextInputAction.search,
                ),
        )
      )

      ,
    );
  }

  void submitCityName(BuildContext context, String name) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.add(SearchSend(name.trim()));
  }
}
