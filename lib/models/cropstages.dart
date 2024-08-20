class CropStages {
  const CropStages(this.stage, this.items); // Corrected the order of parameters
  final String stage;
  final List<CropStagesItems> items;
}

class CropStagesItems {
  const CropStagesItems(this.item, this.quantity, this.type);
  final String item;
  final String quantity;
  final String type;
}
