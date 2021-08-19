class Prize{
  final String event; //objectid
  final String name;
  final String description;
  final String eligibility;
  final String provider; //objectid
  final String winner; //objectid


  Prize(
      {this.event,
      this.name,
      this.description,
      this.eligibility,
      this.provider,
      this.winner});

  factory Prize.fromJson(Map<String, dynamic> parsedJson) {
    Prize newPrize = new Prize(
      event: parsedJson['event'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      eligibility: parsedJson['eligibility'],
      provider: parsedJson['provider'],
      winner: parsedJson['winner']
    );
    return newPrize;
  }
}