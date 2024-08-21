import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/soildata.dart';
import '../models/vegetationdata.dart';
import '../models/weatherdata.dart';

class GraphComponent extends StatefulWidget {
  final SoilData soilData;
  final VegetationData vegetationData;
  final List<WeatherData> weatherData;
  final void Function(String tabName) updateActiveTab;
  GraphComponent(
      {super.key,
      required this.updateActiveTab,
      required this.soilData,
      required this.vegetationData,
      required this.weatherData});
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
        return renderSoilHealthSection(widget.soilData);
      case 'Vegetation':
        return renderVegetationSection(widget.vegetationData);
      case 'Weather':
        return renderWeatherSection(widget.weatherData);
      default:
        return Container();
    }
  }

  Widget renderSoilHealthSection(soilData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SoilHealthGraph(soilData: soilData),
    );
  }

  Widget renderVegetationSection(vegetationData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: VegetationGraph(vegetationData: vegetationData),
    );
  }

   Widget renderWeatherSection(weatherData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: WeatherGraph(weatherData: weatherData),
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.3;

    return Center(
      child: Container(
        height: containerHeight,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xffD2D5DA),
            width: 2.0,
          ),
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

class SoilHealthGraph extends StatefulWidget {
  final SoilData soilData;
  SoilHealthGraph({super.key, required this.soilData});
  _SoilHealthGraphState createState() => _SoilHealthGraphState();
}

class _SoilHealthGraphState extends State<SoilHealthGraph> {
  var soilDataList = [
    SoilData(
        date: DateTime(2024, 8, 10), moisture: 0.35, temperatureGradient: 0.04),
    SoilData(
        date: DateTime(2024, 8, 11), moisture: 0.3, temperatureGradient: 0.035),
    SoilData(
        date: DateTime(2024, 8, 12),
        moisture: 0.45,
        temperatureGradient: 0.055),
    SoilData(
        date: DateTime(2024, 8, 13),
        moisture: 0.55,
        temperatureGradient: 0.025),
    SoilData(
        date: DateTime(2024, 8, 14), moisture: 0.60, temperatureGradient: 0.02),
  ];

  @override
  void initState() {
    super.initState();
    soilDataList.add(widget.soilData);
  }

  @override
  Widget build(BuildContext context) {
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
                final date = soilDataList[value.toInt()].date;
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
            spots: soilDataList
                .asMap()
                .map((index, value) =>
                    MapEntry(index, FlSpot(index.toDouble(), value.moisture)))
                .values
                .toList(),
            isCurved: true,
            color: const Color.fromARGB(255, 232, 138, 6),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 190, 135, 47).withOpacity(0.5),
                  const Color.fromARGB(255, 190, 135, 47).withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: soilDataList
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot(index.toDouble(), value.temperatureGradient)))
                .values
                .toList(),
            isCurved: true,
            color: const Color.fromARGB(255, 230, 90, 35),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 243, 166, 33).withOpacity(0.5),
                  const Color.fromARGB(255, 243, 166, 33).withOpacity(0.0),
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

class VegetationGraph extends StatefulWidget {
  final VegetationData vegetationData;
  VegetationGraph({super.key, required this.vegetationData});
  _VegetationGraphState createState() => _VegetationGraphState();
}

class _VegetationGraphState extends State<VegetationGraph> {
  var vegetationDataList = [
    VegetationData(
        date: DateTime(2024, 8, 10), growthRate: 0.5, healthIndex: 79),
    VegetationData(
        date: DateTime(2024, 8, 11), growthRate: 0.8, healthIndex: 81),
    VegetationData(
        date: DateTime(2024, 8, 12), growthRate: 0.55, healthIndex: 82),
    VegetationData(
        date: DateTime(2024, 8, 13), growthRate: 0.45, healthIndex: 80),
    VegetationData(
        date: DateTime(2024, 8, 14), growthRate: 0.25, healthIndex: 78),
    VegetationData(
        date: DateTime(2024, 8, 15), growthRate: 0.55, healthIndex: 80),
    // Add more data here
  ];
  @override
  void initState() {
    super.initState();
    vegetationDataList.add(widget.vegetationData);
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final date = vegetationDataList[value.toInt()].date;
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
            spots: vegetationDataList
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
            color: const Color.fromARGB(255, 8, 114, 12),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: vegetationDataList
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot(index.toDouble(), value.healthIndex)))
                .values
                .toList(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 53, 243, 24).withOpacity(0.5),
                  const Color.fromARGB(255, 53, 243, 24).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            isCurved: true,
            color: const Color.fromARGB(255, 0, 207, 21),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

class WeatherGraph extends StatefulWidget {
  final List<WeatherData> weatherData;
  WeatherGraph({super.key, required this.weatherData});
  _WeatherGraphState createState() => _WeatherGraphState();
}

class _WeatherGraphState extends State<WeatherGraph> {
  var weatherDataList = [];
  @override
  void initState() {
    super.initState();
    weatherDataList = widget.weatherData;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final date = weatherDataList[value.toInt()].date;
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
            spots: weatherDataList
                .asMap()
                .map((index, value) => MapEntry(index,
                    FlSpot(index.toDouble(), value.temperature.toDouble())))
                .values
                .toList(),
            isCurved: true,
            color: const Color.fromARGB(255, 31, 179, 242),
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 18, 181, 181).withOpacity(0.5),
                  const Color.fromARGB(255, 18, 181, 181).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            spots: weatherDataList
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