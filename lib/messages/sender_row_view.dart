import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';


class SenderRowView extends StatelessWidget {
  const SenderRowView({Key? key, required this.senderMessage})
      : super(key: key);

  final String senderMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
                left: 15.0, right: 5.0, top: 8.0, bottom: 2.0),
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
              senderMessage,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.0, top: 5),
          child: CircleAvatar(
            backgroundColor: Appcolors.primary,
            child: Text('Sie',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}
