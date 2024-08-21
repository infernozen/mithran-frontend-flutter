class Insight {
  final String condition;
  final double minSoilMoisture;
  final double maxSoilMoisture;
  final double minTemperatureGradient;
  final double maxTemperatureGradient;
  final String insight;

  Insight({
    required this.condition,
    required this.minSoilMoisture,
    required this.maxSoilMoisture,
    required this.minTemperatureGradient,
    required this.maxTemperatureGradient,
    required this.insight,
  });

  bool matches(double soilMoisture, double temperatureGradient) {
    return soilMoisture >= minSoilMoisture &&
        soilMoisture <= maxSoilMoisture &&
        temperatureGradient >= minTemperatureGradient &&
        temperatureGradient <= maxTemperatureGradient;
  }
}