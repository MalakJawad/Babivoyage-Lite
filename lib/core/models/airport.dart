class Airport {
  final String code;
  final String city;
  final String name;

  const Airport({required this.code, required this.city, required this.name});

  factory Airport.fromJson(Map<String, dynamic> j) => Airport(
        code: j['code'].toString(),
        city: j['city'].toString(),
        name: j['name'].toString(),
      );

  String get label => '$city ($code)';
}