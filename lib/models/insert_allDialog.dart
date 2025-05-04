import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

final TextEditingController _insertConfController = TextEditingController();
final _insertConfFocusNode = FocusNode();

Future<bool> insertAllDialog(
    BuildContext context, insertWho, insertWhich) async {
  return await showDialog(
      context: context,
      builder: (context) {
        bool insertState = insertWho == null ? false : true;
        insertWho == null
            ? _insertConfController.text = ''
            : _insertConfController.text = insertWho;
        _insertConfFocusNode.requestFocus();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(8.0),
            title: Text('Insert ${insertWhich.toLowerCase()}'),
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To insert ${insertWhich.toLowerCase()}, type the Farmer ID:',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Farmer ID'),
                  focusNode: _insertConfFocusNode,
                  controller: _insertConfController,
                  onChanged: insertWho == null
                      ? (value) {
                          if (value.length == 17) {
                            setState(() {
                              insertState = true;
                            });
                          } else {
                            setState(() {
                              insertState = false;
                            });
                          }
                        }
                      : (value) {
                          if (value.length == insertWho.length &&
                              value == insertWho) {
                            setState(() {
                              insertState = true;
                            });
                          } else {
                            setState(() {
                              insertState = false;
                            });
                          }
                        },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(fixedSize: Size(76, 36)),
                onPressed: () {
                  _insertConfController.clear();
                  Navigator.pop(context, true);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: insertState
                    ? () {
                        var insertData = jsonEncode({
                          "fields": {
                            "sampleNumber": {
                              "stringValue": 'ASN' +
                                  DateFormat("yyyyMMddkkmmss")
                                      .format(DateTime.now())
                                      .toString()
                            },
                            "farmerNumber": {
                              "stringValue": _insertConfController.text
                            },
                            "sampleCreatedAt": {
                              "timestampValue":
                                  DateTime.now().toUtc().toIso8601String()
                            },
                            "sampleCreatedBy": {
                              "stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"
                            },
                            "sampleModifiedAt": {
                              "timestampValue":
                                  DateTime.now().toUtc().toIso8601String()
                            },
                            "sampleModifiedBy": {
                              "stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"
                            },
                            "reportCreated": {"booleanValue": false}
                          }
                        });
                        insertDocument(_insertConfController.text, insertWhich,
                            insertData);
                        _insertConfController.clear();
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text('Insert'),
              ),
            ],
          );
        });
      }).then((value) {
    _insertConfController.clear();
    return true;
  });
}

Future<void> insertDocument(insertRef, String insertWhich, insertData) async {
  await http
      .post(
        Uri.parse(
            'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents/${insertWhich.toLowerCase()}s'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: insertData,
      )
      .then((value) => print(value.statusCode));
}
