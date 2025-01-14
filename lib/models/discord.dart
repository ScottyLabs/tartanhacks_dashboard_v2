class DiscordInfo {
  final String code;
  final String expiry;
  final String link;


  DiscordInfo({
    required this.code,
    required this.expiry,
    required this.link
  });

  factory DiscordInfo.fromJson(Map<String, dynamic> parsedJson) {

    return DiscordInfo(
        code:  parsedJson["code"],
        expiry: parsedJson["expiry"],
        link: parsedJson["link"],
    );
  }
}
