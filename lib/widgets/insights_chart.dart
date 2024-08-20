import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphComponent extends StatefulWidget {
  final void Function(String tabName) updateActiveTab;
  GraphComponent({super.key, required this.updateActiveTab});
  @override
  _GraphComponentState createState() => _GraphComponentState();
}

class _GraphComponentState extends State<GraphComponent>
    with SingleTickerProviderStateMixin {
  String activeTab = 'Soil Health';
  Color topBarColor = const Color(0xFFFFCD71);

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: topBarColor,
      end: topBarColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateTab(String title, void Function(String title) updateActiveTab) {
    Color newColor;

    switch (title) {
      case 'Soil Health':
        newColor = const Color(0xFFFFCD71);
        break;
      case 'Vegetation':
        newColor = const Color(0xFFADF090);
        break;
      case 'Weather':
        newColor = const Color(0xFFDDEFF2);
        break;
      default:
        newColor = const Color(0xFFFFCD71);
    }

    setState(() {
      activeTab = title;
      updateActiveTab(title);
      _colorAnimation = ColorTween(
        begin: topBarColor,
        end: newColor,
      ).animate(_controller);
      _controller.forward(from: 0);
      topBarColor = newColor;
    });
  }

  Widget renderContent() {
    switch (activeTab) {
      case 'Soil Health':
        return renderSoilHealthSection();
      case 'Vegetation':
        return renderVegetationSection();
      case 'Weather':
        return renderWeatherSection();
      default:
        return Container();
    }
  }

  Widget renderSoilHealthSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SoilHealthGraph(),
    );
  }

  Widget renderVegetationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: VegetationGraph(),
    );
  }

  Widget renderWeatherSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: WeatherGraph(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.3;

    return Center(
      child: Container(
        height: containerHeight,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    color: _colorAnimation.value,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildTab('Soil Health'),
                      buildTab('Vegetation'),
                      buildTab('Weather'),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: renderContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String title) {
    bool isActive = activeTab == title;

    return GestureDetector(
      onTap: () {
        updateTab(title, widget.updateActiveTab);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "Poppins",
            color: isActive ? Colors.black : const Color(0xFF555555),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            decoration:
                isActive ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class SoilHealthGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final soilData = [
      SoilData(
          date: DateTime(2024, 8, 10),
          moisture: 0.35,
          temperatureGradient: 0.4),
      SoilData(
          date: DateTime(2024, 8, 11),
          moisture: 0.3,
          temperatureGradient: 0.35),
      SoilData(
          date: DateTime(2024, 8, 12),
          moisture: 0.45,
          temperatureGradient: 0.55),
      SoilData(
          date: DateTime(2024, 8, 13),
          moisture: 0.65,
          temperatureGradient: 0.25),
      SoilData(
          date: DateTime(2024, 8, 14),
          moisture: 0.35,
          temperatureGradient: 0.65),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final date = soilData[value.toInt()].date;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "${date.month}/${date.day}",
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  // axisSide: meta.axisSide,
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: soilData
                .asMap()
                .map((index, value) =>
                    MapEntry(index, FlSpot(index.toDouble(), value.moisture)))
                .values
                .toList(),
            isCurved: true,
            color: Colors.redAccent,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.5),
                  Colors.red.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: soilData
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot(index.toDouble(), value.temperatureGradient)))
                .values
                .toList(),
            isCurved: true,
            color: Colors.blue,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

class VegetationGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vegetationData = [
      VegetationData(
          date: DateTime(2024, 8, 10), growthRate: 0.5, healthIndex: 0.7),
      VegetationData(
          date: DateTime(2024, 8, 11), growthRate: 0.55, healthIndex: 0.35),
      VegetationData(
          date: DateTime(2024, 8, 12), growthRate: 0.25, healthIndex: 0.25),
      VegetationData(
          date: DateTime(2024, 8, 13), growthRate: 0.45, healthIndex: 0.35),
      VegetationData(
          date: DateTime(2024, 8, 14), growthRate: 0.35, healthIndex: 0.5),
      VegetationData(
          date: DateTime(2024, 8, 15), growthRate: 0.15, healthIndex: 0.55),
      // Add more data here
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final date = vegetationData[value.toInt()].date;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "${date.month}/${date.day}",
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              // showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: vegetationData
                .asMap()
                .map((index, value) =>
                    MapEntry(index, FlSpot(index.toDouble(), value.growthRate)))
                .values
                .toList(),
            isCurved: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.5),
                  Colors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: vegetationData
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot(index.toDouble(), value.healthIndex)))
                .values
                .toList(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

class WeatherGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherData = [
      WeatherData(date: DateTime(2024, 8, 10), temperature: 30, humidity: 70),
      WeatherData(date: DateTime(2024, 8, 11), temperature: 28, humidity: 65),
      WeatherData(date: DateTime(2024, 8, 12), temperature: 22, humidity: 61),
      WeatherData(date: DateTime(2024, 8, 13), temperature: 23, humidity: 66),

      WeatherData(date: DateTime(2024, 8, 14), temperature: 21, humidity: 65),
      WeatherData(date: DateTime(2024, 8, 15), temperature: 26, humidity: 63),
      WeatherData(date: DateTime(2024, 8, 16), temperature: 27, humidity: 62),

      // Add more data here
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final date = weatherData[value.toInt()].date;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "${date.month}/${date.day}",
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weatherData
                .asMap()
                .map((index, value) => MapEntry(index,
                    FlSpot(index.toDouble(), value.temperature.toDouble())))
                .values
                .toList(),
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.5),
                  Colors.orange.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            spots: weatherData
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot(index.toDouble(), value.humidity.toDouble())))
                .values
                .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SoilData {
  final DateTime date;
  final double moisture;
  final double temperatureGradient;

  SoilData(
      {required this.date,
      required this.moisture,
      required this.temperatureGradient});
}

class VegetationData {
  final DateTime date;
  final double growthRate;
  final double healthIndex;

  VegetationData(
      {required this.date,
      required this.growthRate,
      required this.healthIndex});
}

class WeatherData {
  final DateTime date;
  final int temperature;
  final int humidity;

  WeatherData(
      {required this.date, required this.temperature, required this.humidity});
}