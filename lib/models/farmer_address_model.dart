import 'dart:convert';

// ignore: non_constant_identifier_names
List<Place> PlaceFromJson(String str) =>
    List<Place>.from(json.decode(str).map((x) => Place.fromJson(x)));

class Place {
  Place({
    required this.message,
    required this.status,
    required this.postOffice,
  });

  String message;
  String status;
  List<PostOffice>? postOffice;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        message: json["Message"],
        status: json["Status"],
        postOffice: json["PostOffice"] == null
            ? null
            : List<PostOffice>.from(
                json["PostOffice"].map((x) => PostOffice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "PostOffice": postOffice == null
            ? null
            : List<dynamic>.from(postOffice!.map((x) => x.toJson())),
      };
}

class PostOffice {
  PostOffice({
    required this.name,
    required this.description,
    required this.branchType,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
    required this.state,
    required this.country,
    required this.pincode,
  });

  String name;
  dynamic description;
  String branchType;
  String deliveryStatus;
  String circle;
  String district;
  String division;
  String region;
  String block;
  String state;
  String country;
  String pincode;

  factory PostOffice.fromJson(Map<String, dynamic> json) => PostOffice(
        name: json["Name"],
        description: json["Description"],
        branchType: json["BranchType"],
        deliveryStatus: json["DeliveryStatus"],
        circle: json["Circle"],
        district: json["District"],
        division: json["Division"],
        region: json["Region"],
        block: json["Block"],
        state: json["State"],
        country: json["Country"],
        pincode: json["Pincode"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "BranchType": branchType,
        "DeliveryStatus": deliveryStatus,
        "Circle": circle,
        "District": district,
        "Division": division,
        "Region": region,
        "Block": block,
        "State": state,
        "Country": country,
        "Pincode": pincode,
      };
}
