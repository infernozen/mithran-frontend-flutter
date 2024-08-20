class TrendData {
  final String date;
  final double mithranScore;
  final String message;

  TrendData({
    required this.date,
    required this.mithranScore,
    required this.message,
  });

  // Factory method to create a TrendData object from a JSON map
  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      date: json['date'],
      mithranScore: json['mithranScore'].toDouble(),
      message: json['message'],
    );
  }

  // Method to convert a TrendData object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'mithranScore': mithranScore,
      'message': message,
    };
  }
}