import 'package:flutter/material.dart';
import 'package:laxout/mesagges/receiver_row_view.dart';
import 'package:laxout/mesagges/sender_row_view.dart';

class ChatListView extends StatelessWidget {
  final List messageList;
  const ChatListView(
      {Key? key, required this.scrollController, required this.messageList})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: messageList.length,
      itemBuilder: (context, index) => (messageList[index].isSender)
          ? SenderRowView(senderMessage: messageList[index].message)
          : ReceiverRowView(receiverMessage: messageList[index].message),
    );
  }
}
