class Address {
  final String city;
  final String state;
  final int zipcode;

  Address(this.city, this.state, this.zipcode);

  Map<String, dynamic> get toJson => {
        "city": city,
        "state": state,
        "zipcode": zipcode,
      };

  factory Address.fromJson(dynamic jsonData) {
    return Address(
      jsonData["city"],
      jsonData["state"],
      jsonData["zipcode"],
    );
  }
}
