import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:new_projekt/navPages/AppWrapper.dart';
import 'models/ownWorkoutList.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UebungListAdapter());
  await Hive.openBox("Heatmap");
  await Hive.openBox("Test_field");
  await Hive.openBox("Anyalyse_Data");
  await Hive.openBox("EverOpened");
  await Hive.openBox(
      "Workout_Map"); // Saves all Workouts you can see on the Own Workout Page
  await Hive.openBox("Workout_List");
  await Hive.openBox("Controll_Time");
  await Hive.openBox(
      "Credits"); // Saves all Lists for every Own created Workout (for the Navigation)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: Wrapper(), // ändern Wrapper(),
    ),
  );
}
