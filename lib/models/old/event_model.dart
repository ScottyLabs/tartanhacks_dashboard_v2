import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Event {
  final bool zoom_access_enabled;
  final bool is_in_person;
  final String id;
  final String name;
  final String description;
  final String timestamp;
  final String gcal_event_url;
  final String zoom_link;
  final int access_code;
  final String zoom_id;
  final String zoom_password;
  final String created_at;
  final int v;
  final int duration;


  Event({
    required this.zoom_access_enabled,
    required this.is_in_person,
    required this.id,
    required this.name,
    required this.description,
    required this.timestamp,
    required this.gcal_event_url,
    required this.zoom_link,
    required this.access_code,
    required this.zoom_id,
    required this.zoom_password,
    required this.created_at,
    required this.v,
    required this.duration
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return new Event(
      zoom_access_enabled: parsedJson['zoom_access_enabled'],
      is_in_person: parsedJson['is_in_person'],
      id: parsedJson['_id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      timestamp: parsedJson['timestamp'],
      gcal_event_url: parsedJson['gcal_event_url'],
      zoom_link: parsedJson['zoom_link'],
      access_code: parsedJson['access_code'],
      zoom_id: parsedJson['zoom_id'],
      zoom_password: parsedJson['zoom_password'],
      created_at: parsedJson['created_at'],
      v: parsedJson['__v'],
      duration: parsedJson['duration'],
    );
  }
}
