class Address {
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String zipcode;

  Address({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.zipcode,
  });

  Map<String, dynamic> get toJson => {
        "city": city,
        "line1": line1,
        "line2": line2 ?? "",
        "state": state,
        "zipcode": zipcode,
      };

  factory Address.fromJson(dynamic jsonData) {
    return Address(
      line1: jsonData["line1"] ?? "",
      line2: jsonData["line2"] ?? "",
      city: jsonData["city"] ?? "",
      state: jsonData["state"] ?? "",
      zipcode: jsonData["zipcode"] ?? "",
    );
  }
}
