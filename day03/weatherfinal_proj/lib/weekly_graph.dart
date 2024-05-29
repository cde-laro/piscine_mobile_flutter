import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'meteo.dart';

class WeeklyTemperatureChart extends StatefulWidget {
  final List<Meteo> meteos;

  const WeeklyTemperatureChart({super.key, required this.meteos});

  @override
  State<WeeklyTemperatureChart> createState() => _WeeklyTemperatureChartState();
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

List<FlSpot> createFlSpotsMin(List<Meteo> meteos) {
  return meteos.asMap().entries.map((entry) {
    int index = entry.key;
    Meteo meteo = entry.value;
    return FlSpot(index.toDouble(), extractTemperatures(meteo.temperature)[0]);
  }).toList();
}

List<FlSpot> createFlSpotsMax(List<Meteo> meteos) {
  return meteos.asMap().entries.map((entry) {
    int index = entry.key;
    Meteo meteo = entry.value;
    return FlSpot(index.toDouble(), extractTemperatures(meteo.temperature)[1]);
  }).toList();
}

List<double> extractTemperatures(String tempString) {
  List<String> parts = tempString.split(' - ');
  double temp1 = double.parse(parts[0]);
  double temp2 = double.parse(parts[1].split('°')[0]);
  return [temp1, temp2];
}

class _WeeklyTemperatureChartState extends State<WeeklyTemperatureChart> {
  List<Color> minGradientColors = [
    Colors.blueAccent,
    const Color.fromARGB(255, 19, 64, 86),
  ];

  List<Color> maxGradientColors = [
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  @override
  Widget build(BuildContext context) {
    List<FlSpot> minSpots = createFlSpotsMin(widget.meteos);
    List<FlSpot> maxSpots = createFlSpotsMax(widget.meteos);
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
              mainData(minSpots, maxSpots, widget.meteos),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, meteos) {
    const style = TextStyle(
      fontSize: 14,
      color: Colors.white,
    );
    String text;
    if (value.toInt() % 2 != 1) {
      text = '';
    } else {
      text = DateFormat('dd/MM')
          .format(DateTime.parse(meteos[value.toInt()].time));
    }

    return Text(text, style: style, textAlign: TextAlign.right);
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

  LineChartData mainData(minSpots, maxSpots, meteos) {
    var min = findMinMaxY([minSpots, maxSpots])[0].roundToDouble() - 5;
    var max = findMinMaxY([minSpots, maxSpots])[1].roundToDouble() + 5;
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
            getTitlesWidget: (double value, TitleMeta meta) =>
                bottomTitleWidgets(value, meta, meteos),
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
      maxX: minSpots.length.toDouble() - 1,
      minY: min,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: minSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: minGradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: minGradientColors
                  .map((color) => color.withOpacity(0.5))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: maxSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: maxGradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: maxGradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
