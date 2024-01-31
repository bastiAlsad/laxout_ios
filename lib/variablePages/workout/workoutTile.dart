// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  final String u1;
  final String imageName;
  const WorkoutTile({
    Key? key,
    required this.u1,
    required this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150.0,
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20.0,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Row(children: <Widget>[
          SizedBox(
            height: 70,
            width: 70,
            child: Image.asset(imageName),
          ),
          Expanded(
              child: Text(
            u1,
            style: const TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.center,
          )),
        ]),
      ),
    );
  }
}
