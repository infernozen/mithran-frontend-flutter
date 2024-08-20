class CropStagesBag {
  const CropStagesBag(this.stage, this.items); // Corrected the order of parameters
  final String stage;
  final List<CropStagesItemsBag> items;
}

class CropStagesItemsBag {
  const CropStagesItemsBag(this.item, this.quantity, this.type);
  final String item;
  final String quantity;
  final String type;
}
