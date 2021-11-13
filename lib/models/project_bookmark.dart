class ProjectBookmark {
  final String bookmarkId;
  final String bookmarkType;

  final String projectData;

  final String description;
  final String createdAt;

  ProjectBookmark({
    this.bookmarkId,
    this.bookmarkType,

    this.projectData, // json data format

    this.description,
    this.createdAt,
  });

  factory ProjectBookmark.fromJson(Map<String, dynamic> parsedJson) {
    return new ProjectBookmark(
      bookmarkId: parsedJson['_id'],
      bookmarkType: parsedJson['bookmarkType'],
      description: parsedJson['description'],
      createdAt: parsedJson['createdAt'],
      projectData: parsedJson['project'],
    );
  }
}