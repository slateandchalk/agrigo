class FarmerQuery {
  FarmerQuery({
    required this.document,
  });

  FarmerQueryDocument document;

  factory FarmerQuery.fromJson(Map<String, dynamic> parsedJson) {
    return FarmerQuery(
        document: FarmerQueryDocument.fromJson(parsedJson['document']));
  }
}

class FarmerQueryDocument {
  FarmerQueryDocument({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  FarmerQueryFields fields;
  String createTime;
  String updateTime;

  factory FarmerQueryDocument.fromJson(Map<String, dynamic> parsedJson) {
    return FarmerQueryDocument(
      name: parsedJson["name"],
      fields: FarmerQueryFields.fromJson(parsedJson["fields"]),
      createTime: parsedJson["createTime"],
      updateTime: parsedJson["updateTime"],
    );
  }
}

class FarmerQueryFields {
  FarmerQueryFields({
    required this.lastName,
    required this.farmerCreatedAt,
    required this.farmerCreatedBy,
    required this.farmerModifiedAt,
    required this.farmerModifiedBy,
    required this.farmerNumber,
    required this.farmerRefresh,
    required this.firstName,
    required this.profilePicture,
    required this.emailAddress,
    required this.phoneNumber,
    required this.addressDetails,
  });

  Strings lastName;
  FarmerCreatedAt farmerCreatedAt;
  Strings farmerCreatedBy;
  FarmerCreatedAt farmerModifiedAt;
  Strings farmerModifiedBy;
  Strings farmerNumber;
  Strings farmerRefresh;
  Strings firstName;
  MacroNutrients profilePicture;
  EmailAddress emailAddress;
  PhoneNumber phoneNumber;
  AddressDetails addressDetails;

  factory FarmerQueryFields.fromJson(Map<String, dynamic> parsedJson) {
    return FarmerQueryFields(
      lastName: Strings.fromJson(parsedJson["lastName"]),
      farmerCreatedAt: FarmerCreatedAt.fromJson(parsedJson["farmerCreatedAt"]),
      farmerCreatedBy: Strings.fromJson(parsedJson["farmerCreatedBy"]),
      farmerModifiedAt:
          FarmerCreatedAt.fromJson(parsedJson["farmerModifiedAt"]),
      farmerModifiedBy: Strings.fromJson(parsedJson["farmerModifiedBy"]),
      farmerNumber: Strings.fromJson(parsedJson["farmerNumber"]),
      farmerRefresh: Strings.fromJson(parsedJson["farmerRefresh"]),
      firstName: Strings.fromJson(parsedJson["firstName"]),
      profilePicture: MacroNutrients.fromJson(parsedJson["profilePicture"]),
      emailAddress: EmailAddress.fromJson(parsedJson["emailAddress"]),
      phoneNumber: PhoneNumber.fromJson(parsedJson["phoneNumber"]),
      addressDetails: AddressDetails.fromJson(parsedJson["addressDetails"]),
    );
  }
}

class AddressDetails {
  AddressDetails({
    required this.mapValue,
  });

  AddressDetailsMapValue mapValue;

  factory AddressDetails.fromJson(Map<String, dynamic> parsedJson) {
    return AddressDetails(
      mapValue: AddressDetailsMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class AddressDetailsMapValue {
  AddressDetailsMapValue({
    required this.fields,
  });

  AdFields fields;

  factory AddressDetailsMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return AddressDetailsMapValue(
      fields: AdFields.fromJson(parsedJson["fields"]),
    );
  }
}

class AdFields {
  AdFields({
    required this.mn0,
  });

  Ad mn0;

  factory AdFields.fromJson(Map<String, dynamic> parsedJson) {
    return AdFields(
      mn0: Ad.fromJson(parsedJson["0"]),
    );
  }
}

class Ad {
  Ad({
    required this.mapValue,
  });

  AdMapValue mapValue;

  factory Ad.fromJson(Map<String, dynamic> parsedJson) {
    return Ad(
      mapValue: AdMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class AdMapValue {
  AdMapValue({
    required this.fields,
  });

  AdMapFields fields;

  factory AdMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return AdMapValue(
      fields: AdMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class AdMapFields {
  AdMapFields({
    required this.eaM0,
    required this.eaM1,
    required this.eaM2,
    required this.eaM3,
    required this.eaM4,
    required this.eaM5,
    required this.eaM6,
    required this.eaM7,
    required this.eaM8,
  });

  Strings eaM0;
  Strings eaM1;
  Strings eaM2;
  Strings eaM3;
  Strings eaM4;
  Strings eaM5;
  Strings eaM6;
  Strings eaM7;
  Booleans eaM8;

  factory AdMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return AdMapFields(
      eaM0: Strings.fromJson(parsedJson["addressStreet"]),
      eaM1: Strings.fromJson(parsedJson["surveyNumber"]),
      eaM2: Strings.fromJson(parsedJson["addressPincode"]),
      eaM3: Strings.fromJson(parsedJson["addressArea"]),
      eaM4: Strings.fromJson(parsedJson["addressTaluk"]),
      eaM5: Strings.fromJson(parsedJson["addressCity"]),
      eaM6: Strings.fromJson(parsedJson["addressState"]),
      eaM7: Strings.fromJson(parsedJson["addressCountry"]),
      eaM8: Booleans.fromJson(parsedJson["addressPrimary"]),
    );
  }
}

class PhoneNumber {
  PhoneNumber({
    required this.mapValue,
  });

  PhoneNumberMapValue mapValue;

  factory PhoneNumber.fromJson(Map<String, dynamic> parsedJson) {
    return PhoneNumber(
      mapValue: PhoneNumberMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class PhoneNumberMapValue {
  PhoneNumberMapValue({
    required this.fields,
  });

  PnFields fields;

  factory PhoneNumberMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return PhoneNumberMapValue(
      fields: PnFields.fromJson(parsedJson["fields"]),
    );
  }
}

class PnFields {
  PnFields({
    required this.mn0,
  });

  Pn mn0;

  factory PnFields.fromJson(Map<String, dynamic> parsedJson) {
    return PnFields(
      mn0: Pn.fromJson(parsedJson["0"]),
    );
  }
}

class Pn {
  Pn({
    required this.mapValue,
  });

  PnMapValue mapValue;

  factory Pn.fromJson(Map<String, dynamic> parsedJson) {
    return Pn(
      mapValue: PnMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class PnMapValue {
  PnMapValue({
    required this.fields,
  });

  PnMapFields fields;

  factory PnMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return PnMapValue(
      fields: PnMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class PnMapFields {
  PnMapFields({
    required this.eaM0,
    required this.eaM1,
    required this.eaM2,
    required this.eaM3,
  });

  Strings eaM0;
  Booleans eaM1;
  Strings eaM2;
  Strings eaM3;

  factory PnMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return PnMapFields(
      eaM0: Strings.fromJson(parsedJson["phoneExtension"]),
      eaM1: Booleans.fromJson(parsedJson["phonePrimary"]),
      eaM2: Strings.fromJson(parsedJson["phoneNumber"]),
      eaM3: Strings.fromJson(parsedJson["phoneLabel"]),
    );
  }
}

class EmailAddress {
  EmailAddress({
    required this.mapValue,
  });

  EmailAddressMapValue mapValue;

  factory EmailAddress.fromJson(Map<String, dynamic> parsedJson) {
    return EmailAddress(
      mapValue: EmailAddressMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class EmailAddressMapValue {
  EmailAddressMapValue({
    required this.fields,
  });

  EaFields fields;

  factory EmailAddressMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return EmailAddressMapValue(
      fields: EaFields.fromJson(parsedJson["fields"]),
    );
  }
}

class EaFields {
  EaFields({
    required this.mn0,
  });

  Ea mn0;

  factory EaFields.fromJson(Map<String, dynamic> parsedJson) {
    return EaFields(
      mn0: Ea.fromJson(parsedJson["0"]),
    );
  }
}

class Ea {
  Ea({
    required this.mapValue,
  });

  EaMapValue mapValue;

  factory Ea.fromJson(Map<String, dynamic> parsedJson) {
    return Ea(
      mapValue: EaMapValue.fromJson(parsedJson["mapValue"]),
    );
  }
}

class EaMapValue {
  EaMapValue({
    required this.fields,
  });

  EaMapFields fields;

  factory EaMapValue.fromJson(Map<String, dynamic> parsedJson) {
    return EaMapValue(
      fields: EaMapFields.fromJson(parsedJson["fields"]),
    );
  }
}

class EaMapFields {
  EaMapFields({
    required this.eaM0,
    required this.eaM1,
    required this.eaM2,
  });

  Strings eaM0;
  Booleans eaM1;
  Strings eaM2;

  factory EaMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return EaMapFields(
      eaM0: Strings.fromJson(parsedJson["emailAddress"]),
      eaM1: Booleans.fromJson(parsedJson["emailPrimary"]),
      eaM2: Strings.fromJson(parsedJson["emailLabel"]),
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

class FarmerCreatedAt {
  FarmerCreatedAt({
    required this.timestampValue,
  });

  String timestampValue;

  factory FarmerCreatedAt.fromJson(Map<String, dynamic> parsedJson) {
    return FarmerCreatedAt(
      timestampValue: parsedJson["timestampValue"],
    );
  }
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
  });

  Mn mn0;

  factory MnFields.fromJson(Map<String, dynamic> parsedJson) {
    return MnFields(
      mn0: Mn.fromJson(parsedJson["0"]),
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
  });

  Strings mnM0;
  Booleans mnM1;

  factory MnMapFields.fromJson(Map<String, dynamic> parsedJson) {
    return MnMapFields(
      mnM0: Strings.fromJson(parsedJson["pictureUrl"]),
      mnM1: Booleans.fromJson(parsedJson["picturePrimary"]),
    );
  }
}
