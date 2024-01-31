import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';




class Heatmap extends StatefulWidget {
 

  const Heatmap({
    super.key,
  
  });

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  Map<DateTime, int> datasetsWish = {
  };
  late DateTime startDateWish;
  final HiveHeatmap _heatmap = HiveHeatmap();

@override
  void initState() {
    datasetsWish= _heatmap.getDatasets();
    startDateWish = _heatmap.everOpened();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text(
          "Kalender",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "Laxout"
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(
        children: [
          Center(
          child: HeatMap(
            startDate: startDateWish.subtract(const Duration(days: 2)),
            endDate: DateTime.now().add(const Duration(days: 31)),
            datasets: datasetsWish,
            colorMode: ColorMode.color,
            defaultColor: Colors.grey[200],
            textColor: Colors.black,
            showColorTip: false,
            showText: true,
            scrollable: true,
            size: 45,
            colorsets: const {
              0:Colors.transparent,
              1:  Color.fromRGBO(176, 224, 230, 1.0),
            },
            onClick: (value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value.toString())));
                  
            },
          ),
    ),
    
    
        ],
      ),
    drawer: const SideNavBar(),
   );
    
  }
}
