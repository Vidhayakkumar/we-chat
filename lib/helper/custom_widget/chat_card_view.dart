import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/my_date_util.dart';
import 'package:we_chat/model/chat_model.dart';
import 'package:we_chat/model/chat_user_model.dart';

import '../../main.dart';

class ChatCardView extends StatelessWidget {
  ChatUserModel userModel;
  ChatCardView({
    super.key,
    required this.userModel
  });

  ChatModel? _messages;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: AppApis.getLastMessage(userModel),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Card(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(CupertinoIcons.person, color: Colors.white),
                radius: 20,
                backgroundColor: Colors.blue,
              ),
              title: Text(
                userModel.name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: mq.width * .04,
                ),
              ),
              subtitle: Text(
                userModel.about!,
                style: TextStyle(fontSize: mq.width * .035),
                maxLines: 1,
              ),
            ),
          );
        }

        final data = snapshot.data!.docs;
        final list = data.map((e) => ChatModel.fromJson(e.data())).toList();

        if (list.isNotEmpty) _messages = list[0];

        return Card(
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(CupertinoIcons.person, color: Colors.white),
              radius: 20,
              backgroundColor: Colors.blue,
            ),
            title: Text(
              userModel.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: mq.width * .04,
              ),
            ),
            subtitle: Text(
              _messages?.msg ?? userModel.about!,
              style: TextStyle(fontSize: mq.width * .035),
              maxLines: 1,
            ),
            trailing: _messages == null
                ? null
                : _messages!.read!.isEmpty && AppApis.user.uid == _messages!.fromId
                ? Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(50),
              ),
            )
                : Text(MyDateUtil.getLastMessageTime(
              context: context,
              time: _messages!.sent!,
            )),
          ),
        );
      },
    );
  }
}

