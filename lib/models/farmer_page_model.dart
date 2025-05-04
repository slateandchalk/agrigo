class Farmers {
  List<Documents> documents;

  Farmers({required this.documents});

  factory Farmers.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['documents'] as List;
    List<Documents> documents = list.map((i) => Documents.fromJson(i)).toList();

    return Farmers(documents: documents);
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
  Farmer firstName;
  Farmer lastName;

  Fields({required this.firstName, required this.lastName});

  factory Fields.fromJson(Map<String, dynamic> parsedJson) {
    return Fields(
      firstName: Farmer.fromJson(parsedJson['firstName']),
      lastName: Farmer.fromJson(parsedJson['lastName']),
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
