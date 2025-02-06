class ExpoConfig {
  final int expoStartTime;
  final int submissionDeadline;

  ExpoConfig({
    required this.expoStartTime,
    required this.submissionDeadline,
  });

  factory ExpoConfig.fromJson(Map<String, dynamic> json) {
    return ExpoConfig(
        expoStartTime: json['expoStartTime'],
        submissionDeadline: json['submissionDeadline']);
  }
}
