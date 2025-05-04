class KuralQuery {
  KuralQuery({
    required this.document,
  });

  KuralQueryDocument document;

  factory KuralQuery.fromJson(Map<String, dynamic> parsedJson) {
    return KuralQuery(
      document: KuralQueryDocument.fromJson(parsedJson["document"]),
    );
  }
}

class KuralQueryDocument {
  KuralQueryDocument({
    required this.number,
    required this.fields,
  });

  String number;
  KuralQueryFields fields;

  factory KuralQueryDocument.fromJson(Map<String, dynamic> parsedJson) {
    return KuralQueryDocument(
      number: parsedJson["number"],
      fields: KuralQueryFields.fromJson(parsedJson["fields"]),
    );
  }
}

class KuralQueryFields {
  KuralQueryFields({
    required this.lineOne,
    required this.lineTwo,
  });

  Strings lineOne;
  Strings lineTwo;

  factory KuralQueryFields.fromJson(Map<String, dynamic> parsedJson) {
    return KuralQueryFields(
      lineOne: Strings.fromJson(parsedJson["lineOne"]),
      lineTwo: Strings.fromJson(parsedJson["lineTwo"]),
    );
  }
}

class Strings {
  Strings({
    required this.stringValue,
  });

  String stringValue;

  factory Strings.fromJson(Map<String, dynamic> parsedJson) {
    return Strings(
      stringValue: parsedJson["stringValue"],
    );
  }
}
