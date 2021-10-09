class User {
  final bool admin;
  final String id;
  final String email;
  final String token;

  User({this.admin, this.id, this.email, this.token});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      admin: parsedJson['admin'],
      id: parsedJson['_id'],
      email: parsedJson['email'],
      token: parsedJson['token']
    );
  }
}