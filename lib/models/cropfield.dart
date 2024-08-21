class CropField {
  CropField(
      {required this.fieldName,
      required this.fieldSize,
      required this.location,
      required this.Crop,
      required this.latitude,
      required this.longitude,
      required this.sowedDate});

  final String fieldName;
  final double fieldSize;
  final String location;
  final String Crop;
  final double latitude;
  final double longitude;
  final DateTime sowedDate;
}
