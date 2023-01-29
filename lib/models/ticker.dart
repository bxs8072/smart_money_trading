class Ticker {
  final String title;
  final String descrription;
  final String image;

  Ticker(this.title, this.descrription, this.image);

  Map<String, dynamic> get toJson => {
        "title": title,
        "descrription": descrription,
        "image": image,
      };

  factory Ticker.fromJson(dynamic jsonData) {
    return Ticker(
      jsonData["title"],
      jsonData["descrription"],
      jsonData["image"],
    );
  }
}
