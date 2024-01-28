class LBEntry {
  final int totalPoints;
  final String displayName;
  final int rank;

  LBEntry({
    required this.totalPoints, 
    required this.displayName, 
    required this.rank
  });

  factory LBEntry.fromJson(Map<String, dynamic> parsedJson) {
    return LBEntry(
      totalPoints: parsedJson['totalPoints'] ?? 0,
      displayName: parsedJson['displayName'] ?? 'Unknown User',
      rank: parsedJson['rank']
    );
  }
}