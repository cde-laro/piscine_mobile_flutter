import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'meteo.dart';

class TemperatureChart extends StatefulWidget {
  final List<Meteo> meteos;

  const TemperatureChart({super.key, required this.meteos});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

List<double> findMinMaxY(List<List<FlSpot>> spots) {
  double minY = double.infinity;
  double maxY = double.negativeInfinity;

  for (List<FlSpot> spotList in spots) {
    for (FlSpot spot in spotList) {
      if (spot.y < minY) {
        minY = spot.y;
      }
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }
  }

  return [minY, maxY];
}

List<FlSpot> createFlSpots(List<Meteo> meteos) {
  return meteos.asMap().entries.map((entry) {
    int index = entry.key;
    Meteo meteo = entry.value;
    return FlSpot(index.toDouble(), extractTemperature(meteo.temperature));
  }).toList();
}

double extractTemperature(String tempString) {
  String numberPart = tempString.split('°')[0];
  return double.parse(numberPart);
}

class _TemperatureChartState extends State<TemperatureChart> {
  List<Color> gradientColors = [
    Colors.blueAccent,
    const Color.fromARGB(255, 19, 64, 86),
  ];

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = createFlSpots(widget.meteos);
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 12,
              bottom: 12,
            ),
            child: LineChart(
              mainData(spots),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('00:00', style: style);
        break;
      case 6:
        text = const Text('06:00', style: style);
        break;
      case 12:
        text = const Text('12:00', style: style);
        break;
      case 18:
        text = const Text('18:00', style: style);
        break;
      case 24:
        text = const Text('24:00', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      color: Colors.white,
    );
    String text;
    if (value.toInt() % 5 != 0) {
      text = '';
    } else {
      text = '${value.toInt()}°C';
    }

    return Text(text, style: style, textAlign: TextAlign.right);
  }

  LineChartData mainData(spots) {
    var min = findMinMaxY([spots])[0].roundToDouble() - 5;
    var max = findMinMaxY([spots])[1].roundToDouble() + 5;
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: spots.length.toDouble() - 1,
      minY: min,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
