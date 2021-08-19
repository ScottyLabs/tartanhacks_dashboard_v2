class User {
  final bool admin;
  final String id;
  final String email;

  User({this.admin, this.id, this.email});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      admin: parsedJson['admin'],
      id: parsedJson['_id'],
      email: parsedJson['email']
    );
  }
}