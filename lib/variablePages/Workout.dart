// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:new_projekt/variablePages/workout/workoutTile.dart';

// ignore: must_be_immutable
class Workout extends StatefulWidget {
  String workoutName;
  List<String> listeUebungen;
  String dauer;
  String bereich;
  List<String> listeFotos;

  Icon benoutigtesName;
  VoidCallback start;

  Workout({
    Key? key,
    required this.workoutName,
    required this.listeUebungen,
    required this.listeFotos,
    required this.dauer,
    required this.bereich,
    required this.benoutigtesName,
    required this.start,
  }) : super(key: key);

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          toolbarHeight: 70,
          centerTitle: true,
          title: Text(
            widget.workoutName,
            style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0)),
              color: Color.fromRGBO(176, 224, 230, 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: Column(
  children: <Widget>[
    SizedBox(
      width: double.infinity,
      height: 80.0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(30, 20, 30, 5),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.timer,
                    size: 35,
                    color: Colors.white,
                  ),
                  Text(
                    widget.dauer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              Container(
                child: widget.benoutigtesName,
              ),
            ],
          ),
        ),
      ),
    ),
    SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 0, 5),
        child: const Text(
          'Übungen:',
          style: TextStyle(fontSize: 25, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: widget.listeUebungen.length,
        itemBuilder: ((context, index) {
          return WorkoutTile(
            u1: widget.listeUebungen[index],
            imageName: widget.listeFotos[index],
          );
        }),
      ),
    ),
    SizedBox(
      height: 140.0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20.0,
                offset: Offset(0, 10),
              )
            ],
          ),
          margin: const EdgeInsets.fromLTRB(70, 0, 70, 20),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.white;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: widget.start,
            child: const SizedBox(
              width: 200,
              height: 70,
              child: Center(
                child: Text(
                  'Starten',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ],
)
));
  }
}
