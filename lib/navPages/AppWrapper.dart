import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_projekt/navPages/PreEnterAcess.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  bool isConnected = false;
  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    isConnected = false;
    return false;
  }

  @override
  void initState() {
    isInternetConnected();
    _initializeApp();
    super.initState();
  }

  final HiveDatabase _hive = HiveDatabase();

  bool registert = false;

  void _initializeApp() async {
    if (_hive.neverOpened() != true) {
      registert = true;
    }
    String? kacka = await _laxoutBackend.getLaxoutCoinsAmount() ;
    if (kacka == null && isConnected == true) {
      registert = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return registert ? const MyBottomNavigationBar(startindex: 0,) : const Question();
  }
}
