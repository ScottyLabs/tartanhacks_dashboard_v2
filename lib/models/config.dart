class ExpoConfig {
  final DateTime expoStartTime;
  final DateTime submissionDeadline;

  ExpoConfig({
    required this.expoStartTime,
    required this.submissionDeadline,
  });

  factory ExpoConfig.fromJson(Map<String, dynamic> json) {
    return ExpoConfig(
      expoStartTime: DateTime.parse(json['expoStartTime']),
      submissionDeadline: DateTime.parse(json['submissionDeadline']),
    );
  }
} 