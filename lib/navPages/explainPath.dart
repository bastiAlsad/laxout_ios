import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';

class ExplainPath extends StatefulWidget {
  const ExplainPath({super.key});

  @override
  State<ExplainPath> createState() => _ExplainPathState();
}

class _ExplainPathState extends State<ExplainPath> {
  final PageController _controller = PageController();

  List images = [
    "assets/images/ausfuehrungPhone.jpeg",
    "assets/images/coinsPhone.jpeg",
    "assets/images/eigenePhone.jpeg",
    "assets/images/kalenderPhone.jpeg",
    "assets/images/shopPhone.jpeg",
    "assets/images/einloesenPhone.jpeg",
  ];

  List texte = [
    "Tippe auf die Lampe und bekomme die Ausührung der jeweiligen Übung angezeigt",
    "Sammle Coins und Streaks",
    "Erstelle deine eigene Routine",
    "Tracke deinen Fortschritt",
    "Erhalte Belohnungen von unseren Partnern",
    "Löse deine Couponcodes bei den Partnern ein"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(images[index]),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(
                      texte[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: "Laxout", fontSize: 23,height: 1.1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (index + 1 < images.length) {
                              _controller.animateToPage(
                                  index + 1 < images.length ? index + 1 : index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const MyBottomNavigationBar()),
                                  (route) => false);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                index < images.length - 1 ? "Weiter" : "Fertig",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        index < images.length - 1
                            ? TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const MyBottomNavigationBar()),
                                      (route) => false);
                                },
                                child: const Text(
                                  "Tutorial Überspringen",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ]),
          );
        },
      ),
    );
  }
}
