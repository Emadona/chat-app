// import 'package:chat/chat.dart';
// import 'package:chatpp/state_mangement/search/searchEvent.dart';
// import 'package:chatpp/state_mangement/search/search_bloc.dart';
// import 'package:chatpp/state_mangement/search/search_state.dart';
// import 'package:chatpp/ui/pages/home/home_router.dart';
// import 'package:chatpp/ui/widgets/home/profile_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../theme.dart';

// class SearchBar extends StatefulWidget {
//   final User me;
//   final IHomeRouter router;
//   const SearchBar(this.me , this.router);
//
//   @override
//   _SearchBarState createState() => _SearchBarState();
// }
//
// class _SearchBarState extends State<SearchBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 16),
//       alignment: Alignment.center,
//       child: BlocBuilder<SearchBloc, SearchState>(
//           builder: (_, state) {
//
//             if (state is SearchInitial) {
//               return buildInitialInput();
//             } else if (state is SearchLoading) {
//               return buildLoading();
//             } else if (state is SearchLoaded) {
//               return columnWithData(context, state.users.first);
//             }
//             return buildInitialInput();
//           },
//         ),
//
//     );
//   }
//
//   Widget buildInitialInput() {
//     return Center(
//       child: CityInputField(),
//     );
//   }
//
//   Widget buildLoading() {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   }
//
//   Column columnWithData(BuildContext context,User user) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//
//         Center(
//           child: buildContainer(user),
//         ),
//         CityInputField(),
//       ],
//     );
//   }
//
//   buildContainer(User user){
//     return GestureDetector(
//       // child: Container(
//         // child: Row(
//         //   children: [
//         //     ProfileImage(
//         //       imageUrl: user.photoUrl.toString(),
//         //       online: false,),
//         //     Padding(
//         //       padding: const EdgeInsets.all(8.0),
//         //       child: Center(
//         //         child: Text(
//         //           user.username.toString(),
//         //           style: Theme.of(context).textTheme.subtitle2!.copyWith(
//         //               fontSize: 14.0,
//         //               fontWeight: FontWeight.bold,
//         //               color:isLightTheme(context) ? Colors.black : Colors.white
//         //           ),
//         //         ),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//       // ),
//       child: ListTile(
//         leading: ProfileImage(
//           imageUrl: user.photoUrl.toString(),
//           online: false,),
//         title: Text(
//           user.username.toString(),
//           style: Theme.of(context).textTheme.subtitle2!.copyWith(
//               fontSize: 14.0,
//               fontWeight: FontWeight.bold,
//               color:isLightTheme(context) ? Colors.black : Colors.white
//           ),
//         ),
//       ),
//       onTap: ()  {
//         this.widget.router.onShowMessageThread(context, user, widget.me,
//             chatId: user.id);
//       },
//     );
//   }
//
//
//   buildList(List<User> users) => ListView.separated(
//
//     itemBuilder: (_, index) => GestureDetector(
//       child:_listItem(users[index]) ,
//       onTap: ()  {
//         this.widget.router.onShowMessageThread(context, users[index], widget.me,
//             chatId: users[index].id);
//       },
//     )
//     ,
//     separatorBuilder: (_,__) => Divider(),
//     itemCount: users.length,);
//
//   _listItem(User user) => ListTile(
//     leading: ProfileImage(
//       imageUrl: user.photoUrl.toString(),
//       online: false,),
//     title: Text(
//       user.username.toString(),
//       style: Theme.of(context).textTheme.subtitle2!.copyWith(
//           fontSize: 14.0,
//           fontWeight: FontWeight.bold,
//           color:isLightTheme(context) ? Colors.black : Colors.white
//       ),
//     ),
//   );
// }
//
//
// class CityInputField extends StatelessWidget {
//   const CityInputField();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 50),
//       child: TextField(
//         onSubmitted: (value) => submitCityName(context, value),
//         textInputAction: TextInputAction.search,
//         decoration: InputDecoration(
//             hintText: 'Enter a City',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             suffix: Icon(Icons.search)),
//       ),
//     );
//   }
//
//   void submitCityName(BuildContext context, String cityName) {
//     final weatherBloc = BlocProvider.of<SearchBloc>(context);
//     weatherBloc.add(SearchSend(cityName));
//   }
// }