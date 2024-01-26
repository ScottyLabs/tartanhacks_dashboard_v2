class LBEntry {
  final String user;
  final int totalPoints;
  final String displayName;
  final int rank;

  LBEntry({
    required this.user, 
    required this.totalPoints, 
    required this.displayName, 
    required this.rank
  });

  factory LBEntry.fromJson(Map<String, dynamic> parsedJson) {
    return LBEntry(
      user: parsedJson['user'],
      totalPoints: parsedJson['totalPoints'] ?? 0,
      displayName: parsedJson['displayName'],
      rank: parsedJson['rank']
    );
  }
}