
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/helper.dart';
import 'package:we_chat/helper/custom_widget/message_card.dart';
import 'package:we_chat/model/chat_model.dart';
import 'package:we_chat/model/chat_user_model.dart';

import '../main.dart';

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
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 251, 253),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            margin: EdgeInsets.only(top: mq.height * .035, left:  mq.width *.02),
              child: _appBarWidget()),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: AppApis.getAllMessages(widget.userList),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }else if(snapshot.hasError){
                        return Center(child: Text(snapshot.error.toString()),);
                      }else if(snapshot.hasData){
                        final data = snapshot.data!.docs;
                       messageList = data.map((e) => ChatModel.fromJson(e.data())).toList();
                      }
                      return ListView.builder(
                          itemCount: messageList.length,
                          itemBuilder: (context , index){
                        return MessageCard(messageList: messageList[index],);
                      });
                    }
                ),
              ),
              _chatInputBox(),

              // if(showEmoji)
              //   SizedBox(
              //     height: mq.height * .35,
              //     child: EmojiPicker(
              //       textEditingController: _messageController,
              //     ),
              //   )

            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarWidget(){
    return Row(
      children: [
       IconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),
        
       CircleAvatar(
         child: Icon(CupertinoIcons.person,color: Colors.white,),
         backgroundColor: Colors.blue,
       ),

        mSpacer(
          height: 0
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(widget.userList.name,style: TextStyle(
             fontSize: mq.width * .05,
             fontWeight: FontWeight.w400,
           ),),
           Text('last seen not available')
         ],
        )

      ],
    );
  }
  Widget _chatInputBox(){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
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
                      onPressed: (){
                        FocusScope.of(context).unfocus();
                        setState(()=> showEmoji = !showEmoji);
                      },
                      icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,)
                  ),

                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () => setState(() => showEmoji = false),
                      style: TextStyle(
                        color: Colors.blueAccent
                      ),
                      cursorColor: Colors.blueAccent,
                      decoration: InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(
                          color: Colors.blueAccent
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),

                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.image,color: Colors.blueAccent,)
                  ), IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.camera_alt_rounded,color: Colors.blueAccent,)
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            shape: CircleBorder(),
            color: Colors.green,
            padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 5),
              onPressed: (){

              if(_messageController.text.isNotEmpty){
                AppApis.sendMessage(
                      widget.userList
                    , _messageController.text.trim()
                );
                _messageController.clear();
              }

              } ,
            child: Icon(Icons.send,color: Colors.white,size: 28,),
          )
        ],
      ),
    );
  }

}
