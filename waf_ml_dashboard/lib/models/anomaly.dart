class Anomaly {
  final String id;
  final bool isAnomaly;
  final String attackType;
  final double confidence;
  final String? recommendedRule;
  final String explainability;
  final String timestamp;
  final String path;

  Anomaly({
    required this.id,
    required this.isAnomaly,
    required this.attackType,
    required this.confidence,
    this.recommendedRule,
    required this.explainability,
    required this.timestamp,
    required this.path,
  });

  factory Anomaly.fromJson(Map<String, dynamic> json, String path) {
    return Anomaly(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isAnomaly: json['is_anomaly'] ?? false,
      attackType: json['attack_type'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      recommendedRule: json['recommended_rule'],
      explainability: json['explainability'] ?? '',
      timestamp: DateTime.now().toString().substring(11, 19),
      path: path,
    );
  }
}

class TrafficDataPoint {
  final String time;
  final double score;

  TrafficDataPoint({required this.time, required this.score});
}
