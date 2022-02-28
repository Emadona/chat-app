// @dart=2.9
import 'dart:ui';
import 'package:chat/state_mangement/receipt/receipt_bloc.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/state_mangement/typing/typing_notification_bloc.dart';
import 'package:chat/ui/pages/home/home_router.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:chat/colors.dart';
import 'package:chat/models/chat.dart';
import 'package:chat/state_mangement/home/chats_cubit.dart';
import 'package:chat/state_mangement/message/message_bloc.dart';
import 'package:chat/theme.dart';
import 'package:chat/ui/widgets/home/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app_theme.dart';

// class Chats extends StatefulWidget {
//   final User user;
//   final IHomeRouter router;
//   const Chats(this.user , this.router);
//
//   @override
//   _ChatsState createState() => _ChatsState();
// }
//
// class _ChatsState extends State<Chats> {
//   final typingEvent = [];
//   var chats = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _updateChatsOnMessageReceived();
//     context.read<ChatsCubit>().chats();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatsCubit, List<Chat>>(
//       builder: (__, chats) {
//         this.chats = chats;
//         if(this.chats.isEmpty) return Container();
//         context.read<TypingNotificationBloc>().add(
//           TypingNotificationEvent.onSubscribed(widget.user ,
//               usersWhitChat: chats.map((e) => e.from.id).toList())
//         );
//         return _buildListView(context);
//       },
//     );
//   }
//
//
//   _buildListView(BuildContext context) => ListView.separated(
//     // padding: EdgeInsets.only(top: 30.0,right: 12.0),
//     itemBuilder: (_, index) => GestureDetector(
//
//       child:_chatItem(chats[index]) ,
//       onTap: () async {
//         await this.widget.router.onShowMessageThread(context, chats[index].from
//           ,widget.user,chatId: chats[index].id );
//
//         await context.read<ChatsCubit>().chats();
//       },
//     )
//       ,
//     separatorBuilder: (_,__) => Divider(),
//     itemCount: chats.length,
//   );
//
//
//   _chatItem(Chat chat) =>ListTile(
//     // contentPadding: EdgeInsets.only(left: 20.0),
//     leading: ProfileImage(
//       imageUrl: chat.from.photoUrl,
//       online: chat.from.active,),
//     title: Text(
//       chat.from.username,
//       style: Theme.of(context).textTheme.subtitle2.copyWith(
//         fontWeight: FontWeight.bold,
//         color: isLightTheme(context) ? Colors.black : Colors.white
//       ),
//     ),
//     subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
//       builder: (__ , state) {
//         if (state is TypingNotificationReceivedSuccess &&
//         state.event.event == Typing.start &&
//         state.event.from == chat.from.id)
//         this.typingEvent.add(state.event.from);
//
//         if (state is TypingNotificationReceivedSuccess &&
//             state.event.event == Typing.stop &&
//             state.event.from == chat.from.id)
//           this.typingEvent.remove(state.event.from);
// // C:\src\flutter
//         if (this.typingEvent.contains(chat.from.id))
//           return Text('typing...',
//           style: Theme.of(context)
//             .textTheme.caption
//             .copyWith(fontStyle: FontStyle.italic),);
//         return Text(
//           chat.mostRecent.message.contents,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           softWrap: true,
//           style: Theme.of(context).textTheme.overline.copyWith(
//             color: isLightTheme(context) ? Colors.black54 : Colors.white70,
//             fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal
//           ),
//         );
//       },
//     ),
//     trailing: Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           DateFormat('h:mm a').format(chat.mostRecent.message.timestamp),
//           style: Theme.of(context).textTheme.overline.copyWith(
//             color: isLightTheme(context) ? Colors.black54 : Colors.white70,
//         )),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0,),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(50.0),
//             child: chat.unread > 0 ?Container(
//               height: 15.0,
//               width: 15.0,
//               color: kPrimary,
//               alignment: Alignment.center,
//               child: Text(
//                   chat.unread.toString(),
//                   style: Theme.of(context).textTheme.overline.copyWith(
//                     color: Colors.white,
//                   )),
//             ) :
//             SizedBox.shrink(),
//           ),
//         )
//
//       ],
//     ),
//   );
//
//   _updateChatsOnMessageReceived() {
//     final chatsCubit = context.read<ChatsCubit>();
//     context.read<MessageBloc>().stream.listen((state) async{
//       if(state is MessageReceivedSuccess) {
//         await chatsCubit.viewModel.receivedMessage(state.message);
//         chatsCubit.chats();
//       }
//     });
//   }
//
//   Widget columnMostRecent()=>Column(
//     children: [
//       Container(
//         padding: EdgeInsets.symmetric(
//             vertical: 20),
//
//         child: Row(
//           children: [
//             Text('Recent Chats',
//               style: MyTheme.heading2,),
//             Spacer(),
//             Icon(Icons.search,
//               color: MyTheme.kPrimaryColor,)
//           ],
//         ),
//       ),
//       _buildListView(context)
//     ],
//   );
// }

class Chats extends StatefulWidget {
  final User user;
  final IHomeRouter router;
  var chats;
  Chats(this.user, this.router,chats);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final typingEvent = [];


  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().chats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(
      builder: (__, chats) {
        this.widget.chats = chats;
        if (this.widget.chats.isEmpty) return Container();
        context.read<TypingNotificationBloc>().add(
            TypingNotificationEvent.onSubscribed(widget.user,
                usersWhitChat: chats.map((e) => e.from.id).toList()));
        return _buildListView();
      },
    );
  }

  _buildListView() => ListView.separated(
        // padding: EdgeInsets.only(top: 30.0,right: 16.0),
        itemBuilder: (_, index) => GestureDetector(
          child: _chatItem(widget.chats[index]),
          onTap: () async {
            await this.widget.router.onShowMessageThread(
                context, widget.chats[index].from, widget.user,
                chatId: widget.chats[index].id);

            await context.read<ChatsCubit>().chats();
          },
        ),
        separatorBuilder: (_, __) => Divider(),
        itemCount: widget.chats.length,
      );

  _chatItem(Chat chat) => ListTile(
        contentPadding: EdgeInsets.only(left: 16.0),
        leading: ProfileImage(
          imageUrl: chat.from.photoUrl,
          online: chat.from.active,
        ),
        title: Text(
          chat.from.username,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
          builder: (__, state) {
            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.start &&
                state.event.from == chat.from.id)
              this.typingEvent.add(state.event.from);

            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.stop &&
                state.event.from == chat.from.id)
              this.typingEvent.remove(state.event.from);

            if (this.typingEvent.contains(chat.from.id))
              return Text(
                'typing...',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontStyle: FontStyle.italic),
              );
            return Text(
              chat.mostRecent.message.contents,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context).textTheme.overline.copyWith(
                  color:
                      isLightTheme(context) ? Colors.black54 : Colors.white70,
                  fontWeight:
                      chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
            );
          },
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                DateFormat('h:mm a')
                    .format(DateTime.parse(chat.mostRecent.message.timestamp).toLocal()),
                style: Theme.of(context).textTheme.overline.copyWith(
                      color: isLightTheme(context)
                          ? Colors.black54
                          : Colors.white70,
                    )),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: chat.unread > 0
                    ? Container(
                        height: 15.0,
                        width: 15.0,
                        color: kPrimary,
                        alignment: Alignment.center,
                        child: Text(chat.unread.toString(),
                            style:
                                Theme.of(context).textTheme.overline.copyWith(
                                      color: Colors.white,
                                    )),
                      )
                    : SizedBox.shrink(),
              ),
            )
          ],
        ),
      );

  _updateChatsOnMessageReceived() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        final receipt = Receipt(
          recipient: state.message.from,
          messageId: state.message.id,
          status: ReceiptStatus.deliverred,
          timestamp: DateTime.now().toString(),
        );
        context.read<ReceiptBloc>().add(ReceiptEvent.onMessageSent(receipt));

        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });
  }
}
