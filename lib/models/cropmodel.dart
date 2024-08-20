class CropInfo {
  final String name;
  final Range surfaceTemperature;
  final Range temperatureDepth10cm;
  final Range soilMoisture;

  CropInfo({
    required this.name,
    required this.surfaceTemperature,
    required this.temperatureDepth10cm,
    required this.soilMoisture,
  });

  factory CropInfo.fromJson(Map<String, dynamic> json) {
    return CropInfo(
      name: json['name'],
      surfaceTemperature: Range.fromJson(json['surface_temperature']),
      temperatureDepth10cm: Range.fromJson(json['temperature_depth_10cm']),
      soilMoisture: Range.fromJson(json['soil_moisture']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surface_temperature': surfaceTemperature.toJson(),
      'temperature_depth_10cm': temperatureDepth10cm.toJson(),
      'soil_moisture': soilMoisture.toJson(),
    };
  }
}

class Range {
  final double min;
  final double max;

  Range({required this.min, required this.max});

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
