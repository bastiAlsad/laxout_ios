import 'package:flutter/material.dart';
import 'package:new_projekt/messages/chart_list_view.dart';
import 'package:new_projekt/messages/message_data_model.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();
  List<MessageData> messageList = [];
  Future<void> scrollAnimation() async {
    return await Future.delayed(
        const Duration(milliseconds: 100),
        () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Appcolors.primary,
        leadingWidth: 50.0,
        titleSpacing: -8.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 14.0),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset("assets/images/Logoohneschrift.png")),
        ),
        title: const ListTile(
          title: Text('Laxout',
              style: TextStyle(
                color: Colors.white,
              )),
          subtitle: Text('verfügbar',
              style: TextStyle(
                color: Colors.white70,
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MyBottomNavigationBar(startindex: 0)),
                    (route) => false);
              },
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatListView(
            scrollController: scrollController,
            messageList: messageList,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Container(
              // height: 50,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 15),
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(-5, -5),
                        blurRadius: 15),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(),
                    Expanded(
                      child: Center(
                        child: TextFormField(
                          controller: textEditingController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 6,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Nachricht eingeben:',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 11.0),
                      child: Transform.rotate(
                        angle: -3.14 / 5,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                messageList.add(MessageData("TEst", false));
                                textEditingController.clear();
                                scrollAnimation();
                              });

                              print(textEditingController.text);
                            },
                            child: const Icon(
                              Icons.send,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}