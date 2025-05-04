class Reports {
  List<Documents> documents;

  Reports({required this.documents});

  factory Reports.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['documents'] as List;
    List<Documents> documents = list.map((i) => Documents.fromJson(i)).toList();

    return Reports(documents: documents);
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
  Fields({
    required this.reportCreatedAt,
    required this.sampleNumber,
    required this.reportNumber,
    required this.soilStandard,
    required this.soilTestResults,
    required this.cultivatingCrops,
    required this.fertilizerSuggestions,
    required this.macroNutrients,
    required this.microNutrients,
  });

  TimeStamps reportCreatedAt;
  Strings sampleNumber;
  Strings reportNumber;
  SoilStandard soilStandard;
  SoilTestResults soilTestResults;
  Strings cultivatingCrops;
  Strings fertilizerSuggestions;
  MacroNutrients macroNutrients;
  MicroNutrients microNutrients;

  factory Fields.fromJson(Map<String, dynamic> parsedJson) {
    return Fields(
      reportCreatedAt: TimeStamps.fromJson(parsedJson["reportCreatedAt"]),
      sampleNumber: Strings.fromJson(parsedJson["sampleNumber"]),
      reportNumber: Strings.fromJson(parsedJson["reportNumber"]),
      soilStandard: SoilStandard.fromJson(parsedJson["soilStandard"]),
      soilTestResults: SoilTestResults.fromJson(parsedJson["soilTestResults"]),
      cultivatingCrops: Strings.fromJson(parsedJson["cultivatingCrops"]),
      fertilizerSuggestions:
          Strings.fromJson(parsedJson["fertilizerSuggestions"]),
      macroNutrients: MacroNutrients.fromJson(parsedJson["macroNutrients"]),
      microNutrients: MicroNutrients.fromJson(parsedJson["microNutrients"]),
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

class Doubles {
  Doubles({
    required this.doubleValue,
  });

  double doubleValue;

  factory Doubles.fromJson(Map<String, dynamic> parsedJson) {
    return Doubles(
      doubleValue: parsedJson["doubleValue"],
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

  factory Booleans.fromJson(Map<String, dynamic> parsedJson) => Booleans(
        booleanValue: parsedJson["booleanValue"],
      );

  Map<String, dynamic> toJson() => {
        "booleanValue": booleanValue,
      };
}

class MacroNutrients {
  MacroNutrients({
    required this.mapValue,
  });

  MacroNutrientsMapValue mapValue;

  factory MacroNutrients.fromJson(Map<String, dynamic> parsedJson) {
    return MacroNutrients(
      mapValue: MacroNutrientsMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class MacroNutrientsMapValue {
  MacroNutrientsMapValue({
    required this.fields,
  });

  MnFields fields;

  factory MacroNutrientsMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return MacroNutrientsMapValue(
      fields: MnFields.fromJson(parsedJson["fields"]),
    );
  }
}

class MnFields {
  MnFields({
    required this.mn0,
    required this.mn1,
    required this.mn2,
  });

  Mn mn0;
  Mn mn1;
  Mn mn2;

  factory MnFields.fromJson(Map<String, dynamic> parsedJson) {
    return MnFields(
      mn0: Mn.fromJson(parsedJson["0"]),
      mn1: Mn.fromJson(parsedJson["1"]),
      mn2: Mn.fromJson(parsedJson["2"]),
    );
  }
}

class Mn {
  Mn({
    required this.mapValue,
  });

  MnMapValue mapValue;

  factory Mn.fromJson(Map<String, dynamic> parsedJson) {
    return Mn(
      mapValue: MnMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class MnMapValue {
  MnMapValue({
    required this.fields,
  });

  MnMapFields fields;

  factory MnMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return MnMapValue(
      fields: MnMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class MnMapFields {
  MnMapFields({
    required this.mnM0,
    required this.mnM1,
    required this.mnM2,
    required this.mnM3,
  });

  Doubles mnM0;
  Strings mnM1;
  Doubles mnM2;
  Doubles mnM3;

  factory MnMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return MnMapFields(
      mnM0: Doubles.fromJson(parsedJson["0"]),
      mnM1: Strings.fromJson(parsedJson["1"]),
      mnM2: Doubles.fromJson(parsedJson["2"]),
      mnM3: Doubles.fromJson(parsedJson["3"]),
    );
  }
}

class MicroNutrients {
  MicroNutrients({
    required this.mapValue,
  });

  MicroNutrientsMapValue mapValue;

  factory MicroNutrients.fromJson(Map<String, dynamic> parsedJson) {
    return MicroNutrients(
      mapValue: MicroNutrientsMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class MicroNutrientsMapValue {
  MicroNutrientsMapValue({
    required this.fields,
  });

  MiFields fields;

  factory MicroNutrientsMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return MicroNutrientsMapValue(
      fields: MiFields.fromJson(parsedJson["fields"]),
    );
  }
}

class MiFields {
  MiFields({
    required this.mi0,
    required this.mi1,
    required this.mi2,
    required this.mi3,
  });

  Mi mi0;
  Mi mi1;
  Mi mi2;
  Mi mi3;

  factory MiFields.fromJson(Map<String, dynamic> parsedJson) {
    return MiFields(
      mi0: Mi.fromJson(parsedJson["0"]),
      mi1: Mi.fromJson(parsedJson["1"]),
      mi2: Mi.fromJson(parsedJson["2"]),
      mi3: Mi.fromJson(parsedJson["3"]),
    );
  }
}

class Mi {
  Mi({
    required this.mapValue,
  });

  MiMapValue mapValue;

  factory Mi.fromJson(Map<String, dynamic> parsedJson) {
    return Mi(
      mapValue: MiMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class MiMapValue {
  MiMapValue({
    required this.fields,
  });

  MiMapFields fields;

  factory MiMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return MiMapValue(
      fields: MiMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class MiMapFields {
  MiMapFields({
    required this.miM0,
  });

  Strings miM0;

  factory MiMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return MiMapFields(
      miM0: Strings.fromJson(parsedJson["0"]),
    );
  }
}

class SoilStandard {
  SoilStandard({
    required this.mapValue,
  });

  SoilStandardMapValue mapValue;

  factory SoilStandard.fromJson(Map<String, dynamic> parsedJson) {
    return SoilStandard(
      mapValue: SoilStandardMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class SoilStandardMapValue {
  SoilStandardMapValue({
    required this.fields,
  });

  SsFields fields;

  factory SoilStandardMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return SoilStandardMapValue(
      fields: SsFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SsFields {
  SsFields({
    required this.ss0,
  });

  Ss ss0;

  factory SsFields.fromJson(Map<String, dynamic> parsedJson) {
    return SsFields(
      ss0: Ss.fromJson(parsedJson["0"]),
    );
  }
}

class Ss {
  Ss({
    required this.mapValue,
  });

  SsMapValue mapValue;

  factory Ss.fromJson(Map<String, dynamic> parsedJson) {
    return Ss(
      mapValue: SsMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class SsMapValue {
  SsMapValue({
    required this.fields,
  });

  SsMapFields fields;

  factory SsMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return SsMapValue(
      fields: SsMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SsMapFields {
  SsMapFields({
    required this.ssM0,
    required this.ssM1,
    required this.ssM2,
    required this.ssM3,
    required this.ssM4,
    required this.ssM5,
    required this.ssM6,
    required this.ssM7,
    required this.ssM8,
  });

  Booleans ssM0;
  Booleans ssM1;
  Booleans ssM2;
  Doubles ssM3;
  Doubles ssM4;
  Doubles ssM5;
  Doubles ssM6;
  Doubles ssM7;
  Doubles ssM8;

  factory SsMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return SsMapFields(
      ssM0: Booleans.fromJson(parsedJson["0"]),
      ssM1: Booleans.fromJson(parsedJson["1"]),
      ssM2: Booleans.fromJson(parsedJson["2"]),
      ssM3: Doubles.fromJson(parsedJson["3"]),
      ssM4: Doubles.fromJson(parsedJson["4"]),
      ssM5: Doubles.fromJson(parsedJson["5"]),
      ssM6: Doubles.fromJson(parsedJson["6"]),
      ssM7: Doubles.fromJson(parsedJson["7"]),
      ssM8: Doubles.fromJson(parsedJson["8"]),
    );
  }
}

class SoilTestResults {
  SoilTestResults({
    required this.mapValue,
  });

  SoilTestResultsMapValue mapValue;

  factory SoilTestResults.fromJson(Map<String, dynamic> parsedJson) {
    return SoilTestResults(
      mapValue: SoilTestResultsMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class SoilTestResultsMapValue {
  SoilTestResultsMapValue({
    required this.fields,
  });

  SoilTestResultsMapFields fields;

  factory SoilTestResultsMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return SoilTestResultsMapValue(
      fields: SoilTestResultsMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SoilTestResultsMapFields {
  SoilTestResultsMapFields({
    required this.microNutrients,
    required this.macroNutrients,
  });

  MicroNutrientsClass microNutrients;
  MacroNutrientsClass macroNutrients;

  factory SoilTestResultsMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return SoilTestResultsMapFields(
      microNutrients:
          MicroNutrientsClass.fromJson(parsedJson["MicroNutrients"]),
      macroNutrients:
          MacroNutrientsClass.fromJson(parsedJson["MacroNutrients"]),
    );
  }
}

class MacroNutrientsClass {
  MacroNutrientsClass({
    required this.mapValue,
  });

  MacroNutrientsMapValueClass mapValue;

  factory MacroNutrientsClass.fromJson(Map<String, dynamic> parsedJson) {
    return MacroNutrientsClass(
      mapValue: MacroNutrientsMapValueClass.fromJson(parsedJson["mapValue"]),
    );
  }
}

class MacroNutrientsMapValueClass {
  MacroNutrientsMapValueClass({
    required this.fields,
  });

  SMnFields fields;

  factory MacroNutrientsMapValueClass.fromJson(
      Map<String, dynamic> parsedJson) {
    return MacroNutrientsMapValueClass(
      fields: SMnFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SMnFields {
  SMnFields({
    required this.smn0,
    required this.smn1,
    required this.smn2,
    required this.smn3,
  });

  Smn smn0;
  Smn smn1;
  Smn smn2;
  Smn smn3;

  factory SMnFields.fromJson(Map<String, dynamic> parsedJson) {
    return SMnFields(
      smn0: Smn.fromJson(parsedJson["0"]),
      smn1: Smn.fromJson(parsedJson["1"]),
      smn2: Smn.fromJson(parsedJson["2"]),
      smn3: Smn.fromJson(parsedJson["3"]),
    );
  }
}

class Smn {
  Smn({
    required this.mapValue,
  });

  SmnMapValue mapValue;

  factory Smn.fromJson(Map<String, dynamic> parsedJson) {
    return Smn(
      mapValue: SmnMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class SmnMapValue {
  SmnMapValue({
    required this.fields,
  });

  SmnMapFields fields;

  factory SmnMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return SmnMapValue(
      fields: SmnMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SmnMapFields {
  SmnMapFields({
    required this.mnS0,
    required this.mnS1,
    required this.mnS2,
  });

  Doubles mnS0;
  Doubles mnS1;
  Doubles mnS2;

  factory SmnMapFields.fromJson(Map<String, dynamic> parsedJson) =>
      SmnMapFields(
        mnS0: Doubles.fromJson(parsedJson["0"]),
        mnS1: Doubles.fromJson(parsedJson["1"]),
        mnS2: Doubles.fromJson(parsedJson["2"]),
      );
}

class MicroNutrientsClass {
  MicroNutrientsClass({
    required this.mapValue,
  });

  MicroNutrientsMapValueClass mapValue;

  factory MicroNutrientsClass.fromJson(Map<String, dynamic> parsedJson) {
    return MicroNutrientsClass(
      mapValue: MicroNutrientsMapValueClass.fromJson(parsedJson["mapValue"]),
    );
  }
}

class MicroNutrientsMapValueClass {
  MicroNutrientsMapValueClass({
    required this.fields,
  });

  SMiFields fields;

  factory MicroNutrientsMapValueClass.fromJson(
      Map<String, dynamic> parsedJson) {
    return MicroNutrientsMapValueClass(
      fields: SMiFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SMiFields {
  SMiFields({
    required this.smi0,
    required this.smi1,
    required this.smi2,
    required this.smi3,
  });

  Smi smi0;
  Smi smi1;
  Smi smi2;
  Smi smi3;

  factory SMiFields.fromJson(Map<String, dynamic> parsedJson) {
    return SMiFields(
      smi0: Smi.fromJson(parsedJson["0"]),
      smi1: Smi.fromJson(parsedJson["1"]),
      smi2: Smi.fromJson(parsedJson["2"]),
      smi3: Smi.fromJson(parsedJson["3"]),
    );
  }
}

class Smi {
  Smi({
    required this.mapValue,
  });

  SmiMapValue mapValue;

  factory Smi.fromJson(Map<String, dynamic> parsedJson) {
    return Smi(
      mapValue: SmiMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class SmiMapValue {
  SmiMapValue({
    required this.fields,
  });

  SmiMapFields fields;

  factory SmiMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return SmiMapValue(
      fields: SmiMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class SmiMapFields {
  SmiMapFields({
    required this.miS0,
    required this.miS1,
    required this.miS2,
  });

  Booleans miS0;
  Booleans miS1;
  Booleans miS2;

  factory SmiMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return SmiMapFields(
      miS0: Booleans.fromJson(parsedJson["0"]),
      miS1: Booleans.fromJson(parsedJson["1"]),
      miS2: Booleans.fromJson(parsedJson["2"]),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class MatrixHelper {
//   // Creates a map that can be stored in Firebase from an int matrix.
//   static Map<String, dynamic> mapFromIntMatrix(List<List<Object>> intMatrix) {
//     Map<String, Map<Object, dynamic>> map = {};
//     int index = 0;
//     for (List<Object> row in intMatrix) {
//       // print(row);
//       map.addEntries([MapEntry(index.toString(), {})]);
//       //print(map);
//       int name = 1;
//       for (Object value in row) {
//         map[index.toString()]!
//             .addEntries([MapEntry('ss$name', value.runtimeType)]);
//         name += 1;
//       }
//       name = 1;
//       index += 1;
//     }
//     return map;
//   }
//
//   // Creates an int matrix from a dynamic map.
//   static List<List<int>> intMatrixFromMap(Map<dynamic, dynamic> dynamicMap) {
//     final map = Map<String, dynamic>.from(dynamicMap);
//     List<List<int>> matrix = [];
//     map.forEach((stringIndex, value) {
//       Map<String, dynamic> rowMap = Map<String, dynamic>.from(value);
//       List<int> row = [];
//       rowMap.forEach((stringNumber, boolean) {
//         row.add(int.parse(stringNumber));
//       });
//       matrix.add(row);
//     });
//     return matrix;
//   }
// }
