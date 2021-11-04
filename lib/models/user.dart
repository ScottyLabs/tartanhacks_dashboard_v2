class User {
  final bool admin;
  final String id;
  final String email;
  final String token;
  final String company;

  User({this.admin, this.id, this.email, this.token, this.company});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      admin: parsedJson['admin'],
      id: parsedJson['_id'],
      email: parsedJson['email'],
      token: parsedJson['token'],
      company: parsedJson['company']
    );
  }
}