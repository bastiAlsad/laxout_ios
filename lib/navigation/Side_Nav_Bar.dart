import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_projekt/extras/AGB.dart';


import '../extras/Datenschutz.dart';

import 'Bottom_Navigation_Bar.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(176, 224, 230, 1.0),
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
                      builder: (context) => const MyBottomNavigationBar()));
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
        ],
      ),
    );
  }
}
