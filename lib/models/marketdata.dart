class MarketData {
  final int sNo;
  final String city;
  final String commodity;
  final String minPrice;
  final String maxPrice;
  final String modelPrice;
  final String date;

  MarketData({
    required this.sNo,
    required this.city,
    required this.commodity,
    required this.minPrice,
    required this.maxPrice,
    required this.modelPrice,
    required this.date,
  });

  // Factory method to create a CommodityData instance from JSON
  factory MarketData.fromJson(Map<String, dynamic> json) {
    // Helper function to clean up the strings
    String cleanString(String str) {
      return str.replaceAll('_', '').trim();
    }

    return MarketData(
      sNo: json['S.No'],
      city: cleanString(json['City'] as String),
      commodity: cleanString(json['Commodity'] as String),
      minPrice: cleanString(json['Min Prize'] as String),
      maxPrice: cleanString(json['Max Prize'] as String),
      modelPrice: cleanString(json['Model Prize'] as String),
      date: cleanString(json['Date'] as String),
    );
  }

  // Method to convert CommodityData to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'S.No': sNo,
      'City': city,
      'Commodity': commodity,
      'Min Prize': minPrice,
      'Max Prize': maxPrice,
      'Model Prize': modelPrice,
      'Date': date,
    };
  }
}
