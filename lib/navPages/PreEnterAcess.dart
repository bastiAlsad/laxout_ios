import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navPages/EnterAcess.dart';
import 'package:new_projekt/navPages/EnterAcess2.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Bevor es losgegt...", style: TextStyle(fontFamily: "Laxout", fontSize: 23, color: Colors.black),),
        actions: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset("assets/images/Logoohneschrift.png", width: 60, height: 60,),
        )],
        elevation: 0,
      ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(),
              Container(
                width: 300,
                height: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 15),
                      BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(-5, -5),
                          blurRadius: 15),
                    ]),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                                "Haben Sie eine Willkomens-Email von Ihrem Physiotherapeuten mit Workout Code erhalten ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Laxout")),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>EnterAcess()), (route) => false);
                                },
                                child: Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Appcolors.primary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Ja",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: "Laxout")),
                                        Icon(
                                          Icons.done,
                                          size: 15,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => EnterAcess2()), (route) => false);
                                },
                                child: Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Appcolors.primary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Nein",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: "Laxout")),
                                        Icon(
                                          Icons.cancel,
                                          size: 15,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ));
  }
}
