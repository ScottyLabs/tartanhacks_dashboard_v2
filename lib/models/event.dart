import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Event {
  final String id;
  final String platform;
  final bool active;
  final String name;
  final String description;
  //time is unix
  final int startTime;
  final int endTime;
  final String location;
  final int lat;
  final int lng;
  final String platformUrl;

  Event({
    this.id,
    this.platform,
    this.active,
    this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.lat,
    this.lng,
    this.platformUrl
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return new Event(
      id: parsedJson['_id'],
      platform: parsedJson['platform'],
      active: true,
      name: parsedJson['name'],
      description: parsedJson['description'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      location: parsedJson['location'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      platformUrl: parsedJson['platformUrl'],
    );
  }
}
