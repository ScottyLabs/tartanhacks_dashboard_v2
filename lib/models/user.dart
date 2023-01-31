class User {
  final bool admin;
  final bool judge;
  final String id;
  final String email;
  final String token;
  final String company;
  final String status;

  User({this.admin, this.judge, this.id, this.email, this.token, this.company,
      this.status});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      admin: parsedJson['admin'],
      judge: parsedJson['judge'],
      id: parsedJson['_id'],
      email: parsedJson['email'],
      token: parsedJson['token'],
      company: parsedJson['company'],
      status: parsedJson['status']
    );
  }
}