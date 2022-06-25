class ParticipantBookmark {
  final String bookmarkId;
  final String bookmarkType;

  final String description;
  final String createdAt;
  final ParticipantInfo participantData;

  ParticipantBookmark({
    this.bookmarkId,
    this.bookmarkType,

    this.description,
    this.createdAt,
    this.participantData, // json data format
    // participantId, participantEmail, participantFirstName, participantLastName, participantResume

  });

  factory ParticipantBookmark.fromJson(Map<String, dynamic> parsedJson) {
    return ParticipantBookmark(
      bookmarkId: parsedJson['_id'],
      bookmarkType: parsedJson['bookmarkType'],
      description: parsedJson['description'],
      createdAt: parsedJson['createdAt'],

      participantData: ParticipantInfo.fromJson(parsedJson['participant']),
    );
  }
}


// ParticipantBookmark.participantData.id -> gives id

class ParticipantInfo {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  ParticipantInfo({this.id, this.email, this.firstName, this.lastName});

  factory ParticipantInfo.fromJson(Map<String, dynamic> parsedJson) {
    return ParticipantInfo(
      id: parsedJson['_id'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
    );
  }
}
