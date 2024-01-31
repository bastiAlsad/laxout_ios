import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 150),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("assets/images/noData.png"),
                const Text(
                  "Hmm hier ist kein Test vorhanden. Bitte überprüfen Sie ihre Internetverbingung oder fragen Sie ihren Ansprechpartner mit dem Dashboard ob er schon ein Workout erstellt hat, um Punkte durch Tests sammeln zu können.",
                  style: TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: "Laxout"),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MyBottomNavigationBar()),
                          (route) => false);
                    },
                    child: Container(
                      height: 40,
                      width: 127,
                      decoration: BoxDecoration(
                          color: Appcolors.primary,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        "Zurück",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
