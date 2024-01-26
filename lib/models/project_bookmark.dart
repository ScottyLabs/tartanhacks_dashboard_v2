class ProjectBookmark {
  final String bookmarkId;
  final String bookmarkType;

  final String projectData;

  final String description;
  final String createdAt;

  ProjectBookmark({
    required this.bookmarkId,
    required this.bookmarkType,
    required this.projectData, // stringified JSON
    required this.description,
    required this.createdAt,
  });

  factory ProjectBookmark.fromJson(Map<String, dynamic> parsedJson) {
    return ProjectBookmark(
      bookmarkId: parsedJson['_id'],
      bookmarkType: parsedJson['bookmarkType'],
      description: parsedJson['description'],
      createdAt: parsedJson['createdAt'],
      projectData: parsedJson['project'],
    );
  }
}