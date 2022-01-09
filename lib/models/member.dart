import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Member {
  final String memberID;
  final bool isAdmin;
  final String name;
  final String email;


  Member({
    this.memberID,
    this.isAdmin,
    this.name,
    this.email,
    });

  factory Member.fromJson(Map<String, dynamic> parsedJson, String adminID) {
    bool isAdminBool = false;
    String currID = parsedJson["_id"];
    if(currID == adminID) isAdminBool = true;
    return new Member(
        memberID:  parsedJson["_id"],
        isAdmin: isAdminBool,
        name: parsedJson["firstName"] + " " + parsedJson["lastName"],
        email: parsedJson["email"]
    );
  }
}
