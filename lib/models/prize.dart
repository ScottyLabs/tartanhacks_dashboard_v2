class Prize{
  final String id;
  final String event; //objectid
  final String name;
  final String description;
  final String? eligibility;
  final String? provider; //objectid
  final String? winner; //objectid


  Prize({
    required this.id,
    required this.event,
    required this.name,
    required this.description,
    this.eligibility,
    this.provider,
    this.winner
  });

  factory Prize.fromJson(Map<String, dynamic> parsedJson) {
    Prize newPrize = Prize(

      id: parsedJson['_id'],
      event: parsedJson['event'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      eligibility: parsedJson['eligibility'],
      provider: null, //parsedJson['provider'],
      winner: null //parsedJson['winner']
    );
    return newPrize;
  }
}