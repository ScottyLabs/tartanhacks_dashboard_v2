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
  final List dietaryRestrictions;
  final String shirtSize;
  final bool wantsHardware;
  final String address;
  final String region;
  final String displayName;
  String profilePicture;

  Profile({
      required this.totalPoints,
      required this.user,
      required this.event,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.school,
      required this.college,
      required this.level,
      required this.graduationYear,
      required this.gender,
      required this.genderOther,
      required this.ethnicity,
      required this.ethnicityOther,
      required this.phoneNumber,
      required this.major,
      required this.coursework,
      required this.language,
      required this.hackathonExperience,
      required this.workPermission,
      required this.workLocation,
      required this.workStrengths,
      required this.sponsorRanking,
      required this.github,
      required this.resume,
      required this.design,
      required this.website,
      required this.essays,
      required this.dietaryRestrictions,
      required this.shirtSize,
      required this.wantsHardware,
      required this.address,
      required this.region,
      required this.displayName,
      required this.profilePicture
  });

  factory Profile.fromJson(Map<String, dynamic> parsedJson) {
    return Profile(
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
        profilePicture: parsedJson['profilePicture']
    );
  }
}