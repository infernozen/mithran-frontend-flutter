Map<String, int> cropHarvestDays = {
  "Wheat": 120, // Average of 110 to 130 days
  "Sugarcane": 540, // Approx 18 months (540 days)
  "Rice": 123, // Average of 110 to 136 days
  "Soyabean": 110, // Average of 100 to 120 days
  "Mustard": 35, // Average of 30 to 40 days
  "Apple": 240, // Approximation for late summer/early fall (8 months)
  "Banana": 300, // Approximation, varies by variety (10 months)
  "Beans": 55, // Average of 50 to 60 days
  "Carrot": 70, // Average of 60 to 80 days
  "Coffee": 365, // Approximation for 1 year
  "Maize": 85, // Average of 70 to 100 days
  "Cotton": 150, // Average of 140 to 160 days
  "Tea": 180, // Approximation, continuous harvest (6 months for a flush)
  "Onion": 110, // Average of 100 to 120 days
  "Potato": 110, // Approximation, ready when foliage dies back (110 days)
  "Tomato": 70, // Approximation for ripeness (varies by variety)
};

String getCropStage(int daysSinceSowing, int harvestDays) {
  if (daysSinceSowing < harvestDays * 0.2) return "Germination";
  if (daysSinceSowing < harvestDays * 0.4) return "Vegetative";
  if (daysSinceSowing < harvestDays * 0.7) return "Flowering";
  if (daysSinceSowing < harvestDays) return "Fruiting";
  return "Harvest Ready";
}

CropStage getCurrentStage(String crop, DateTime sowingDate) {
  final DateTime now = DateTime.now();
  final int harvestDays = cropHarvestDays[crop] ?? 100; // Default to 100 days
  final int daysSinceSowing = now.difference(sowingDate).inDays;

  String currentStage = getCropStage(daysSinceSowing, harvestDays);

  DateTime expectedHarvest = sowingDate.add(Duration(days: harvestDays));

  return CropStage(currentStage, expectedHarvest);
}

class CropStage {
  final String stage;
  final DateTime expectedHarvest;

  CropStage(this.stage, this.expectedHarvest);
}