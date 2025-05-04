import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _emailAddressController = TextEditingController();
final TextEditingController _phoneNumberController = TextEditingController();
TextEditingController _farmerNumberController = TextEditingController();
final TextEditingController _surveyNumberController = TextEditingController();
final TextEditingController _addressLandmarkController =
    TextEditingController();

Future<void> farmerEditDialog(BuildContext context, farmer) async {
  return await showDialog(
      context: context,
      builder: (context) {
        _farmerNumberController.text = 'AFN' + '1';
        _firstNameController.text = farmer.fields.firstName.stringValue;
        _lastNameController.text = farmer.fields.lastName.stringValue;
        String docRef = farmer.name;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(18),
            title: Text('Update Farmer Account'),
            scrollable: true,
            content: Form(
              key: _formKey,
              child: SizedBox(
                width: 720,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              return value!.isNotEmpty
                                  ? null
                                  : "Enter first name";
                            },
                            decoration: InputDecoration(
                              labelText: "First Name *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              return value!.isNotEmpty
                                  ? null
                                  : "Enter last name";
                            },
                            decoration: InputDecoration(
                              labelText: "Last Name *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailAddressController,
                            validator: (value) {
                              return value!.isNotEmpty
                                  ? null
                                  : "Enter email address";
                            },
                            decoration: InputDecoration(
                              labelText: "Email address *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneNumberController,
                            validator: (value) {
                              return value!.isNotEmpty
                                  ? null
                                  : "Enter phone number";
                            },
                            decoration: InputDecoration(
                              labelText: "Phone number *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _farmerNumberController,
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Farmer number";
                            },
                            decoration: InputDecoration(
                              labelText: "Farmer No.",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _surveyNumberController,
                            validator: (value) {
                              return value!.isNotEmpty
                                  ? null
                                  : "Enter survey number";
                            },
                            decoration: InputDecoration(
                              labelText: "Survey No. *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _addressLandmarkController,
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Enter address";
                            },
                            decoration: InputDecoration(
                              labelText: "Address *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _farmerNumberController,
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Enter taluk";
                            },
                            decoration: InputDecoration(
                              labelText: "Taluk *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _surveyNumberController,
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Enter city";
                            },
                            decoration: InputDecoration(
                              labelText: "City *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _farmerNumberController,
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Enter state";
                            },
                            decoration: InputDecoration(
                              labelText: "State *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _surveyNumberController,
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Enter country";
                            },
                            decoration: InputDecoration(
                              labelText: "Country *",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(fixedSize: Size(76, 36)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var data = jsonEncode({
                      "fields": {
                        "firstName": {"stringValue": _firstNameController.text},
                        "lastName": {"stringValue": _lastNameController.text}
                      }
                    });
                    updateFarmer(data, docRef);
                    _formKey.currentState!.reset();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Update'),
              ),
            ],
          );
        });
      });
}

Future<void> updateFarmer(data, docRef) async {
  final response = await http.patch(
    Uri.parse('http://localhost:8080/v1/$docRef'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: data,
  );

  if (response.statusCode == 200) {
    print('done');
    return null;
  } else {
    throw Exception('Failed to update farmer details.');
  }
}
