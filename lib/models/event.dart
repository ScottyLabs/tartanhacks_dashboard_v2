import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

enum EventType{
  ALL,
  SPONSORS_ONLY,
  PARTICIPANTS_ONLY,
  ADMINS_ONLY
}

class Event {

  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool enableCheckin;
  final bool enableProjects;
  final bool enableTeams;
  final bool enableSponsors;
  final String logoUrl;
  final List<String> essayQuestions;



  Event({this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.enableCheckin,
    this.enableProjects,
    this.enableTeams,
    this.enableSponsors,
    this.logoUrl,
    this.essayQuestions,
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return new Event(
      description: parsedJson['description'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      name: parsedJson['name'],
      enableCheckin: parsedJson['enableCheckin'],
      enableProjects: parsedJson['enableProjects'],
      enableTeams: parsedJson['enableTeams'],
      enableSponsors: parsedJson['enableSponsors'],
      logoUrl: parsedJson['logoUrl'],
      essayQuestions: parsedJson['essayQuestions'],
    );
  }
}
