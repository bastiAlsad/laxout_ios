import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';

class LineChartWidget extends StatefulWidget {
  final List indexes;
  const LineChartWidget({super.key, required this.indexes});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> spots = [];
  @override
  void initState() {
    int counter = 1;
    spots.add(FlSpot(0, 0));
    for(var i in widget.indexes){
      spots.add(FlSpot(counter.toDouble(), i));
      counter ++;
    }
    print(spots);
    super.initState();
  }
  bool showAvg = false;
  List<Color> gradientColors = [
    Colors.grey,
    Appcolors.primary,
  ];
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        mainData(),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Appcolors.primary,
            strokeWidth: 1,
          );
        },
       
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false, // Setze show auf false, um den Rand zu entfernen
      ),
      minX: 0,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          
          isCurved: true,
          barWidth: 5,
          color: Appcolors.primary,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color:
                    Appcolors.primary, // Ändere die Farbe nach deinen Wünschen
                strokeColor:
                    Colors.transparent, // Setze die Strichfarbe auf transparent
                strokeWidth:
                    0, // Setze die Strichstärke auf 0, um die Ränder zu entfernen
              );
            },
          ),

          belowBarData: BarAreaData(
            show: true,
            color: Color.fromRGBO(227, 225, 225, 0.486)
          
          ),
        ),
      ],
    );
  }
}
