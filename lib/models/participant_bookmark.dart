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
      //participantData = ParticipantBm.fromJson(parsedJson['participant']),
    );
  }
}

// class ParticipantBm jaklfsjklaf
// id
//     ParticipantBookmark.ParticipantBm.id -> gives id