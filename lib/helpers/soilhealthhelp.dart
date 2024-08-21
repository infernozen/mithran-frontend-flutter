import 'package:mithran/models/insightmodel.dart';
import 'dart:math';

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

class InsightProvider {
  final List<Insight> insightsList;

  InsightProvider({required this.insightsList});

  Map<String, String> findInsight(
      double soilMoisture, double temperatureGradient) {
    for (var insight in insightsList) {
      if (insight.matches(soilMoisture, temperatureGradient)) {
        return {"Condition": insight.condition, "Insight": insight.insight};
      }
    }
    return {
      "Condition": "Alert",
      "Insight":
          "We have detected fluctuating soil health. This could be due to several factors, including irregular watering, extreme weather conditions, or nutrient imbalances in the soil. Consider adjusting your irrigation schedule, checking for signs of pest infestations, or conducting a soil test to identify any nutrient deficiencies. For personalized guidance, consult an agricultural expert or contact our customer support for further assistance."
    };
  }
}

double calculateTemperatureGradient(double t0, double t10) {
  // Calculate the absolute difference between t0 and t10
  double absoluteDifference = (t0 - t10).abs();

  // Calculate the normalized gradient
  double normalizedGradient = absoluteDifference / t0;

  // Clamp the result between 0 and 1
  return normalizedGradient.clamp(0.0, 1.0);
}

String getMithranScoreCondition(mithranScore) {
  if (mithranScore < 0 || mithranScore > 1) {
    return "Invalid score. Please provide a score between 0 and 1.";
  }

  if (mithranScore >= 0.9) {
    return "Optimal Crop Growth";
  } else if (mithranScore >= 0.8) {
    return "Very Healthy Crop";
  } else if (mithranScore >= 0.7) {
    return "Good Crop Condition";
  } else if (mithranScore >= 0.6) {
    return "Stable Crop Status";
  } else if (mithranScore >= 0.5) {
    return "Moderate Crop Health";
  } else if (mithranScore >= 0.4) {
    return "Crop Needs Attention";
  } else if (mithranScore >= 0.3) {
    return "Poor Crop Health";
  } else if (mithranScore >= 0.2) {
    return "High Crop Risk";
  } else if (mithranScore >= 0.1) {
    return "Severe Crop Stress";
  } else {
    return "Critical Crop Condition";
  }
}

Map<String, String> generateCropHealthInsight(Map<String, dynamic> dayData) {
  // Extract necessary attributes
  double dayTemp = dayData['dayTemp'];
  int humidity = dayData['humidity'];
  double rain = dayData['rain'] ?? 2.24;
  int pressure = dayData['pressure'];

  // Initialize random number generator
  Random random = Random();

  // Randomly select one of the insight classes
  int classChoice =
      random.nextInt(4); // 0 = Temp, 1 = Rain, 2 = Humidity, 3 = Pressure

  switch (classChoice) {
    case 0: // Temperature insights
      if (dayTemp < 15.0) {
        return {
          "Condition": "Very Cool",
          "Insight":
              "The unusually cool temperatures today may stress warm-season crops. It is important to protect sensitive plants from potential frost by using covers or providing additional warmth. Consider checking for signs of cold damage and adjust watering practices to account for reduced evaporation rates."
        };
      } else if (dayTemp >= 15.0 && dayTemp < 20.0) {
        return {
          "Condition": "Cool",
          "Insight":
              "Cool temperatures may slow down growth in some crops, especially those that thrive in warmer conditions. Monitor crops for signs of slow growth or stress. If possible, use row covers to retain some warmth and ensure that crops receive adequate nutrients to support growth during this period."
        };
      } else if (dayTemp >= 20.0 && dayTemp < 25.0) {
        return {
          "Condition": "Mild",
          "Insight":
              "Mild temperatures are generally favorable for crop growth. Continue regular care and maintenance. Ensure crops are well-watered but avoid overwatering. This is an ideal time to check for pests and diseases, as mild weather can sometimes promote their growth."
        };
      } else if (dayTemp >= 25.0 && dayTemp < 30.0) {
        return {
          "Condition": "Warm",
          "Insight":
              "Warm temperatures are good for most crops, but be cautious of heat stress, especially during the peak hours of the day. Provide adequate water and consider shading sensitive plants to prevent overheating. Regularly check for signs of heat stress, such as wilting or sunburn."
        };
      } else if (dayTemp >= 30.0) {
        return {
          "Condition": "Hot",
          "Insight":
              "The high temperatures can lead to significant heat stress in crops. Ensure that irrigation systems are functioning properly to provide consistent moisture. Use mulching to retain soil moisture and reduce soil temperature. Look out for signs of heat stress, such as leaf curling or sunburn, and take action to mitigate these effects."
        };
      }
      break;

    case 1: // Rain insights
      if (rain > 20.0) {
        return {
          "Condition": "Heavy Rain",
          "Insight":
              "Heavy rain can lead to waterlogging, which may damage crops' roots and promote fungal diseases. Ensure proper drainage to avoid water accumulation around plant roots. Consider applying fungicides if necessary and avoid walking on wet soil to prevent soil compaction."
        };
      } else if (rain > 10.0) {
        return {
          "Condition": "Moderate Rain",
          "Insight":
              "Moderate rain can be beneficial, but ensure that drainage is adequate to prevent waterlogging. Monitor soil moisture levels and adjust irrigation as needed. Keep an eye out for any signs of water-related diseases or pests and take preventive measures."
        };
      } else if (rain > 0.0) {
        return {
          "Condition": "Light Rain",
          "Insight":
              "Light rain can help maintain soil moisture levels. Ensure that your irrigation system is adjusted to account for this additional moisture. This is generally beneficial for crops, but continue monitoring soil moisture to avoid overwatering."
        };
      } else {
        return {
          "Condition": "No Rain",
          "Insight":
              "The absence of rain may require you to increase irrigation to maintain soil moisture. Check soil moisture levels regularly and adjust your watering schedule accordingly. Monitor crops for signs of drought stress, such as wilting or reduced growth."
        };
      }

    case 2: // Humidity insights
      if (humidity > 90) {
        return {
          "Condition": "Extremely High Humidity",
          "Insight":
              "Extremely high humidity can promote fungal growth and increase the risk of plant diseases. Ensure good air circulation around plants and consider using fungicides if necessary. Regularly inspect plants for any signs of disease and adjust watering practices to prevent excess moisture around the plants."
        };
      } else if (humidity > 80) {
        return {
          "Condition": "High Humidity",
          "Insight":
              "High humidity levels can increase the risk of fungal infections and reduce the effectiveness of pesticides. Ensure proper ventilation and spacing between plants. Monitor for signs of disease and consider applying preventive treatments to protect crops."
        };
      } else if (humidity > 60) {
        return {
          "Condition": "Moderate Humidity",
          "Insight":
              "Moderate humidity is generally manageable for most crops. Continue regular crop care and monitoring to ensure that plants remain healthy and productive. Ensure that plants have adequate airflow to reduce the risk of fungal growth and maintain optimal growth conditions."
        };
      } else if (humidity > 40) {
        return {
          "Condition": "Low Humidity",
          "Insight":
              "Low humidity can lead to increased water loss from plants and potential stress. Ensure regular watering and consider using mulching to retain soil moisture. Monitor plants for signs of dehydration or stress, and take steps to mitigate these effects."
        };
      } else {
        return {
          "Condition": "Very Low Humidity",
          "Insight":
              "Very low humidity can significantly affect plant health by causing excessive water loss. Increase irrigation frequency and consider using humidifiers or misting systems to help maintain adequate moisture levels around plants. Regularly check plants for signs of stress and adjust care accordingly."
        };
      }

    case 3: // Pressure insights
      if (pressure < 1000) {
        return {
          "Condition": "Low Pressure",
          "Insight":
              "Low atmospheric pressure can be associated with unstable weather, which may lead to sudden changes that could affect crop health. Stay alert for weather changes and ensure that plants are well-protected from potential storms or adverse conditions."
        };
      } else if (pressure >= 1000 && pressure < 1010) {
        return {
          "Condition": "Slightly Low Pressure",
          "Insight":
              "Slightly lower atmospheric pressure may indicate some potential for weather changes. Keep an eye on the forecast and ensure that crops are prepared for possible shifts in weather. Regularly check for any signs of stress or damage in plants."
        };
      } else if (pressure >= 1010 && pressure < 1020) {
        return {
          "Condition": "Normal Pressure",
          "Insight":
              "Normal atmospheric pressure typically indicates stable weather conditions. This should provide a consistent environment for crops. Continue regular care and monitoring to ensure that plants remain healthy and productive."
        };
      } else if (pressure >= 1020) {
        return {
          "Condition": "High Pressure",
          "Insight":
              "High atmospheric pressure generally suggests stable and clear weather. This is favorable for crops, as it reduces the risk of sudden weather changes. Maintain regular crop care practices and take advantage of the stable conditions to optimize crop growth."
        };
      }
      break;
  }

  // Default case when no specific insight is available
  return {
    "Condition": "Unstable Weather",
    "Insight":
        "Current weather conditions are unpredictable. It is advisable to avoid farming activities and consult with customer care or get help from Uzhavan, our personalized chatbot, for further guidance to ensure the safety and health of your crops."
  };
}
