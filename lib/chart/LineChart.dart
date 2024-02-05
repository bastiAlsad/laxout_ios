import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
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
      minX: 1,
      minY: 1,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(1, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          
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
