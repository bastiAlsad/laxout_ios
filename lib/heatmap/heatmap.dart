import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/chart/LineChart.dart';
import 'package:new_projekt/chart/PieChart.dart';

import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';

class Heatmap extends StatefulWidget {
  const Heatmap({
    super.key,
  });

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  Map<DateTime, int> datasetsWish = {};
  late DateTime startDateWish;
  final HiveHeatmap _heatmap = HiveHeatmap();
  final LaxoutBackend _backend = LaxoutBackend();
  List indexes = [];

  @override
  void initState() {
    datasetsWish = _heatmap.getDatasets();
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
          "Analysen",
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Laxout"),
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ihre Aktivität:",
                  style: TextStyle(
                      fontFamily: "Laxout",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  "Was ist die Aktivität ?",
                                  style: TextStyle(
                                      fontFamily: "Laxout", fontSize: 20),
                                ),
                                actions: [
                                  Text(
                                    "Jedes mal, wenn Sie Ihr individuelles Physio Workout machen, zeigt dieser Kalender dieses Datum als türkises Feld an. Ein graues Feld bedeutet, dass Sie an diesem Tag nicht aktiv waren. Wischen Sie nach links oder rechts, um in der Zeit zurück oder nach Vorne zu gehen.",
                                    style: TextStyle(
                                        fontFamily: "Laxout", fontSize: 13),
                                  )
                                ],
                              ));
                    },
                    icon: Icon(Icons.info))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: HeatMap(
              startDate: startDateWish.subtract(const Duration(days: 2)),
              endDate: DateTime.now().add(const Duration(days: 41)),
              datasets: datasetsWish,
              colorMode: ColorMode.color,
              defaultColor: Color.fromRGBO(227, 225, 225, 0.486),
              textColor: Colors.black,
              showColorTip: false,
              showText: true,
              scrollable: true,
              size: 45,
              colorsets: const {
                0: Colors.transparent,
                1: Color.fromRGBO(176, 224, 230, 1.0),
              },
              onClick: (value) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(value.toString())));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ihr Wohlbefinden:",
                  style: TextStyle(
                      fontFamily: "Laxout",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  "Was zeigt dieses Diagramm ?",
                                  style: TextStyle(
                                      fontFamily: "Laxout", fontSize: 20),
                                ),
                                actions: [
                                  Text(
                                    "Sie werden in der App immer mal wieder nach Ihrem Wohlbefinden, bzw. Ihren Schmerzen gefragt. Dieses Diagramm zeigt den durchschnittlichen Wert im wöchentlichen Intervall an: Die X-Achse steht für die Woche und die Y-Achse für den durchschnittlichen Wert, der sich aus Ihren Eingaben für jede Woche berechnet. Drücken Sie auf das Diagramm und schieben Sie ihren Finger gedrückt nach rechts oder links, um sich den genauen Wert einer Woche anzeigen zu lassen.",
                                    style: TextStyle(
                                        fontFamily: "Laxout", fontSize: 13),
                                  )
                                ],
                              ));
                    },
                    icon: Icon(Icons.info))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: FutureBuilder(
                future: _backend.returnUserIndexList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitFadingFour(
                      color: Appcolors.primary,
                    );
                  }
                  final data = snapshot.data ?? [];
                  return LineChartWidget(
                    indexes: data,
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ihre Erfolgsquote:",
                  style: TextStyle(
                      fontFamily: "Laxout",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  "Was zeigt dieses Diagramm ?",
                                  style: TextStyle(
                                      fontFamily: "Laxout", fontSize: 20),
                                ),
                                actions: [
                                  Text(
                                    "Dieses Diagramm zeigt, zu wie viel Prozent Sie sich nach einem Workout besser oder schlechter Gefühlt haben. Die Daten stammen aus der Erfolgskontrolle am Ende des Physio-Workouts.",
                                    style: TextStyle(
                                        fontFamily: "Laxout", fontSize: 13),
                                  )
                                ],
                              ));
                    },
                    icon: Icon(Icons.info))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PieChartSample2(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(227, 225, 225, 0.486),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Es ging Ihnen schlechter",
                          style: TextStyle(fontFamily: "Laxout", fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Es ging Ihnen besser",
                          style: TextStyle(fontFamily: "Laxout", fontSize: 12),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}
