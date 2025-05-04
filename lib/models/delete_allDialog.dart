import 'dart:async';
import 'package:agrigo_kia/resources/fetch_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final TextEditingController _deleteConfController = TextEditingController();
final _deleteConfFocusNode = FocusNode();

Future<bool> deleteAllDialog(BuildContext context, deleteWho,
    String deleteWhich, String deleteConf, deleteRef, refToken) async {
  return await showDialog(
      context: context,
      builder: (context) {
        bool deleteState = false;
        _deleteConfFocusNode.requestFocus();
        return StatefulBuilder(builder: (context, setState) {
          _deleteConfFocusNode.requestFocus();
          return AlertDialog(
            actionsPadding: EdgeInsets.all(8.0),
            title: Text('Delete this ${deleteWhich.toLowerCase()}?'),
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              children: [
                Text(
                  'To delete ${deleteWhich.toLowerCase()} "$deleteWho", type the ${deleteWhich.toLowerCase()} ID: $deleteConf',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  decoration: InputDecoration(labelText: '$deleteWhich ID'),
                  focusNode: _deleteConfFocusNode,
                  controller: _deleteConfController,
                  onChanged: (value) {
                    if (value.length == deleteConf.length &&
                        value == deleteConf) {
                      setState(() {
                        deleteState = true;
                      });
                    } else {
                      setState(() {
                        deleteState = false;
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
                  _deleteConfController.clear();
                  Navigator.pop(context, true);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: deleteState
                    ? () {
                        deleteDocument(
                            deleteRef, refToken, deleteWhich, deleteConf);
                        _deleteConfController.clear();
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text('Delete'),
              ),
            ],
          );
        });
      }).then((value) {
    _deleteConfController.clear();
    return true;
  });
}

Future<void> deleteDocument(docRef, refToken, deleteWhich, deleteConf) async {
  if ('Farmer' == deleteWhich) {
    await http
        .post(
      Uri.parse(
          'http://localhost:9099/securetoken.googleapis.com/v1/token?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=refresh_token&refresh_token=$refToken',
    )
        .then((responseToken) async {
      await http
          .post(
        Uri.parse(
            'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json
            .encode({"idToken": jsonDecode(responseToken.body)['id_token']}),
      )
          .then((responseAuth) async {
        await http.delete(Uri.parse('http://localhost:8080/v1/$docRef'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            }).then((responseDoc) async {
          await http.delete(
              Uri.parse(
                  'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2F$deleteConf.png'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              });
        });
      });
    });
  } else if ('Sample' == deleteWhich) {
    fetchReportDetails(deleteConf).then((valueReport) async {
      await http.delete(
          Uri.parse(
              'http://localhost:8080/v1/${valueReport.first.document.name}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          }).then((value) async {
        await http.delete(Uri.parse('http://localhost:8080/v1/$docRef'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            });
      });
    });
  } else if ('Report' == deleteWhich) {
    await http.delete(Uri.parse('http://localhost:8080/v1/$docRef'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        }).then((value) {
      fetchSampleDetails(refToken).then((valueSample) async {
        var reportD = jsonEncode({
          "fields": {
            "reportCreated": {"booleanValue": false},
            "sampleModifiedBy": {"stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"},
            "sampleModifiedAt": {
              "timestampValue": DateTime.now().toUtc().toIso8601String()
            }
          }
        });
        await http.patch(
          Uri.parse(
              'http://localhost:8080/v1/${valueSample.first.document.name}?updateMask.fieldPaths=reportCreated&updateMask.fieldPaths=sampleModifiedAt&updateMask.fieldPaths=sampleModifiedBy'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: reportD,
        );
      });
    });
  }
}
