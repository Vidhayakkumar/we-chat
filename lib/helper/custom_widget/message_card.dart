import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/my_date_util.dart';
import 'package:we_chat/helper/dimension.dart';
import 'package:we_chat/model/chat_model.dart';

import '../../main.dart';


class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.messageList});
  final ChatModel messageList;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return AppApis.user.uid == widget.messageList.toId
        ?_greenMessage()
        :_blueMessage();
  }

  Widget _blueMessage() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth( // 👈 Shrink-wrap the content
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 1, // 👈 Limit max width
            ),
            child: Container(
              margin: EdgeInsets.only(
                left: AppDimension.width10,
                top: AppDimension.height20,
                bottom: AppDimension.width10,
                right: AppDimension.width10,
              ),
              padding: EdgeInsets.all(AppDimension.height5),
              decoration: BoxDecoration(
                color: Color.fromARGB(77, 127, 210, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimension.radius20),
                  topRight: Radius.circular(AppDimension.radius20),
                  bottomLeft: Radius.circular(AppDimension.radius20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimension.width5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.messageList.msg!,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: AppDimension.font15,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(MyDateUtil.getFormatTime(context: context, time: widget.messageList.sent!),
                          style: TextStyle(
                            fontSize: AppDimension.font10,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: AppDimension.width2),

                        widget.messageList.read!.isEmpty?
                        Icon(
                          Icons.done,
                          size: AppDimension.iconSize15,
                        ):Icon(
                          Icons.done_all_rounded,
                          color: Colors.blue,
                          size: AppDimension.iconSize15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage(){
    if (widget.messageList.read!.isEmpty && AppApis.user.uid == widget.messageList.toId) {
      // Safe read update after build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(milliseconds: 200));
        if (mounted) {
          AppApis.updateMessageReadStatus(widget.messageList);
          print('✅ Read status updated safely');
        }
      });
    }
    return Row(
      children: [
        IntrinsicWidth(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: mq.width *1
              ),
            child: Container(
              margin: EdgeInsets.only(
                  left: AppDimension.width10,
                  top: AppDimension.height20,
                  right: AppDimension.width10),
              padding: EdgeInsets.all(AppDimension.height5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(77, 178, 227, 81),
                  border: Border.all(color: Colors.lightGreen),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimension.radius20),
                      topRight: Radius.circular(AppDimension.radius20),
                      bottomRight: Radius.circular(AppDimension.radius20))),
              child: Padding(
                  padding: EdgeInsets.only(left: AppDimension.width5,right: AppDimension.height5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.messageList.msg!,
                        style: TextStyle(
                            fontSize: AppDimension.font15, color: Colors.black87),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(MyDateUtil.getFormatTime(context: context, time: widget.messageList.sent!),
                            style: TextStyle(
                                fontSize: AppDimension.font10, color: Colors.black87),
                          ),

                        ],
                      )
                    ],
                  )
              ),
            ),
          ),
        )

      ],
    );
  }
}
