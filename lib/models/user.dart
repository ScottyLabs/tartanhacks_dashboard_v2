class User {
  final bool admin;
  final bool judge;
  final String id;
  final String email;
  final String token;
  final String company;
  final String status;

  User({
    required this.admin, 
    required this.judge, 
    required this.id, 
    required this.email, 
    required this.token, 
    required this.company,
    required this.status
  });

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