// @dart=2.9
import 'package:chat/ui/widgets/home/profile_image.dart';
import 'package:chatapp/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageurl;
  final bool online;
  final String lastSeen;
  final bool typing;
  const HeaderStatus(this.username, this.imageurl, this.online,
      {this.lastSeen, this.typing});

  @override
  Widget build(Object context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(imageUrl: imageurl, online: online),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  username.trim(),
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: typing == null
                      ? Text(
                          online
                              ? 'online'
                              : 'last seen ${DateFormat.yMd().add_jm().format(DateTime.parse(lastSeen))}'
                      ,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white))
                      : Text(
                          'typing...',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontStyle: FontStyle.italic),
                        )),
            ],
          )
        ],
      ),
    );
  }
}
