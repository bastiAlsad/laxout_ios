// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/models/textfield.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';

import '../services/hive_communication.dart';

class ownWoDialog extends StatefulWidget {
  final Function addWorkout;
  const ownWoDialog({
    Key? key,
    required this.addWorkout,
  }) : super(key: key);

  @override
  State<ownWoDialog> createState() => _ownWoDialogState();
}

class _ownWoDialogState extends State<ownWoDialog> {
  bool w1 = false;
  bool w2 = false;
  bool w3 = false;
  bool w4 = false;
  List<dynamic> ownWorkout1 = [];
  List<dynamic> ownWorkout2 = [];
  List<dynamic> ownWorkout3 = [];
  List<dynamic> ownWorkout4 = [];
  
  @override
  void initState() {
    
    _hive.selectedList();
    if(_hive.w1 == true&& _hive.w2 != true&& _hive.w3 != true&& _hive.w4 != true){
      w1=true;
    }
    if(_hive.w2 == true){
      w1=false;
      w2=true;
    }
    if(_hive.w3== true){
      w2=false;
      w3=true;
    }
    if(_hive.w4== true){
      w4=true;
      w3=false;
    }
    if (_myBox.isEmpty) {
      _hive.createInitialData();
    } else {
      _hive.loadData();
    }

    _hive.loadOwnWorkout();

    _hive.loadOwnWorkout2();

    _hive.loadOwnWorkout3();
    
    _hive.loadOwnWorkout4();

    

    super.initState();
    
  }

  void goBack() {
    Navigator.of(context).pop;
  }

  final HiveDatabase _hive = HiveDatabase();
  void addWorkout(String todo) {
    setState(() {
      _hive.workouts[todo] = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const MyBottomNavigationBar(startindex: 2)),
    );
  }
  TextEditingController _controller = TextEditingController();

  final _myBox = Hive.box("Workout_Map");
  bool added = false;
  int ownWorkoutIndex = 0;
  String nameWorkout = "";

  _ownWoDialogState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          toolbarHeight: 70,
          centerTitle: true,
          title: const Text(
            "Workout Erstellen",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Appcolors.primary, width: 4),
                    borderRadius: BorderRadius.circular(24)),
                child: Center(
                  child: MyTextField(
                      controller: _controller,
                      text: "Bitte Namen eingeben",
                      obscureText: false,
                      fontSize: 14),
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:30.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                    itemCount: _hive.uebungList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final uebung = _hive.uebungList[index];

                      return ListTile(
                        selectedColor: Colors.white,
                        onTap: () {
                          setState(() {
                            _hive.selectedList().removeAt(_hive
                                .selectedList()
                                .indexOf(_hive.uebungList[index]));
                            _hive.uebungList[index].added = false;
                            ownWorkoutIndex = _hive.selectedList().length;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        iconColor: _hive.uebungList[index].added
                            ? const Color.fromRGBO(176, 224, 230, 1.0)
                            : Colors.black,
                        leading: SizedBox(height:50,width:70, child:Image.asset(uebung.imagePath),),
                        title: Text(uebung.name),
                        trailing: IconButton(
                            onPressed: ()  {
                              setState(() {

                               // _hive.selectedList().add(_hive.uebungList[index]);

                                if (w1 == true) {
                                  _hive.ownWorkout1.add(_hive.uebungList[index]);
                                  _hive.createOwnWorkout();
                                } else {
                                  if (w2 == true) {
                                    _hive.ownWorkout2.add(_hive.uebungList[index]);
                                    _hive.createOwnWorkout2();
                                  } else {
                                    if (w3 == true) {
                                      _hive.ownWorkout3.add(_hive.uebungList[index]);
                                      _hive.createOwnWorkout3();
                                    } else {
                                      if (w4 == true) {
                                        _hive.ownWorkout4.add(_hive.uebungList[index]);
                                        _hive.createOwnWorkout4();
                                      }
                                    }
                                  }
                                }
                                setState(() {
                                  _hive.uebungList[index].added = true;
                                  ownWorkoutIndex = _hive.selectedList().length;
                                });
                              });
                            },
                            icon: const Icon(Icons.add)),
                      );
                    },
                  ),
                ),
              ),
              
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 10),
                height: 50,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                    
                      onTap: () {
                        addWorkout(_controller.text);
                        for (int i = 0; i < _hive.uebungList.length; i++) {
                          _hive.uebungList[i].added = false;
                        }
                        setState(() {});
                        _hive.selectedList();
                        _hive.updateDataMap();
                        goBack();
                        // Aktualisierung der Datenmappe
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width/3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(176, 224, 230, 1.0),
                        ),
                        child: const Center(
                            child: Text(
                          'Hinzufügen',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        for (int i = 0; i < _hive.uebungList.length; i++) {
                          _hive.uebungList[i].added = false;
                        }
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width/3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(176, 224, 230, 1.0),
                        ),
                        child: const Center(
                            child: Text(
                          'Abbrechen',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ));
  }
}
