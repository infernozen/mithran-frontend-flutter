class CropField {
  CropField(
      {required this.polygonId,
      required this.fieldName,
      required this.fieldSize,
      required this.location,
      required this.Crop,
      required this.latitude,
      required this.longitude,
      required this.polygonLatLngs,
      required this.sowedDate});

  final String polygonId;
  final String fieldName;
  final double fieldSize;
  final String location;
  final String Crop;
  final double latitude;
  final double longitude;
  final List<List<double>> polygonLatLngs;
  final DateTime sowedDate;
}
