import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/variablePages/tests/TestEnterpoint.dart';

class UmfragePage extends StatefulWidget {
  const UmfragePage({super.key});

  @override
  State<UmfragePage> createState() => _UmfragePageState();
}

class _UmfragePageState extends State<UmfragePage> {
  double valueUmfrage = 0.0;
  bool ausgefuellt = false;
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
 

  void _sendPainLevel()async{
    await _laxoutBackend.postPainLevel(valueUmfrage.round());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Umfrage:",
          style: TextStyle(
            fontFamily: "Laxout",
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Text(
                    "Wie schlimm sind ihre Rückenschmerzen gerade von 1-10?",
                    style: TextStyle(
                      fontFamily: "Laxout",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40,),

                  Row(
                    children: [
                      const Text("0", style: TextStyle(fontSize: 15,fontFamily: "Laxout"),),
                      Expanded(
                        child: Slider(value: valueUmfrage, onChanged: ((value) {
                          setState(() {
                            valueUmfrage = value;
                          });
                        }), activeColor: Appcolors.primary,
                        inactiveColor: Appcolors.primary,
                        divisions: 10,
                        label: valueUmfrage.round().toString(),
                        min: 0,
                        max: 10,
                        secondaryTrackValue: valueUmfrage,
                        onChangeStart: (value) {
                          setState(() {
                            ausgefuellt = true;
                          });
                        },
                        ),
                      ),
                      const Text("10", style: TextStyle(fontSize: 15, fontFamily: "Laxout"),),
                    ],
                  ),
                  ],),
                  Expanded(child: Image.asset("assets/images/umfrage.png")),
                  InkWell(
                  onTap: () {
                    if (ausgefuellt == true) {
                      _sendPainLevel();
                     Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const TestsEnterPoint()),
                          (route) => false);
                    } 
                  },
                  child: Container(
                    height: 60,
                    width: 210,
                    decoration: BoxDecoration(
                        color: ausgefuellt? Appcolors.primary:const Color.fromRGBO(159, 217, 221, 1),
                        borderRadius: BorderRadius.circular(14)),
                    child: const Center(
                      child: Text(
                        "Bestätigen",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Laxout",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TestsEnterPoint()),
                          (route) => false);*/