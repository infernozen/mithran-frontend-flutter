class LeafReading {
  final String date;
  final String time;
  final int greennessScore;

  LeafReading({
    required this.date,
    required this.time,
    required this.greennessScore,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'time': time,
        'greennessScore': greennessScore,
      };

  factory LeafReading.fromJson(Map<String, dynamic> json) {
    return LeafReading(
      date: json['date'],
      time: json['time'],
      greennessScore: json['greennessScore'],
    );
  }
}