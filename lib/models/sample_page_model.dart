class Samples {
  List<Documents> documents;
  Samples({required this.documents});

  factory Samples.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['documents'] as List;
    List<Documents> documents = list.map((i) => Documents.fromJson(i)).toList();

    return Samples(documents: documents);
  }
}

class Documents {
  String name;
  Fields fields;
  Documents({required this.name, required this.fields});

  factory Documents.fromJson(Map<String, dynamic> parsedJson) {
    return Documents(
        name: parsedJson['name'],
        fields: Fields.fromJson(parsedJson['fields']));
  }
}

class Fields {
  // ignore: non_constant_identifier_names
  Farmer ASN;
  // ignore: non_constant_identifier_names
  Farmer AFN;

  // ignore: non_constant_identifier_names
  Fields({required this.ASN, required this.AFN});

  factory Fields.fromJson(Map<String, dynamic> parsedJson) {
    return Fields(
      ASN: Farmer.fromJson(parsedJson['ASN']),
      AFN: Farmer.fromJson(parsedJson['AFN']),
    );
  }
}

class Farmer {
  String stringValue;

  Farmer({required this.stringValue});

  factory Farmer.fromJson(Map<String, dynamic> parsedJson) {
    return Farmer(
      stringValue: parsedJson['stringValue'],
    );
  }
}
