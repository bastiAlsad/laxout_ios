import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:new_projekt/navPages/Homepage.dart';
import 'package:new_projekt/navPages/ownWoPage.dart';
import 'package:new_projekt/navPages/shopPage.dart';


import '../heatmap/heatmap.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int index;
  const MyBottomNavigationBar({Key? key, this.index = 0}) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }
  List pages = [
    const Homepage(),
    const ownWorkoutPage(),
    const Heatmap(),
    const ShopPage()
  ];
  late int currentIndex;
  void onTab(int index) {
    setState(() {
      currentIndex =
          index; // der Index wird durch die bottom nacigation bar zugewiesen und in current index gespeichert
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(icon: Icons.home_filled,text: "Home",),
          GButton(icon: Icons.add_circle_outline_outlined,text: "Erstellen",),
          GButton(icon: Icons.calendar_month,text: "Kalender",),
          GButton(icon: Icons.shopping_bag,text: "LaxShop",),
        ],
        onTabChange: onTab,
        selectedIndex: currentIndex,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black,fontWeight:FontWeight.w600),
        gap: 0,

      ),
    );
  }
}