import 'dart:convert';

import 'package:agrigo_kia/models/farmer_query_model.dart';
import 'package:agrigo_kia/models/report_query_model.dart';
import 'package:agrigo_kia/models/sample_query_model.dart';
import 'package:http/http.dart' as http;

Future<List<FarmerQuery>> fetchFarmerDetails(String farmerNumber) async {
  var queryStructureBy = farmerNumber == 'null'
      ? jsonEncode({
          "structuredQuery": {
            "orderBy": [
              {
                "field": {"fieldPath": "farmerNumber"},
                "direction": "ASCENDING"
              }
            ],
            "from": [
              {"collectionId": "farmers", "allDescendants": true}
            ]
          }
        })
      : jsonEncode({
          "structuredQuery": {
            "where": {
              "fieldFilter": {
                "field": {"fieldPath": "farmerNumber"},
                "op": "EQUAL",
                "value": {"stringValue": farmerNumber}
              }
            },
            "orderBy": [
              {
                "field": {"fieldPath": "farmerNumber"},
                "direction": "ASCENDING"
              }
            ],
            "from": [
              {"collectionId": "farmers", "allDescendants": true}
            ]
          }
        });
  final response = await http.post(
      Uri.parse(
          'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents:runQuery'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: queryStructureBy);
  return parseFarmerQuery(utf8.decode(response.bodyBytes));
}

List<FarmerQuery> parseFarmerQuery(String bodyBytes) {
  final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

  return parsed.map<FarmerQuery>((json) => FarmerQuery.fromJson(json)).toList();
}

Future<List<ReportQuery>> fetchReportDetails(String reportNumber) async {
  var queryStructureBy = reportNumber == 'null'
      ? jsonEncode({
          "structuredQuery": {
            "orderBy": [
              {
                "field": {"fieldPath": "reportNumber"},
                "direction": "ASCENDING"
              }
            ],
            "from": [
              {"collectionId": "reports", "allDescendants": true}
            ]
          }
        })
      : reportNumber.startsWith('ASN')
          ? jsonEncode({
              "structuredQuery": {
                "where": {
                  "fieldFilter": {
                    "field": {"fieldPath": "sampleNumber"},
                    "op": "EQUAL",
                    "value": {"stringValue": reportNumber}
                  }
                },
                "orderBy": [
                  {
                    "field": {"fieldPath": "reportNumber"},
                    "direction": "ASCENDING"
                  }
                ],
                "from": [
                  {"collectionId": "reports", "allDescendants": true}
                ]
              }
            })
          : jsonEncode({
              "structuredQuery": {
                "where": {
                  "fieldFilter": {
                    "field": {"fieldPath": "reportNumber"},
                    "op": "EQUAL",
                    "value": {"stringValue": reportNumber}
                  }
                },
                "orderBy": [
                  {
                    "field": {"fieldPath": "reportNumber"},
                    "direction": "ASCENDING"
                  }
                ],
                "from": [
                  {"collectionId": "reports", "allDescendants": true}
                ]
              }
            });
  final response = await http.post(
      Uri.parse(
          'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents:runQuery'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: queryStructureBy);
  return parseReportQuery(utf8.decode(response.bodyBytes));
}

List<ReportQuery> parseReportQuery(String bodyBytes) {
  final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

  return parsed.map<ReportQuery>((json) => ReportQuery.fromJson(json)).toList();
}

Future<List<SampleQuery>> fetchSampleDetails(String sampleNumber) async {
  var queryStructureBy = sampleNumber == 'null'
      ? jsonEncode({
          "structuredQuery": {
            "orderBy": [
              {
                "field": {"fieldPath": "sampleNumber"},
                "direction": "ASCENDING"
              }
            ],
            "from": [
              {"collectionId": "samples", "allDescendants": true}
            ]
          }
        })
      : jsonEncode({
          "structuredQuery": {
            "where": {
              "fieldFilter": {
                "field": {"fieldPath": "sampleNumber"},
                "op": "EQUAL",
                "value": {"stringValue": sampleNumber}
              }
            },
            "orderBy": [
              {
                "field": {"fieldPath": "sampleNumber"},
                "direction": "ASCENDING"
              }
            ],
            "from": [
              {"collectionId": "samples", "allDescendants": true}
            ]
          }
        });
  final response = await http.post(
      Uri.parse(
          'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents:runQuery'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: queryStructureBy);
  if (response.body.length == 52) {
    var fakeData =
        '[{"document": {"name": "fakeData", "fields": {"sampleModifiedAt": {"timestampValue": "2021-07-18T15:12:04.920701Z"}, "reportCreated": {"booleanValue": false}, "farmerNumber": { "stringValue": "AFNYYYYMMDDHHMMSS"}, "sampleModifiedBy": {"stringValue": "me"}, "sampleNumber": {"stringValue": "ASNYYYYMMDDHHMMSS"}, "sampleCreatedBy": { "stringValue": "me" }, "sampleCreatedAt": { "timestampValue": "2021-07-18T15:12:04.919704Z" }}, "createTime": "2021-07-18T15:12:05.118Z", "updateTime": "2021-07-18T15:12:05.118Z" }, "readTime": "2021-07-18T15:40:07.288001Z"}]';
    return parseSampleQuery(fakeData);
  } else {
    return parseSampleQuery(utf8.decode(response.bodyBytes));
  }
}

List<SampleQuery> parseSampleQuery(String bodyBytes) {
  final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

  return parsed.map<SampleQuery>((json) => SampleQuery.fromJson(json)).toList();
}
