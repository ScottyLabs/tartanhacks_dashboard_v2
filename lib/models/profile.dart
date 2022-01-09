import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Profile {
  final int totalPoints;
  final String user;
  final String event; //objectid
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final String school;
  final String college;
  final String level;
  final int graduationYear;
  final String gender;
  final String genderOther;
  final String ethnicity;
  final String ethnicityOther;
  final String phoneNumber;
  final String major;
  final String coursework;
  final String language;
  final String hackathonExperience;
  final String workPermission;
  final String workLocation;
  final String workStrengths;
  final List sponsorRanking; //objectid
  final String github;
  final String resume;
  final String design;
  final String website;
  final List essays;
  final String dietaryRestrictions;
  final String shirtSize;
  final bool wantsHardware;
  final String address;
  final String region;
  final String displayName;


  Profile({
      this.totalPoints,
      this.user,
      this.event,
      this.email,
      this.firstName,
      this.lastName,
      this.age,
      this.school,
      this.college,
      this.level,
      this.graduationYear,
      this.gender,
      this.genderOther,
      this.ethnicity,
      this.ethnicityOther,
      this.phoneNumber,
      this.major,
      this.coursework,
      this.language,
      this.hackathonExperience,
      this.workPermission,
      this.workLocation,
      this.workStrengths,
      this.sponsorRanking,
      this.github,
      this.resume,
      this.design,
      this.website,
      this.essays,
      this.dietaryRestrictions,
      this.shirtSize,
      this.wantsHardware,
      this.address,
      this.region,
      this.displayName});

  factory Profile.fromJson(Map<String, dynamic> parsedJson) {
    return new Profile(
        totalPoints: parsedJson['totalPoints'],
        user: parsedJson['user'],
        event: parsedJson['event'],
        email: parsedJson['email'],
        firstName: parsedJson['firstName'],
        lastName: parsedJson['lastName'],
        age: parsedJson['age'],
        school: parsedJson['school'],
        college: parsedJson['college'],
        level: parsedJson['level'],
        graduationYear: parsedJson['graduationYear'],
        gender: parsedJson['gender'],
        genderOther: parsedJson['genderOther'],
        ethnicity: parsedJson['ethnicity'],
        ethnicityOther: parsedJson['ethnicityOther'],
        phoneNumber: parsedJson['phoneNumber'],
        major: parsedJson['major'],
        coursework: parsedJson['coursework'],
        language: parsedJson['language'],
        hackathonExperience: parsedJson['hackathonExperience'],
        workPermission: parsedJson['workPermission'],
        workLocation: parsedJson['workLocation'],
        workStrengths: parsedJson['workStrengths'],
        sponsorRanking: parsedJson['sponsorRanking'],
        github: parsedJson['github'],
        resume: parsedJson['resume'],
        design: parsedJson['design'],
        website: parsedJson['website'],
        essays: parsedJson['essays'],
        dietaryRestrictions: parsedJson['dietaryRestrictions'],
        shirtSize: parsedJson['shirtSize'],
        wantsHardware: parsedJson['wantsHardware'],
        address: parsedJson['address'],
        region: parsedJson['region'],
        displayName: parsedJson['displayName'],
    );
  }
}