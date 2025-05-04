import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:agrigo_kia/models/farmer_address_model.dart';
import 'package:agrigo_kia/models/farmer_cropDialog.dart';
import 'package:agrigo_kia/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:agrigo_kia/resources/country_list.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

final TextEditingController _firstNameController = TextEditingController();
final _firstNameFocusNode = FocusNode();
final TextEditingController _lastNameController = TextEditingController();
final _lastNameFocusNode = FocusNode();
//email
final _emailAddressNode = FocusNode();
final TextEditingController _emailAddressController = TextEditingController();
final _emailAddressLabelNode = FocusNode();
//phone
final _phoneNumberNode = FocusNode();
final TextEditingController _phoneNumberController = TextEditingController();
final _phoneNumberLabelNode = FocusNode();
// Street & Survey
final _addressStreetFocusNode = FocusNode();
final TextEditingController _addressStreetController = TextEditingController();
final _surveyNumberFocusNode = FocusNode();
final TextEditingController _surveyNumberController = TextEditingController();
//pincode
final _addressPincodeNode = FocusNode();
final TextEditingController _addressPincodeController = TextEditingController();
final _addressPincodeLabelNode = FocusNode();
//Area optional
final TextEditingController _addressAreaController = TextEditingController();
final _addressAreaFocusNode = FocusNode();
//Taluk & City
final _addressTalukFocusNode = FocusNode();
final TextEditingController _addressTalukController = TextEditingController();
final _addressCityFocusNode = FocusNode();
final TextEditingController _addressCityController = TextEditingController();
//State
final _addressStateFocusNode = FocusNode();
final TextEditingController _addressStateController = TextEditingController();
//country
final _addressCountryNode = FocusNode();

Future<String> _openImageFile(BuildContext context) async {
  // final fileName = 'fileName1.svg';
  // final path = await FileSelectorPlatform.instance.getSavePath(
  //   suggestedName: fileName,
  // );
  //
  // final text = Uri.parse(
  //     'https://avatar.oxro.io/avatar.svg?name=Sharvesh+Design&length=2&background=d6e3e9&color=2e4752');
  // final fileData = text.data!.contentAsBytes();
  // print(fileData);
  // const fileMimeType = 'image/svg+xml';
  // final textFile =
  //     XFile.fromData(fileData, mimeType: fileMimeType, name: fileName);
  // await textFile.saveTo(path!);
  final typeGroup = XTypeGroup(
    label: 'images',
    extensions: ['jpg', 'png'],
  );
  final files = await FileSelectorPlatform.instance
      .openFiles(acceptedTypeGroups: [typeGroup]);
  if (files.isEmpty) {
    return 'Cancel';
  }
  final file = files[0];
  return file.path;
}

Future<bool> farmerNewDialog(
    BuildContext context, farmerDoc, isPreview, docRef) async {
  return await showDialog(
      context: context,
      builder: (context) {
        bool changeHappened =
            farmerDoc == null && isPreview == false ? false : false;
        List<String> _areaOptions;
        List<Map<String, dynamic>> _pincodeResults;
        bool profilePicture;
        bool profilePictureFetch;
        late Uint8List profilePictureSource;
        late String profileUrl;
        late String firstName;
        late String lastName;
        late String emailAddress;
        late String phoneNumber;
        late String phoneNumberCode;
        late String phoneNumberLabel;
        late String addressStreet;
        late String addressSurvey;
        late String addressPincode;
        late String addressArea;
        late String addressTaluk;
        late String addressCity;
        late String addressState;
        late String addressCountry;
        String _emailAddressLabelValue;
        late String emailAddressLabel;
        String _phoneNumberCodeValue;
        String _phoneNumberLabelValue;
        String _addressCountryValue;
        String _pincodeAddressLabelValue;
        bool _nameHasFocus,
            _emailHasFocus,
            _emailLabel,
            _emailLabelHasFocus,
            _phoneHasFocus,
            _phoneLabel,
            _phoneLabelHasFocus,
            _streetHasFocus,
            _countryHasFocus,
            _pincodeHasFocus,
            _pincodeLabel,
            _pincodeManualLabel,
            _pincodeLabelHasFocus,
            _talukHasFocus,
            _stateHasFocus;
        _nameHasFocus = _emailHasFocus = _emailLabel = _emailLabelHasFocus =
            _phoneHasFocus = _phoneLabel = _phoneLabelHasFocus =
                _streetHasFocus = _countryHasFocus = _pincodeHasFocus =
                    _pincodeLabel = _pincodeManualLabel =
                        _pincodeLabelHasFocus =
                            _talukHasFocus = _stateHasFocus = false;
        if (farmerDoc == null) {
          //profile
          profileUrl = '';
          profilePicture = true;
          profilePictureFetch = true;
          //NameFields
          _firstNameController.clear();
          _lastNameController.clear();
          //emailAddress
          _emailAddressController.clear();
          _emailAddressLabelValue = 'Home';
          _emailLabel = false;
          //phoneNumber
          _phoneNumberController.text = '+91';
          _phoneNumberCodeValue = 'IN';
          _phoneNumberLabelValue = 'Mobile';
          _phoneLabel = false;
          //addressDetails
          _addressStreetController.clear();
          _surveyNumberController.clear();
          _addressPincodeController.clear();
          _areaOptions = [];
          _pincodeAddressLabelValue = 'Home';
          _pincodeResults = [];
          _pincodeLabel = false;
          _pincodeManualLabel = false;
          _addressTalukController.clear();
          _addressCityController.clear();
          _addressStateController.clear();
          _addressCountryValue = 'India';
        } else {
          //profile
          profileUrl = farmerDoc.profilePicture.mapValue.fields.mn0.mapValue
              .fields.mnM0.stringValue;
          profilePictureFetch = false;
          profilePicture = false;
          //NameFields
          firstName = farmerDoc.firstName.stringValue;
          _firstNameController.text = firstName;
          lastName = farmerDoc.lastName.stringValue;
          _lastNameController.text = lastName;
          //emailAddress
          emailAddress = farmerDoc.emailAddress.mapValue.fields.mn0.mapValue
              .fields.eaM0.stringValue;
          _emailAddressController.text = emailAddress;
          emailAddressLabel = farmerDoc.emailAddress.mapValue.fields.mn0
              .mapValue.fields.eaM2.stringValue;
          _emailAddressLabelValue = emailAddressLabel;
          _emailLabel = true;
          //phoneNumber
          phoneNumber = farmerDoc
              .phoneNumber.mapValue.fields.mn0.mapValue.fields.eaM2.stringValue;
          _phoneNumberController.text = phoneNumber;
          phoneNumberCode = farmerDoc
              .phoneNumber.mapValue.fields.mn0.mapValue.fields.eaM0.stringValue;
          _phoneNumberCodeValue = phoneNumberCode;
          phoneNumberLabel = farmerDoc
              .phoneNumber.mapValue.fields.mn0.mapValue.fields.eaM3.stringValue;
          _phoneNumberLabelValue = phoneNumberLabel;
          _phoneLabel = true;
          //addressDetails
          addressStreet = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM0.stringValue;
          _addressStreetController.text = addressStreet;
          addressSurvey = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM1.stringValue;
          _surveyNumberController.text = addressSurvey;
          addressPincode = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM2.stringValue;
          _addressPincodeController.text = addressPincode;
          addressArea = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM3.stringValue;
          _areaOptions = [addressArea];
          _pincodeAddressLabelValue = addressArea;
          addressTaluk = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM4.stringValue;
          addressCity = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM5.stringValue;
          addressState = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM6.stringValue;
          _pincodeResults = [
            {
              'Name': addressArea,
              'District': addressCity,
              'Block': addressTaluk,
              'State': addressState,
            }
          ];
          _pincodeLabel = true;
          _pincodeManualLabel = false;
          _addressTalukController.text = addressTaluk;
          _addressCityController.text = addressCity;
          _addressStateController.text = addressState;
          addressCountry = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue
              .fields.eaM7.stringValue;
          _addressCountryValue = addressCountry;
        }

        return StatefulBuilder(builder: (context, setState) {
          // _firstNameFocusNode.addListener(() {
          //   setState(() {
          //     _nameHasFocus = _firstNameFocusNode.hasFocus;
          //   });
          // });
          // _lastNameFocusNode.addListener(() {
          //   setState(() {
          //     _nameHasFocus = _lastNameFocusNode.hasFocus;
          //   });
          // });
          // _emailAddressNode.addListener(() {
          //   setState(() {
          //     _emailHasFocus = _emailAddressNode.hasFocus;
          //   });
          // });
          // _emailAddressLabelNode.addListener(() {
          //   setState(() {
          //     _emailLabelHasFocus = _emailAddressLabelNode.hasFocus;
          //   });
          // });
          // _phoneNumberNode.addListener(() {
          //   setState(() {
          //     _phoneHasFocus = _phoneNumberNode.hasFocus;
          //   });
          // });
          // _phoneNumberLabelNode.addListener(() {
          //   setState(() {
          //     _phoneLabelHasFocus = _phoneNumberLabelNode.hasFocus;
          //   });
          // });
          // _addressStreetFocusNode.addListener(() {
          //   setState(() {
          //     _streetHasFocus = _addressStreetFocusNode.hasFocus;
          //   });
          // });
          // _surveyNumberFocusNode.addListener(() {
          //   setState(() {
          //     _streetHasFocus = _surveyNumberFocusNode.hasFocus;
          //   });
          // });
          // _addressCountryNode.addListener(() {
          //   setState(() {
          //     _countryHasFocus = _addressCountryNode.hasFocus;
          //   });
          // });
          // _addressPincodeNode.addListener(() {
          //   setState(() {
          //     _pincodeHasFocus = _addressPincodeNode.hasFocus;
          //   });
          // });
          // _addressPincodeLabelNode.addListener(() {
          //   setState(() {
          //     _pincodeLabelHasFocus = _addressPincodeLabelNode.hasFocus;
          //   });
          // });
          // _addressTalukFocusNode.addListener(() {
          //   setState(() {
          //     _talukHasFocus = _addressTalukFocusNode.hasFocus;
          //   });
          // });
          // _addressCityFocusNode.addListener(() {
          //   setState(() {
          //     _talukHasFocus = _addressCityFocusNode.hasFocus;
          //   });
          // });
          // _addressStateFocusNode.addListener(() {
          //   setState(() {
          //     _stateHasFocus = _addressStateFocusNode.hasFocus;
          //   });
          // });

          return AlertDialog(
            actionsPadding: isPreview
                ? EdgeInsets.fromLTRB(0, 8, 34, 8)
                : EdgeInsets.fromLTRB(0, 8, 58, 8),
            title: !isPreview && farmerDoc == null
                ? Text('Create Farmer Account')
                : Text('Farmer Account Details'),
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Form(
              onChanged: farmerDoc == null && isPreview == false
                  ? () {
                      bool preCheck = _pincodeManualLabel
                          ? _addressAreaController.text.isEmpty
                          : _pincodeAddressLabelValue.isEmpty;
                      if (_firstNameController.text.isEmpty ||
                          _lastNameController.text.isEmpty ||
                          !_emailAddressController.text.contains(RegExp(
                              r"(?=[a-z0-9@.!#$%&'*+/=?^_‘{|}~-]{6,254})(?=[a-z0-9.!#$%&'*+/=?^_‘{|}~-]{1,64}@)[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:(?=[a-z0-9-]{1,63}\.)[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?=[a-z0-9-]{1,63})[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")) ||
                          !_phoneNumberController.text.contains(
                              RegExp(r"^[+][0-9]{1,4}[0-9]{11,15}")) ||
                          _addressStreetController.text.isEmpty ||
                          _surveyNumberController.text.isEmpty ||
                          !_addressPincodeController.text
                              .contains(RegExp(r"\d{6}")) ||
                          preCheck ||
                          _addressTalukController.text.isEmpty ||
                          _addressCityController.text.isEmpty ||
                          _addressStateController.text.isEmpty) {
                        setState(() {
                          changeHappened = false;
                        });
                      } else {
                        setState(() {
                          changeHappened = true;
                        });
                      }
                    }
                  : () {
                      bool preCheck = _pincodeManualLabel
                          ? _addressAreaController.text == addressArea
                          : _pincodeAddressLabelValue == addressArea;
                      if (_firstNameController.text == firstName &&
                          _lastNameController.text == lastName &&
                          _emailAddressController.text == emailAddress &&
                          _emailAddressLabelValue == emailAddressLabel &&
                          _phoneNumberCodeValue == phoneNumberCode &&
                          _phoneNumberController.text == phoneNumber &&
                          _phoneNumberLabelValue == phoneNumberLabel &&
                          _addressStreetController.text == addressStreet &&
                          _surveyNumberController.text == addressSurvey &&
                          _addressPincodeController.text == addressPincode &&
                          _addressTalukController.text == addressTaluk &&
                          _addressCityController.text == addressCity &&
                          _addressStateController.text == addressState &&
                          _addressCountryValue == addressCountry &&
                          preCheck) {
                        setState(() {
                          changeHappened = false;
                        });
                      } else {
                        setState(() {
                          changeHappened = true;
                        });
                      }
                    },
              key: _formKey,
              child: SizedBox(
                width: 720,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: CircleAvatar(
                                backgroundImage: profilePicture
                                    ? NetworkImage(
                                        'http://localhost:9199/v0/b/default-bucket/o/avatar.jpg?alt=media',
                                      )
                                    : profilePictureFetch
                                        ? Image.memory(profilePictureSource)
                                            .image
                                        : NetworkImage(profileUrl),
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: isPreview
                                    ? null
                                    : ClipOval(
                                        child: Material(
                                          color: profilePicture
                                              ? Color(0xFFD6E3E9)
                                              : Colors.black.withOpacity(0.5),
                                          child: SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: IconButton(
                                              icon: Icon(
                                                  Icons.add_a_photo_outlined),
                                              color: profilePicture
                                                  ? kReportTableColor
                                                  : Colors.white,
                                              onPressed: () {
                                                setState(() {
                                                  _openImageFile(context)
                                                      .then((filePath) {
                                                    if (filePath == 'Cancel') {
                                                      return;
                                                    }
                                                    farmerCropDialog(
                                                            context, filePath)
                                                        .then((value) {
                                                      if (value == 'Cancel') {
                                                        setState(() {
                                                          changeHappened =
                                                              false;
                                                        });
                                                        return;
                                                      }
                                                      setState(() {
                                                        profilePictureSource =
                                                            value;
                                                        profilePicture = false;
                                                        profilePictureFetch =
                                                            true;
                                                        changeHappened = true;
                                                      });
                                                    });
                                                  });
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _firstNameFocusNode,
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      labelText: 'First name',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _lastNameFocusNode,
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Last name',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                HasFocus(
                                  hasFocus: _nameHasFocus,
                                  onPressFnc: () {
                                    if (farmerDoc == null) {
                                      _firstNameController.clear();
                                      _lastNameController.clear();
                                      _firstNameFocusNode.requestFocus();
                                    } else {
                                      _firstNameController.text = firstName;
                                      _lastNameController.text = lastName;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.mail_outline,
                                color: kGreyColor,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: _emailLabel ? 7 : 14,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _emailAddressNode,
                                    controller: _emailAddressController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          _emailLabel = true;
                                        });
                                      } else {
                                        setState(() {
                                          _emailAddressLabelValue = 'Home';
                                          _emailLabel = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                _emailLabel
                                    ? SizedBox(
                                        width: 12,
                                      )
                                    : SizedBox.shrink(),
                                _emailLabel
                                    ? Expanded(
                                        flex: 7,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                              labelText: 'Label',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 6.0)),
                                          value: _emailAddressLabelValue,
                                          focusNode: _emailAddressLabelNode,
                                          hint: Text('Label'),
                                          items: <String>[
                                            'Home',
                                            'Work',
                                            'Other'
                                          ]
                                              .map((label) => DropdownMenuItem(
                                                    child: Text(
                                                      label,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    value: label,
                                                  ))
                                              .toList(),
                                          onChanged: isPreview
                                              ? null
                                              : (value) {
                                                  //print(value);
                                                  if (farmerDoc == null) {
                                                  } else {
                                                    if (value ==
                                                        emailAddressLabel) {
                                                      setState(() {
                                                        changeHappened = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        changeHappened = true;
                                                      });
                                                    }
                                                  }
                                                  setState(() {
                                                    _emailAddressLabelValue =
                                                        value!;
                                                  });
                                                },
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                HasFocus(
                                  hasFocus:
                                      _emailHasFocus || _emailLabelHasFocus,
                                  onPressFnc: () {
                                    if (farmerDoc == null) {
                                      setState(() {
                                        _emailLabel = false;
                                      });
                                      _emailAddressController.clear();
                                      _emailAddressLabelValue = 'Home';
                                      _emailAddressNode.requestFocus();
                                    } else {
                                      setState(() {
                                        _emailLabel = true;
                                        _emailAddressController.text =
                                            emailAddress;
                                        _emailAddressLabelValue =
                                            emailAddressLabel;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.phone_outlined,
                                color: kGreyColor,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: _phoneLabel ? 7 : 14,
                                  child: Row(
                                    children: [
                                      PopupMenuButton(
                                        enabled: !isPreview,
                                        tooltip: 'Select Country',
                                        onSelected: (c) {
                                          if (farmerDoc == null) {
                                          } else {
                                            if (c == phoneNumberCode) {
                                              setState(() {
                                                changeHappened = false;
                                              });
                                            } else {
                                              setState(() {
                                                changeHappened = true;
                                              });
                                            }
                                          }
                                          setState(() {
                                            farmerDoc == null
                                                ? _phoneNumberController
                                                    .text = countryList
                                                        .where((element) =>
                                                            element["code"] ==
                                                            c.toString())
                                                        .toList()
                                                        .first['dial_code']
                                                        .toString() +
                                                    ' '
                                                : phoneNumber.toString();
                                            _addressCountryValue = countryList
                                                .where((element) =>
                                                    element["code"] ==
                                                    c.toString())
                                                .toList()
                                                .first['name']
                                                .toString();
                                            _phoneNumberCodeValue =
                                                c.toString();
                                            _phoneNumberNode.requestFocus();
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Image(
                                                width: 24.0,
                                                image: AssetImage(
                                                    'assets/flags/$_phoneNumberCodeValue.png')),
                                            Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                        itemBuilder: (context) => countryList
                                            .map(
                                              (c) => PopupMenuItem(
                                                value: c['code'],
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                          width: 24.0,
                                                          image: AssetImage(
                                                              'assets/flags/${c['code']}.png')),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Text(
                                                        c['name'].toString(),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Text(
                                                        c['dial_code']
                                                            .toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          enabled: !isPreview,
                                          focusNode: _phoneNumberNode,
                                          controller: _phoneNumberController,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
                                            isDense: true,
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              setState(() {
                                                _phoneLabel = true;
                                              });
                                            } else {
                                              setState(() {
                                                _phoneNumberLabelValue =
                                                    'Mobile';
                                                _phoneLabel = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _phoneLabel
                                    ? SizedBox(
                                        width: 12,
                                      )
                                    : SizedBox.shrink(),
                                _phoneLabel
                                    ? Expanded(
                                        flex: 7,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                              labelText: 'Label',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 6.0)),
                                          value: _phoneNumberLabelValue,
                                          focusNode: _phoneNumberLabelNode,
                                          hint: Text('Label'),
                                          items: <String>[
                                            'Mobile',
                                            'Home',
                                            'Work',
                                            'Other'
                                          ]
                                              .map((label) => DropdownMenuItem(
                                                    child: Text(
                                                      label,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    value: label,
                                                  ))
                                              .toList(),
                                          onChanged: isPreview
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _phoneNumberLabelValue =
                                                        value!;
                                                  });
                                                },
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                HasFocus(
                                  hasFocus:
                                      _phoneHasFocus || _phoneLabelHasFocus,
                                  onPressFnc: () {
                                    setState(() {
                                      _phoneLabel = false;
                                    });
                                    _phoneNumberNode.requestFocus();
                                    _phoneNumberController.text = '+91';
                                    _phoneNumberLabelValue = 'Mobile';
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.location_on_outlined,
                                color: kGreyColor,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _addressStreetFocusNode,
                                    controller: _addressStreetController,
                                    decoration: InputDecoration(
                                      labelText: 'Street address',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _surveyNumberFocusNode,
                                    controller: _surveyNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Survey number',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                HasFocus(
                                  hasFocus: _streetHasFocus,
                                  onPressFnc: () {
                                    _addressStreetController.clear();
                                    _surveyNumberController.clear();
                                    _addressStreetFocusNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: SizedBox.shrink(),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: _pincodeLabel ? 7 : 14,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _addressPincodeNode,
                                    controller: _addressPincodeController,
                                    decoration: InputDecoration(
                                      labelText: 'Pincode',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {
                                      if (value.length == 6) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: SizedBox(
                                                  width: 720,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                        setState(() {
                                          _addressPincodeController.text =
                                              value;
                                        });
                                        _areaOptions.clear();
                                        _pincodeResults.clear();
                                        fetchPlace(value).then(
                                          (value) {
                                            if (value.first.status ==
                                                'Success') {
                                              List<dynamic>.from(
                                                value.map(
                                                  (x) => List<dynamic>.from(
                                                    x.postOffice!.map(
                                                      (y) {
                                                        setState(() {
                                                          //print(_pincodeResults);
                                                          _pincodeResults
                                                              .add(y.toJson());
                                                          _areaOptions
                                                              .add(y.name);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                              return true;
                                            } else {
                                              print(value.first.status);
                                              return false;
                                            }
                                          },
                                        ).then((value) {
                                          if (value) {
                                            _pincodeAddressLabelValue =
                                                _areaOptions.first.toString();
                                            _addressTalukController.text =
                                                _pincodeResults.first.values
                                                    .elementAt(8)
                                                    .toString();
                                            _addressCityController.text =
                                                _pincodeResults.first.values
                                                    .elementAt(5)
                                                    .toString();
                                            _addressStateController.text =
                                                _pincodeResults.first.values
                                                    .elementAt(9)
                                                    .toString();
                                            _addressAreaController.clear();
                                            setState(() {
                                              _pincodeLabel = true;
                                              _pincodeManualLabel = false;
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              _pincodeLabel = true;
                                              _pincodeManualLabel = true;
                                            });
                                            Navigator.pop(context);
                                          }
                                        });
                                      } else {
                                        _addressAreaController.clear();
                                        _addressTalukController.clear();
                                        _addressCityController.clear();
                                        _addressStateController.clear();
                                        setState(() {
                                          _pincodeLabel = false;
                                          _pincodeManualLabel = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                _pincodeLabel
                                    ? SizedBox(
                                        width: 12,
                                      )
                                    : SizedBox.shrink(),
                                _pincodeLabel
                                    ? Expanded(
                                        flex: 7,
                                        child: _pincodeManualLabel
                                            ? TextFormField(
                                                enabled: !isPreview,
                                                focusNode:
                                                    _addressAreaFocusNode,
                                                controller:
                                                    _addressAreaController,
                                                decoration: InputDecoration(
                                                  labelText: 'Area',
                                                  isDense: true,
                                                ),
                                                onChanged: (value) {},
                                              )
                                            : DropdownButtonFormField(
                                                isExpanded: true,
                                                decoration: InputDecoration(
                                                    labelText: 'Area',
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6.0)),
                                                focusNode:
                                                    _addressPincodeLabelNode,
                                                value:
                                                    _pincodeAddressLabelValue,
                                                hint: Text('Label'),
                                                items: _areaOptions
                                                    .map((label) =>
                                                        DropdownMenuItem(
                                                          child: Text(
                                                            label,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          value: label,
                                                        ))
                                                    .toList(),
                                                onChanged: isPreview
                                                    ? null
                                                    : (value) {
                                                        setState(() {
                                                          var tempPin = _pincodeResults
                                                              .where((element) =>
                                                                  element[
                                                                      'Name'] ==
                                                                  value
                                                                      .toString())
                                                              .toList();
                                                          _addressTalukController
                                                                  .text =
                                                              tempPin.first[
                                                                      'Block']
                                                                  .toString();
                                                          _addressCityController
                                                                  .text =
                                                              tempPin.first[
                                                                      'District']
                                                                  .toString();
                                                          _addressStateController
                                                                  .text =
                                                              tempPin.first[
                                                                      'State']
                                                                  .toString();
                                                          _pincodeAddressLabelValue =
                                                              value.toString();
                                                        });
                                                      },
                                              ),
                                      )
                                    : SizedBox.shrink(),
                                HasFocus(
                                  hasFocus:
                                      _pincodeHasFocus || _pincodeLabelHasFocus,
                                  onPressFnc: () {
                                    setState(() {
                                      _pincodeLabel = false;
                                      _pincodeManualLabel = false;
                                    });
                                    _addressPincodeController.clear();
                                    _addressPincodeNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: SizedBox.shrink(),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _addressTalukFocusNode,
                                    controller: _addressTalukController,
                                    decoration: InputDecoration(
                                      labelText: 'Taluk',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _addressCityFocusNode,
                                    controller: _addressCityController,
                                    decoration: InputDecoration(
                                      labelText: 'City',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                HasFocus(
                                  hasFocus: _talukHasFocus,
                                  onPressFnc: () {
                                    _addressTalukController.clear();
                                    _addressCityController.clear();
                                    _addressTalukFocusNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: SizedBox.shrink(),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 14,
                                  child: TextFormField(
                                    enabled: !isPreview,
                                    focusNode: _addressStateFocusNode,
                                    controller: _addressStateController,
                                    decoration: InputDecoration(
                                      labelText: 'State',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                                HasFocus(
                                  hasFocus: _stateHasFocus,
                                  onPressFnc: () {
                                    _addressStateController.clear();
                                    _addressStateFocusNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.transparent),
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: SizedBox.shrink(),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 14,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'Country',
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 6.0),
                                    ),
                                    value: _addressCountryValue,
                                    focusNode: _addressCountryNode,
                                    items: countryList
                                        .map((label) => DropdownMenuItem(
                                              child: Text(
                                                label['name'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              value: label['name'],
                                            ))
                                        .toList(),
                                    onChanged: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _addressCountryValue =
                                                  value.toString();
                                            });
                                          },
                                  ),
                                ),
                                HasFocus(
                                  hasFocus: _countryHasFocus,
                                  onPressFnc: () {
                                    _addressCountryValue = 'India';
                                    _addressCountryNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(fixedSize: Size(76, 36)),
                onPressed: () {
                  _formKey.currentState!.reset();
                  Navigator.pop(context, true);
                },
                child: Text('Cancel'),
              ),
              isPreview
                  ? SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: changeHappened
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                var farmerData = jsonEncode({
                                  "fields": {
                                    "firstName": {
                                      "stringValue": _firstNameController.text
                                    },
                                    "lastName": {
                                      "stringValue": _lastNameController.text
                                    },
                                    "emailAddress": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "emailAddress": {
                                                  "stringValue":
                                                      _emailAddressController
                                                          .text
                                                },
                                                "emailPrimary": {
                                                  "booleanValue": true
                                                },
                                                "emailLabel": {
                                                  "stringValue":
                                                      _emailAddressLabelValue
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "phoneNumber": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "phoneNumber": {
                                                  "stringValue":
                                                      _phoneNumberController
                                                          .text
                                                },
                                                "phoneLabel": {
                                                  "stringValue":
                                                      _phoneNumberLabelValue
                                                },
                                                "phoneExtension": {
                                                  "stringValue":
                                                      _phoneNumberCodeValue
                                                },
                                                "phonePrimary": {
                                                  "booleanValue": true
                                                },
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "farmerNumber": {
                                      "stringValue": 'AFN' +
                                          DateFormat("yyyyMMddkkmmss")
                                              .format(DateTime.now())
                                              .toString()
                                    },
                                    "farmerCreatedAt": {
                                      "timestampValue": DateTime.now()
                                          .toUtc()
                                          .toIso8601String()
                                    },
                                    "farmerCreatedBy": {
                                      "stringValue":
                                          "Y3B6AadviKsLu0QZbHoANIYyjqyy"
                                    },
                                    "farmerModifiedAt": {
                                      "timestampValue": DateTime.now()
                                          .toUtc()
                                          .toIso8601String()
                                    },
                                    "farmerModifiedBy": {
                                      "stringValue":
                                          "Y3B6AadviKsLu0QZbHoANIYyjqyy"
                                    },
                                    "addressDetails": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "addressPrimary": {
                                                  "booleanValue": true
                                                },
                                                "addressStreet": {
                                                  "stringValue":
                                                      _addressStreetController
                                                          .text
                                                },
                                                "surveyNumber": {
                                                  "stringValue":
                                                      _surveyNumberController
                                                          .text
                                                },
                                                "addressPincode": {
                                                  "stringValue":
                                                      _addressPincodeController
                                                          .text
                                                },
                                                "addressArea": {
                                                  "stringValue": _pincodeManualLabel
                                                      ? _addressAreaController
                                                          .text
                                                      : _pincodeAddressLabelValue
                                                },
                                                "addressTaluk": {
                                                  "stringValue":
                                                      _addressTalukController
                                                          .text
                                                },
                                                "addressCity": {
                                                  "stringValue":
                                                      _addressCityController
                                                          .text
                                                },
                                                "addressState": {
                                                  "stringValue":
                                                      _addressStateController
                                                          .text
                                                },
                                                "addressCountry": {
                                                  "stringValue":
                                                      _addressCountryValue
                                                },
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "farmerUID": {"stringValue": "dummyUID"},
                                    "farmerRefresh": {
                                      "stringValue": "dummyToken"
                                    },
                                    "profilePicture": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "picturePrimary": {
                                                  "booleanValue": true
                                                },
                                                "pictureUrl": {
                                                  "stringValue": profileUrl
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                });
                                if (profilePicture == true &&
                                    profilePictureFetch == true) {
                                  http
                                      .get(Uri.parse(
                                          'https://avatars.abstractapi.com/v1/?api_key=360fec028832451fb1f633691148554c&name=${_firstNameController.text}%20${_lastNameController.text}&image_format=png&background_color=d6e3e9&font_color=2e4752&font_size=0.7&is_uppercase=true&image_size=256'))
                                      .then((value) {
                                    setState(() {
                                      profilePictureSource = value.bodyBytes;
                                    });
                                  }).then((value) {
                                    createFarmer(
                                        farmerDoc,
                                        farmerData,
                                        docRef,
                                        profilePictureFetch,
                                        profilePictureSource,
                                        farmerDoc == null
                                            ? false
                                            : _emailAddressController.text ==
                                                emailAddress,
                                        farmerDoc == null
                                            ? false
                                            : _firstNameController.text ==
                                                    firstName &&
                                                _lastNameController.text ==
                                                    lastName,
                                        farmerDoc == null
                                            ? false
                                            : farmerDoc
                                                .profilePicture
                                                .mapValue
                                                .fields
                                                .mn0
                                                .mapValue
                                                .fields
                                                .mnM1
                                                .booleanValue);
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  //print(profilePictureSource);
                                  //print(profilePictureSource.length);
                                  createFarmer(
                                      farmerDoc,
                                      farmerData,
                                      docRef,
                                      profilePictureFetch,
                                      profilePictureFetch == true
                                          ? profilePictureSource
                                          : null,
                                      farmerDoc == null
                                          ? false
                                          : _emailAddressController.text ==
                                              emailAddress,
                                      farmerDoc == null
                                          ? false
                                          : _firstNameController.text ==
                                                  firstName &&
                                              _lastNameController.text ==
                                                  lastName,
                                      farmerDoc == null
                                          ? true
                                          : farmerDoc
                                              .profilePicture
                                              .mapValue
                                              .fields
                                              .mn0
                                              .mapValue
                                              .fields
                                              .mnM1
                                              .booleanValue);
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          : null,
                      child: Text('Submit'),
                    ),
            ],
          );
        });
      }).then((value) {
    return true;
  });
}

class HasFocus extends StatelessWidget {
  final bool hasFocus;
  final Function() onPressFnc;
  const HasFocus({Key? key, required this.hasFocus, required this.onPressFnc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasFocus
        ? Expanded(
            flex: 1,
            child: IconButton(
              onPressed: onPressFnc,
              icon: Icon(
                Icons.clear,
                color: kGreyColor,
                size: 18.0,
              ),
            ),
          )
        : Expanded(child: Container());
  }
}

Widget _customDropDownExample(
    BuildContext context, item, String itemDesignation) {
  if (item == null) {
    return Container();
  }

  return Container(
    child: (item.avatar == null)
        ? ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(),
            title: Text("No item selected"),
          )
        : ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              // this does not work - throws 404 error
              backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
            title: Text(item.name),
            subtitle: Text(
              item.createdAt.toString(),
            ),
          ),
  );
}

Widget _customPopupItemBuilderExample(
    BuildContext context, item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item),
      subtitle: Text(item),
      leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
          ),
    ),
  );
}

Future<List<UserModel>> getData(filter) async {
  var response = await Dio().get(
    "https://5d85ccfb1e61af001471bf60.mockapi.io/user",
    queryParameters: {"filter": filter},
  );

  final data = response.data;
  if (data != null) {
    return UserModel.fromJsonList(data);
  }

  return [];
}

Future<List<Place>> fetchPlace(pincode) async {
  final response = await http
      .get(Uri.parse('https://api.postalpincode.in/pincode/$pincode'));
  return PlaceFromJson(response.body);
}

Future<void> createFarmer(farmerDoc, farmerData, docRef, bool photoChanged,
    photoData, bool emailChanged, bool nameChanged, bool isPrimary) async {
  if (farmerDoc == null) {
    await http
        .post(
      Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o?name=agrigoDir%2FfarmerProfilePictures%2F${jsonDecode(farmerData)['fields']['farmerNumber']['stringValue']}.jpg'),
      headers: <String, String>{
        'Content-Type': 'image/jpeg',
      },
      body: photoData,
    )
        .then((responseStorage) async {
      await http
          .post(
              Uri.parse(
                  'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
              //https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "email":
                    "${jsonDecode(farmerData)['fields']['emailAddress']['mapValue']['fields']['0']['mapValue']['fields']['emailAddress']['stringValue']}",
                "password": "Agrigo@KIA",
                "returnSecureToken": false
              }))
          .then((responseAuth) async {
        await http
            .post(
                Uri.parse(
                    'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
                //https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ
                headers: <String, String>{
                  'Content-Type': 'application/json',
                },
                body: json.encode({
                  "idToken": jsonDecode(responseAuth.body)['idToken'],
                  "displayName":
                      "${jsonDecode(farmerData)['fields']['firstName']['stringValue']} ${jsonDecode(farmerData)['fields']['lastName']['stringValue']}",
                  "photoUrl":
                      "https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2F${jsonDecode(farmerData)['fields']['farmerNumber']['stringValue']}.jpg?alt=media",
                  "returnSecureToken": false
                }))
            .then((responseProfile) async {
          await http
              .post(
            Uri.parse(
                'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents/farmers'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: farmerData,
          )
              .then((responseFireStore) async {
            var uidData = jsonEncode({
              "fields": {
                "farmerUID": {
                  "stringValue": jsonDecode(responseAuth.body)['localId']
                },
                "farmerRefresh": {
                  "stringValue": jsonDecode(responseAuth.body)['refreshToken']
                },
                "profilePicture": {
                  "mapValue": {
                    "fields": {
                      "0": {
                        "mapValue": {
                          "fields": {
                            "picturePrimary": {"booleanValue": isPrimary},
                            "pictureUrl": {
                              "stringValue":
                                  'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2F${jsonDecode(farmerData)['fields']['farmerNumber']['stringValue']}.jpg?alt=media'
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            });
            await http.patch(
              Uri.parse(
                  'http://localhost:8080/v1/${jsonDecode(responseFireStore.body)['name']}?updateMask.fieldPaths=farmerUID&updateMask.fieldPaths=farmerRefresh&updateMask.fieldPaths=profilePicture'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: uidData,
            );
          });
        });
      });
    });
  } else {
    if (photoChanged) {
      await http
          .post(
        Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o?name=agrigoDir%2FfarmerProfilePictures%2F${farmerDoc.farmerNumber.stringValue}.jpg'),
        headers: <String, String>{
          'Content-Type': 'image/jpeg',
        },
        body: photoData,
      )
          .then((responseStorage) async {
        var picData = jsonEncode({
          "fields": {
            "profilePicture": {
              "mapValue": {
                "fields": {
                  "0": {
                    "mapValue": {
                      "fields": {
                        "picturePrimary": {"booleanValue": true},
                        "pictureUrl": {
                          "stringValue":
                              'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2F${farmerDoc.farmerNumber.stringValue}.jpg?alt=media'
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        });
        await http.patch(
          Uri.parse(
              'http://localhost:8080/v1/$docRef?updateMask.fieldPaths=profilePicture'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: picData,
        );
      }).then((responseFire) => {});
    }
    if (!emailChanged) {
      await http
          .post(
        Uri.parse(
            'http://localhost:9099/securetoken.googleapis.com/v1/token?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            'grant_type=refresh_token&refresh_token=${farmerDoc.farmerRefresh.stringValue}',
      )
          .then((responseToken) async {
        await http
            .post(
              Uri.parse(
                  'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "idToken": jsonDecode(responseToken.body)['id_token'],
                "displayName":
                    '${jsonDecode(farmerData)['fields']['firstName']['stringValue']} ${jsonDecode(farmerData)['fields']['lastName']['stringValue']}',
                "photoUrl":
                    'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o?name=agrigoDir%2FfarmerProfilePictures%2F${farmerDoc.farmerNumber.stringValue}.jpg',
                "email": jsonDecode(farmerData)['fields']['emailAddress']
                        ['mapValue']['fields']['0']['mapValue']['fields']
                    ['emailAddress']['stringValue'],
                "returnSecureToken": false
              }),
            )
            .then((responseAuth) {});
      });
    }
    if (!nameChanged && emailChanged) {
      await http
          .post(
        Uri.parse(
            'http://localhost:9099/securetoken.googleapis.com/v1/token?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            'grant_type=refresh_token&refresh_token=${farmerDoc.farmerRefresh.stringValue}',
      )
          .then((responseToken) async {
        await http
            .post(
              Uri.parse(
                  'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "idToken": jsonDecode(responseToken.body)['id_token'],
                "displayName":
                    '${jsonDecode(farmerData)['fields']['firstName']['stringValue']} ${jsonDecode(farmerData)['fields']['lastName']['stringValue']}',
                "returnSecureToken": false
              }),
            )
            .then((responseAuth) {});
      });
    }
    if (isPrimary == false && photoChanged == false) {
      await http
          .get(Uri.parse(
              'https://avatars.abstractapi.com/v1/?api_key=360fec028832451fb1f633691148554c&name=${_firstNameController.text}%20${_lastNameController.text}&image_format=png&background_color=d6e3e9&font_color=2e4752&font_size=0.7&is_uppercase=true&image_size=256'))
          .then((value) async {
        await http
            .post(
              Uri.parse(
                  'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o?name=agrigoDir%2FfarmerProfilePictures%2F${farmerDoc.farmerNumber.stringValue}.jpg'),
              headers: <String, String>{
                'Content-Type': 'image/jpeg',
              },
              body: value.bodyBytes,
            )
            .then((responseStorage) {});
      });
    }
    await http.patch(
      Uri.parse(
          'http://localhost:8080/v1/$docRef?updateMask.fieldPaths=firstName&updateMask.fieldPaths=lastName&updateMask.fieldPaths=emailAddress&updateMask.fieldPaths=phoneNumber&updateMask.fieldPaths=addressDetails&updateMask.fieldPaths=farmerModifiedAt&updateMask.fieldPaths=farmerModifiedBy'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: farmerData,
    );
  }
}

//
// Future<List<Photo>> fetchPhotos(http.Client client) async {
//   final response = await client
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
//
//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parsePhotos, response.body);
// }
//
// // A function that converts a response body into a List<Photo>.
// List<Photo> parsePhotos(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//
//   return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
// }
//
// class Photo {
//   final int albumId;
//   final int id;
//   final String title;
//   final String url;
//   final String thumbnailUrl;
//
//   Photo({
//     required this.albumId,
//     required this.id,
//     required this.title,
//     required this.url,
//     required this.thumbnailUrl,
//   });
//
//   factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(
//       albumId: json['albumId'] as int,
//       id: json['id'] as int,
//       title: json['title'] as String,
//       url: json['url'] as String,
//       thumbnailUrl: json['thumbnailUrl'] as String,
//     );
//   }
// }
//
// class Album {
//   final String male;
//   final String female;
//
//   Album({
//     required this.male,
//     required this.female,
//   });
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       male: json['documents']['fields']['male']['stringValue'],
//       female: json['documents']['fields']['female']['stringValue'],
//     );
//   }
// }
//
// class Data {
//   final String emailAddress;
//   final String emailSubject;
//   final String emailBody;
//
//   Data({
//     required this.emailAddress,
//     required this.emailSubject,
//     required this.emailBody,
//   });
//
//   postData() {
//     print(emailAddress + emailSubject + emailBody);
//     return emailAddress;
//   }
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//         emailBody: json['emailBody'],
//         emailAddress: json['emailAddress'],
//         emailSubject: json['emailSubject']);
//   }
// }
//
// Future<Album> fetchData() async {
//   final response = await http.get(Uri.parse(
//       'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents/count'));
//
//   //https://firestore.googleapis.com/v1beta1/projects/coun-ab246/databases/(default)/documents/count?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     print(jsonDecode(response.body));
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
//
// Future<Data> createData(String title) async {
//   final response = await http.post(
//     Uri.parse(
//         'https://prod-28.centralindia.logic.azure.com:443/workflows/73e6006cff164427ace8620b28dede03/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zdu9N5i-mEx3Tk02O1MrEeS8Py6_9h48tA6YYOzBQnw'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'emailaddress': title,
//       'emailSubject': title,
//       'emailBody': title,
//     }),
//   );
//
//   if (response.statusCode == 202) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     print(jsonDecode('data'));
//     return Data.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     print(response.reasonPhrase);
//     throw Exception('Failed to create album.');
//   }
// }
//
// class PhotosList extends StatelessWidget {
//   final List<Photo> photos;
//
//   PhotosList({Key? key, required this.photos}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         return Image.network(photos[index].thumbnailUrl);
//       },
//     );
//   }
// }
