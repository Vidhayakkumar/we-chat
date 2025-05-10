import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/helper.dart';
import 'package:we_chat/helper/custom_widget/message_card.dart';
import 'package:we_chat/model/chat_model.dart';
import 'package:we_chat/model/chat_user_model.dart';

class ChatSection extends StatefulWidget {
  final ChatUserModel userList;
  const ChatSection({super.key, required this.userList});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  TextEditingController _messageController = TextEditingController();
  List<ChatModel> messageList = [];

  bool showEmoji = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 251, 253),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
              margin:
              EdgeInsets.only(top: mq.height * .035, left: mq.width * .02),
              child: _appBarWidget(mq)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: AppApis.getAllMessages(widget.userList),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!.docs;
                      messageList =
                          data.map((e) => ChatModel.fromJson(e.data())).toList();
                    }
                    return ListView.builder(
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          return MessageCard(messageList: messageList[index]);
                        });
                  },
                ),
              ),
              _chatInputBox(mq),
              if (showEmoji)
                SizedBox(
                  height: mq.height * 0.35,
                  child: EmojiPicker(
                    textEditingController: _messageController,
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      categoryIcons: CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),

                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarWidget(Size mq) {
    return Row(
      children: [
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
        const CircleAvatar(
          child: Icon(CupertinoIcons.person, color: Colors.white),
          backgroundColor: Colors.blue,
        ),
        mSpacer(height: 0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userList.name,
              style: TextStyle(
                fontSize: mq.width * .05,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text('last seen not available')
          ],
        )
      ],
    );
  }

  Widget _chatInputBox(Size mq) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Card(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() => showEmoji = !showEmoji);
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () => setState(() => showEmoji = false),
                      style: const TextStyle(color: Colors.blueAccent),
                      cursorColor: Colors.blueAccent,
                      decoration: const InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.image, color: Colors.blueAccent)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent))
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            shape: const CircleBorder(),
            color: Colors.green,
            padding: const EdgeInsets.all(10),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                AppApis.sendMessage(
                    widget.userList, _messageController.text.trim());
                _messageController.clear();
              }
            },
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
