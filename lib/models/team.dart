import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import '/models/member.dart';

class Team {
  final String teamID;
  final bool visible;
  final Member admin;
  final String name;
  final List<Member> members;
  final String description;
  

  Team({
    this.teamID, 
    this.visible, 
    this.admin, 
    this.name, 
    this.members, 
    this.description});

  factory Team.fromJson(String parseString) {
    var parsedJson = jsonDecode(parseString);
    String adminID = parsedJson["admin"]["_id"];
    Member currAdmin;
    List<Member> memberList = [];
    List<String> memberStrings = List.from(parsedJson["members"]);
    for(int i = 0; i < memberStrings.length; i++){
      Member newMem = Member.fromJson(memberStrings[i], adminID);
      if(newMem.isAdmin) currAdmin = newMem;
      memberList.add(newMem);
    }
    return new Team(
        teamID:  parsedJson["_id"],
        visible: parsedJson["visible"],
        admin: currAdmin,
        name: parsedJson["name"],
        members: memberList,
        description: parsedJson["description"]
    );
  }
}
