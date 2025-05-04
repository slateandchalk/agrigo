class Countries {
  Countries({
    required this.name,
    required this.dialCode,
    required this.code,
    required this.flag,
  });

  final String name;
  final String dialCode;
  final String code;
  final String flag;

  factory Countries.fromJson(Map<String, dynamic> json) {
    return Countries(
      name: json["name"],
      dialCode: json["dial_code"],
      code: json["code"],
      flag: json["flag"],
    );
  }
}
