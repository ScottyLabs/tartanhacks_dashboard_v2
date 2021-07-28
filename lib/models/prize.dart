class Prize{
  final String id;
  final String name;
  final String description;

  Prize({this.id, this.name, this.description});

  factory Prize.fromJson(Map<String, dynamic> parsedJson) {
    Prize newPrize = new Prize(
      id: parsedJson['_id'],
      name: parsedJson['name'],
      description: parsedJson['description']
    );
    return newPrize;
  }
}