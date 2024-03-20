import 'package:flutter/material.dart';

class ReceiverRowView extends StatelessWidget {
  const ReceiverRowView({Key? key, required this.receiverMessage})
      : super(key: key);

  final String receiverMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset("assets/images/Logoohneschrift.png")),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
                right: 15.0, left: 7.0, top: 8.0, bottom: 2.0),
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
            ),
            child: Text(
              receiverMessage,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
