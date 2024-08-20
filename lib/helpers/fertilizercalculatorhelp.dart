import 'dart:convert';

// Base nutrient requirements per acre (kg/acre) for each crop
Map<String, Map<String, double>> baseNutrientRequirements = {
  "Wheat": {"N": 60, "P": 30, "K": 30},
  "Sugarcane": {"N": 100, "P": 50, "K": 50},
  "Rice": {"N": 80, "P": 40, "K": 40},
  "Soybean": {"N": 50, "P": 12.5, "K": 25},
  "Mustard": {"N": 40, "P": 20, "K": 20},
  "Apple": {"N": 80, "P": 40, "K": 40},
  "Banana": {"N": 400, "P": 133, "K": 800},
  "Beans": {"N": 40, "P": 20, "K": 20},
  "Carrot": {"N": 40, "P": 80, "K": 80},
  "Coffee": {"N": 50, "P": 25, "K": 25},
  "Maize": {"N": 120, "P": 30, "K": 60},
  "Cotton": {"N": 80, "P": 40, "K": 80},
  "Tea": {"N": 100, "P": 50, "K": 50},
  "Onion": {"N": 40, "P": 80, "K": 80},
  "Potato": {"N": 100, "P": 50, "K": 50},
  "Tomato": {"N": 120, "P": 240, "K": 360},
};

// NPK content of various fertilizers (as a proportion)
Map<String, Map<String, double>> fertilizerNPKContent = {
  "Diammonium Phosphate": {"N": 0.18, "P": 0.46, "K": 0.0},
  "Muriate of Potash (MOP)": {"N": 0.0, "P": 0.0, "K": 0.60},
  "YaraLiva NITRABOR": {"N": 0.15, "P": 0.0, "K": 0.0},
  "Neem Coated UREA": {"N": 0.46, "P": 0.0, "K": 0.0},
  "YaraTera KRISTA K 13-0-45": {"N": 0.13, "P": 0.0, "K": 0.45},
};

Map<String, dynamic> generateFertilizerPlan(
    double acres, String crop, double targetYield) {
  if (!baseNutrientRequirements.containsKey(crop)) {
    throw Exception("Crop type not supported");
  }

  // Base nutrient requirements
  Map<String, double> baseRequirements = baseNutrientRequirements[crop]!;
  double totalN = baseRequirements["N"]! * acres;
  double totalP = baseRequirements["P"]! * acres;
  double totalK = baseRequirements["K"]! * acres;

  // Yield adjustment
  double yieldAdjustmentFactor =
      targetYield > 1000 ? 1.2 : 1.0; // Increase by 20% if target yield is high
  totalN *= yieldAdjustmentFactor;
  totalP *= yieldAdjustmentFactor;
  totalK *= yieldAdjustmentFactor;

  // Validate fertilizer NPK content
  double getFertilizerQuantity(String fertilizer, String nutrient) {
    if (fertilizerNPKContent.containsKey(fertilizer) &&
        fertilizerNPKContent[fertilizer]!.containsKey(nutrient)) {
      return totalN / fertilizerNPKContent[fertilizer]![nutrient]!;
    } else {
      throw Exception("Nutrient content not found for $fertilizer");
    }
  }

  // Prepare the fertilizer plan
  List<Map<String, dynamic>> stages = [
    {
      "stage": "Basal Stage (at sowing)",
      "items": [
        {
          "item": "Diammonium Phosphate",
          "quantity":
              "${getFertilizerQuantity("Diammonium Phosphate", "P").toStringAsFixed(2)} kgs",
          "type": "Solid"
        },
        {
          "item": "Muriate of Potash (MOP)",
          "quantity":
              "${getFertilizerQuantity("Muriate of Potash (MOP)", "K").toStringAsFixed(2)} kgs",
          "type": "Solid"
        }
      ]
    },
    {
      "stage": "Crown Root Initiation Stage (25-30 DAS)",
      "items": [
        {
          "item": "YaraLiva NITRABOR",
          "quantity":
              "${getFertilizerQuantity("YaraLiva NITRABOR", "N").toStringAsFixed(2)} kgs",
          "type": "Solid"
        },
        {
          "item": "Neem Coated UREA",
          "quantity":
              "${getFertilizerQuantity("Neem Coated UREA", "N").toStringAsFixed(2)} kgs",
          "type": "Solid"
        }
      ]
    },
    {
      "stage": "Mid Tillering Stage (40-45 DAS)",
      "items": [
        {
          "item": "Neem Coated UREA",
          "quantity":
              "${getFertilizerQuantity("Neem Coated UREA", "N").toStringAsFixed(2)} kgs",
          "type": "Solid"
        }
      ]
    },
    {
      "stage": "Late Tillering Stage (50-60 DAS)",
      "items": [
        {
          "item": "Neem Coated UREA",
          "quantity":
              "${getFertilizerQuantity("Neem Coated UREA", "N").toStringAsFixed(2)} kgs",
          "type": "Solid"
        },
        {
          "item": "YaraTera KRISTA K 13-0-45",
          "quantity":
              "${getFertilizerQuantity("YaraTera KRISTA K 13-0-45", "K").toStringAsFixed(2)} kgs",
          "type": "Solid"
        }
      ]
    }
  ];

  return {
    "crop": crop,
    "acres": acres,
    "targetYield": targetYield,
    "stages": stages
  };
}

// void main() {
//   double acres = 10.0; // Example input
//   String crop = "Banana"; // Example crop
//   double targetYield = 1000.0; // Example target yield in kg

//   try {
//     Map<String, dynamic> fertilizerPlan =
//         generateFertilizerPlan(acres, crop, targetYield);
//     String jsonPlan = jsonEncode(fertilizerPlan);
//     print(jsonPlan);
//   } catch (e) {
//     print("Error: ${e.toString()}");
//   }
// }