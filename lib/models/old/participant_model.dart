import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Participant {
  final bool is_on_mobile;
  final bool is_admin;
  final int total_points;
  final String id;
  final String name;
  final String email;
  final String reg_system_id;
  final String team_id;
  final String dp_url;
  final bool is_active;
  final String github_profile_url;
  final String resume_url;
  final String account_creation_time;
  final int v;
  final String last_login_time;

  Participant({
        required this.is_on_mobile,
        required this.is_admin,
        required this.total_points,
        required this.id,
        required this.name,
        required this.email,
        required this.reg_system_id,
        required this.team_id,
        required this.dp_url,
        required this.is_active,
        required this.github_profile_url,
        required this.resume_url,
        required this.account_creation_time,
        required this.v,
        required this.last_login_time
  });

  factory Participant.fromJson(Map<String, dynamic> parsedJson) {
    return new Participant(
      is_on_mobile: parsedJson['is_on_mobile'],
      is_admin: parsedJson['is_admin'],
      id: parsedJson['_id'],
      name: parsedJson['name'],
      email: parsedJson['email'],
      reg_system_id: parsedJson['reg_system_id'],
      team_id: parsedJson['team_id'],
      dp_url: parsedJson['dp_url'],
      is_active: parsedJson['access_code'],
      github_profile_url: parsedJson['github_profile_url'],
      resume_url: parsedJson['resume_url'],
      account_creation_time: parsedJson['account_creation_time'],
      v: parsedJson['__v'],
      last_login_time: parsedJson['last_login_time'],
    );
  }
}