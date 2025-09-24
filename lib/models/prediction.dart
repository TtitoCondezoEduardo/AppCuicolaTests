class Prediction {
  final String description;
  final String placeId;

  Prediction({
    required this.description,
    required this.placeId,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
    );
  }
}
