import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/extras/AGB.dart';
import 'package:new_projekt/messages/message_data_model.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navPages/AppWrapper.dart';
import 'package:new_projekt/navPages/ChatPage.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';

import '../extras/Datenschutz.dart';

import 'Bottom_Navigation_Bar.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  final LaxoutBackend _backend = LaxoutBackend();
  final HiveDatabase _hive = HiveDatabase();
  bool showvisible = true;
  bool hidevisible = false;
  String textFromFile = "";
  getText(String text) async {
    String newText;
    newText = await rootBundle.loadString(text);
    setState(() {
      textFromFile = newText;
      showvisible = false;
      hidevisible = true;
    });
  }

  Future<String> getWorkoutCode() async {
    String code = await _backend.getWebCode();
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Appcolors.primary,
            ),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.asset('assets/images/Logo.png'))),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Colors.black),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyBottomNavigationBar(
                            startindex: 0,
                          )));
            },
          ),
          ListTile(
              leading: const Icon(Icons.account_balance_rounded,
                  color: Colors.black),
              title: const Text('Lizenzen'),
              onTap: () => showLicensePage(
                  context: context,
                  applicationIcon:
                      Image.asset("assets/images/Logoohneschrift.png"),
                  applicationName: "Laxout")),
          ListTile(
            leading: const Icon(Icons.info_rounded, color: Colors.black),
            title: const Text('Datenschutz'),
            onTap: () {
              getText('assets/fonts/daten.txt');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Datenschutz(
                            textFromFile: textFromFile,
                          )),
                  (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.black),
            title: const Text('AGBs'),
            onTap: () {
              getText('assets/fonts/Nutzungsbedingungen.txt');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AGB(
                            textFromFile: textFromFile,
                          )),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Badge(
              label: const Text("1"),
              isLabelVisible: new_message,
              child: const Icon(
                Icons.chat,
                color: Colors.black,
              ),
            ),
            title: const Text("Fragen"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const ChatPage()),
                  (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.computer, color: Colors.black),
            title: const Text('Laxout PC Version'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: const Text(
                          "Laxout Web Version:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: "Laxout"),
                        ),
                        actions: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Rufen Sie diese Seite auf dem PC auf:",
                                style: TextStyle(
                                    fontFamily: "Laxout", fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "https://laxout.live/",
                                style: TextStyle(
                                    fontFamily: "Laxout", fontSize: 15, decoration: TextDecoration.underline),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Geben Sie Ihren WebCode ein:",
                                style: TextStyle(
                                    fontFamily: "Laxout", fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              FutureBuilder(
                                  future: getWorkoutCode(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      String code = snapshot.data ?? "";
                                      return Container(
                                          height: 50,
                                          width: 140,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Appcolors.primary,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                            code,
                                            style:  TextStyle(fontSize: 16, color: Appcolors.primary),
                                          )));
                                    }
                                    return SpinKitFadingFour(
                                      color: Appcolors.primary,
                                    );
                                  }))
                            ],
                          )
                        ],
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: const Text(
                          "Ausloggen bestätigen",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: "Laxout"),
                        ),
                        actions: [
                          Column(
                            children: [
                              const Text(
                                  "Sind Sie sich sicher, dass Sie sich ausloggen möchten? Ihre Daten gehen möglicherweise verloren.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: "Laxout")),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Appcolors.primary,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Abbruch",
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
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: InkWell(
                                  onTap: () {
                                    _hive.putIndexPhysioList(0);
                                    _hive.clearControllTime();
                                    _hive.clearGenerallControllTime();
                                    _hive.removeUIDTOKEN();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const Wrapper()),
                                        (route) => false);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Appcolors.primary,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Loggout",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: "Laxout")),
                                          Icon(
                                            Icons.logout,
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
                      )));
            },
          ),
        ],
      ),
    );
  }
}
