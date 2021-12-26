import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Team {
<<<<<<< Updated upstream
  String teamID;
  List<String> members;
  String name;
  String event;
  String desc;
  String admin;
  bool visible;

  Team({this.teamID, this.visible, this.event, this.admin, this.members, this.desc,
  this.name});
  factory Team.fromJson(String jsonString) {
    Map<String, dynamic> body = json.decode(jsonString);
    return new Team(
        teamID:  body["_id"],
        visible: body["visible"],
        event: body["event"],
        admin: body["admin"],
        members: body["members"],
        desc: body["description"],
        name: body["name"]
=======
  final String teamID;
  final bool visible;
  final dynamic admin;
  final String name;
  final List<dynamic> members;
  final String description;
  

  Team({
    this.teamID, 
    this.visible, 
    this.admin, 
    this.name, 
    this.members, 
    this.description});

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    return new Team(
        teamID:  parsedJson["_id"],
        visible: parsedJson["visible"],
        admin: parsedJson["admin"],
        name: parsedJson["name"],
        members: parsedJson["members"],
        description: parsedJson["description"]
>>>>>>> Stashed changes
    );
  }
}