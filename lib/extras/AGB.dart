// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navPages/EnterAcess.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';

import '../navigation/Side_Nav_Bar.dart';

// ignore: must_be_immutable
class AGB extends StatefulWidget {
  String textFromFile;
  bool navigateHome;
  AGB({Key? key, required this.textFromFile, this.navigateHome = true})
      : super(key: key);

  @override
  State<AGB> createState() => _AGBState();
}

class _AGBState extends State<AGB> {
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
        title: const Text(
          "AGBs",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ListView(children: [
                  Image.asset('assets/images/Logo.png',
                      width: 120, height: 120),
                ]),
              ),
              Text(widget.textFromFile, textAlign: TextAlign.left),
              Column(
                children: [
                  InkWell(
                      onTap: () {
                        widget.navigateHome
                            ? Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const MyBottomNavigationBar()),
                                (route) => false)
                            : Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const EnterAcess()),
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
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
