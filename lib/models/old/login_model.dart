import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'participant_model.dart';

class Login {
  final Participant user;
  final String access_token;

  Login({this.user, this.access_token});

  factory Login.fromJson(Map<String, dynamic> parsedJson) {
    return new Login(
      user: Participant.fromJson(parsedJson['participant']),
      access_token: parsedJson['access_token'],
    );
  }
}