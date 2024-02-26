import 'package:flutter/material.dart';
import 'package:new_projekt/heatmap/heatmap.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navPages/Homepage.dart';
import 'package:new_projekt/navPages/ownWoPage.dart';
import 'package:new_projekt/navPages/shopPage.dart';


class MyBottomNavigationBar extends StatefulWidget {
  final int startindex;
  const MyBottomNavigationBar({super.key, required this.startindex});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int currentPageIndex = 0;
  
  @override
  void initState() {
    currentPageIndex = widget.startindex;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Appcolors.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white,),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.nature),
            selectedIcon: Icon(Icons.nature, color: Colors.white,),
            label: 'LaxBaum',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: Colors.white,),
            label: 'Analysen',
          ),
          NavigationDestination(
            icon: Icon(Icons.shop),
            selectedIcon: Icon(Icons.shop, color: Colors.white,),
            label: 'Shop',
          ),
        ],
      ),
      body: <Widget>[
         const Homepage(),
    const LaxBaum(),
    const Heatmap(),
    const ShopPage()
      ][currentPageIndex],
    );
  }
}
