class ParticipantBookmark {
  final String bookmarkId;
  final String bookmarkType;

  //final ParticipantBm participantData;

  final String description;
  final String createdAt;

  ParticipantBookmark({
    this.bookmarkId,
    this.bookmarkType,

    //this.participantData, // json data format
    // participantId, participantEmail, participantFirstName, participantLastName, participantResume

    this.description,
    this.createdAt,
  });

  factory ParticipantBookmark.fromJson(Map<String, dynamic> parsedJson) {
    return new ParticipantBookmark(
      bookmarkId: parsedJson['_id'],
      bookmarkType: parsedJson['bookmarkType'],
      description: parsedJson['description'],
      createdAt: parsedJson['createdAt'],
      //participantData = ParticipantInfo.fromJson(parsedJson['participant']),
    );
  }
}

// class ParticipantInfo
// ParticipantBookmark.participantData.id -> gives id

class ParticipantInfo {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  ParticipantInfo({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> parsedJson) {
    return new ParticipantInfo(
      id: parsedJson['_id'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
    );
  }
}