class SampleQuery {
  SampleQuery({
    required this.document,
  });

  SampleQueryDocument document;

  factory SampleQuery.fromJson(Map<String, dynamic> parsedJson) {
    return SampleQuery(
        document: SampleQueryDocument.fromJson(parsedJson['document']));
  }
}

class SampleQueryDocument {
  SampleQueryDocument({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  SampleQueryFields fields;
  String createTime;
  String updateTime;

  factory SampleQueryDocument.fromJson(Map<String, dynamic> parsedJson) {
    return SampleQueryDocument(
      name: parsedJson["name"],
      fields: SampleQueryFields.fromJson(parsedJson["fields"]),
      createTime: parsedJson["createTime"],
      updateTime: parsedJson["updateTime"],
    );
  }
}

class SampleQueryFields {
  SampleQueryFields(
      {required this.sampleNumber,
      required this.sampleCreatedAt,
      required this.farmerNumber,
      required this.sampleCreatedBy,
      required this.reportCreated});

  Strings sampleNumber;
  TimeStamps sampleCreatedAt;
  Strings sampleCreatedBy;
  Strings farmerNumber;
  Booleans reportCreated;

  factory SampleQueryFields.fromJson(Map<String, dynamic> parsedJson) {
    return SampleQueryFields(
      sampleNumber: Strings.fromJson(parsedJson["sampleNumber"]),
      sampleCreatedAt: TimeStamps.fromJson(parsedJson["sampleCreatedAt"]),
      farmerNumber: Strings.fromJson(parsedJson["farmerNumber"]),
      sampleCreatedBy: Strings.fromJson(parsedJson["sampleCreatedBy"]),
      reportCreated: Booleans.fromJson(parsedJson["reportCreated"]),
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

class TimeStamps {
  TimeStamps({
    required this.timestampValue,
  });

  String timestampValue;

  factory TimeStamps.fromJson(Map<String, dynamic> parsedJson) {
    return TimeStamps(
      timestampValue: parsedJson["timestampValue"],
    );
  }
}

class Booleans {
  Booleans({
    required this.booleanValue,
  });

  bool booleanValue;

  factory Booleans.fromJson(Map<String, dynamic> parsedJson) {
    return Booleans(
      booleanValue: parsedJson["booleanValue"],
    );
  }
}
