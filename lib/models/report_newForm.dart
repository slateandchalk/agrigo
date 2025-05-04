import 'dart:convert';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//Details
final TextEditingController _farmerNameController = TextEditingController();
final TextEditingController _reportNumberController = TextEditingController();
final TextEditingController _surveyNumberController = TextEditingController();
final TextEditingController _farmerAddressController = TextEditingController();

//Soil Standard
final TextEditingController _ssEC1Controller = TextEditingController();
final TextEditingController _ssEC2Controller = TextEditingController();
final TextEditingController _ssEC3Controller = TextEditingController();
final TextEditingController _ssPH1Controller = TextEditingController();
final TextEditingController _ssPH2Controller = TextEditingController();
final TextEditingController _ssPH3Controller = TextEditingController();

//Soil Test Results
final TextEditingController _strO1Controller = TextEditingController();
final TextEditingController _strO2Controller = TextEditingController();
final TextEditingController _strO3Controller = TextEditingController();
final TextEditingController _strN1Controller = TextEditingController();
final TextEditingController _strN2Controller = TextEditingController();
final TextEditingController _strN3Controller = TextEditingController();
final TextEditingController _strP1Controller = TextEditingController();
final TextEditingController _strP2Controller = TextEditingController();
final TextEditingController _strP3Controller = TextEditingController();
final TextEditingController _strK1Controller = TextEditingController();
final TextEditingController _strK2Controller = TextEditingController();
final TextEditingController _strK3Controller = TextEditingController();

//Open Fields
final TextEditingController _opCcController = TextEditingController();
final TextEditingController _opFsController = TextEditingController();

//Macro Nutrients
final TextEditingController _mnN1Controller = TextEditingController();
List<String> mnN2Choose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnN2Controller = mnN2Choose.first;
final TextEditingController _mnN3Controller = TextEditingController();
final TextEditingController _mnN4Controller = TextEditingController();
final TextEditingController _mnP1Controller = TextEditingController();
List<String> mnP2Choose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnP2Controller = mnP2Choose.first;
final TextEditingController _mnP3Controller = TextEditingController();
final TextEditingController _mnP4Controller = TextEditingController();
final TextEditingController _mnK1Controller = TextEditingController();
List<String> mnK2Choose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnK2Controller = mnK2Choose.first;
final TextEditingController _mnK3Controller = TextEditingController();
final TextEditingController _mnK4Controller = TextEditingController();

//Macro Nutrients
List<String> mnFeChoose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnFeController = mnFeChoose.first;
List<String> mnMnChoose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnMnController = mnMnChoose.first;
List<String> mnZnChoose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnZnController = mnZnChoose.first;
List<String> mnCuChoose = [
  "Choose",
  "Calcium",
  "Inhibitors",
  "Magnesium",
  "Micro Nutrient",
  "Nitrogen",
  "Potassium",
  "Phosphorus",
  "Sulphur",
  "Urea"
];
//String _mnCuController = mnCuChoose.first;

// ignore: non_constant_identifier_names
Future<bool> reportNewDialog(
    BuildContext context, reportDoc, isPreview, farmerDoc, sampleDoc, String sampleRef, isDraft) async {
  return await showDialog(
      context: context,
      builder: (context) {
        bool changeHappened = false;
        //
        List<bool> ccChecked;
        List<bool> ccCheck;
        late double ssEC1;
        late double ssEC2;
        late double ssEC3;
        late double ssPH1;
        late double ssPH2;
        late double ssPH3;
        //
        late double strO1;
        late double strO2;
        late double strO3;
        late double strN1;
        late double strN2;
        late double strN3;
        late double strP1;
        late double strP2;
        late double strP3;
        late double strK1;
        late double strK2;
        late double strK3;
        //
        List<bool> feChecked;
        List<bool> feCheck;
        List<bool> mnChecked;
        List<bool> mnCheck;
        List<bool> znChecked;
        List<bool> znCheck;
        List<bool> cuChecked;
        List<bool> cuCheck;
        //
        late String opCc;
        late String opFs;
        //
        late double mnN1;
        late String mnN2;
        String _mnN2Controller;
        late double mnN3;
        late double mnN4;
        late double mnP1;
        late String mnP2;
        String _mnP2Controller;
        late double mnP3;
        late double mnP4;
        late double mnK1;
        late String mnK2;
        String _mnK2Controller;
        late double mnK3;
        late double mnK4;
        //
        String _mnFeController;
        late String mnFe;
        String _mnMnController;
        late String mnMn;
        String _mnZnController;
        late String mnZn;
        String _mnCuController;
        late String mnCu;
        if (reportDoc == null) {
          //
          ccChecked = [false, false, false];
          ccCheck = [false, false, false];
          _ssEC1Controller.clear();
          _ssEC2Controller.clear();
          _ssEC3Controller.clear();
          _ssPH1Controller.clear();
          _ssPH2Controller.clear();
          _ssPH3Controller.clear();
          //
          _strO1Controller.clear();
          _strO2Controller.clear();
          _strO3Controller.clear();
          _strN1Controller.clear();
          _strN2Controller.clear();
          _strN3Controller.clear();
          _strP1Controller.clear();
          _strP2Controller.clear();
          _strP3Controller.clear();
          _strK1Controller.clear();
          _strK2Controller.clear();
          _strK3Controller.clear();
          //
          feChecked = [false, false, false];
          feCheck = [false, false, false];
          mnChecked = [false, false, false];
          mnCheck = [false, false, false];
          znChecked = [false, false, false];
          znCheck = [false, false, false];
          cuChecked = [false, false, false];
          cuCheck = [false, false, false];
          //
          _opCcController.clear();
          _opFsController.clear();
          //
          _mnN1Controller.clear();
          _mnN2Controller = mnN2Choose.first;
          _mnN3Controller.clear();
          _mnN4Controller.clear();
          _mnP1Controller.clear();
          _mnP2Controller = mnP2Choose.first;
          _mnP3Controller.clear();
          _mnP4Controller.clear();
          _mnK1Controller.clear();
          _mnK2Controller = mnK2Choose.first;
          _mnK3Controller.clear();
          _mnK4Controller.clear();
          //
          _mnFeController = mnFeChoose.first;
          _mnMnController = mnMnChoose.first;
          _mnZnController = mnZnChoose.first;
          _mnCuController = mnCuChoose.first;
        } else {
          //
          var ad = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue.fields;
          _farmerNameController.text = farmerDoc.firstName.stringValue + ' ' + farmerDoc.lastName.stringValue;
          _reportNumberController.text = reportDoc.fields.reportNumber.stringValue;
          _surveyNumberController.text = ad.eaM1.stringValue;
          _farmerAddressController.text = ad.eaM0.stringValue +
              ', ' +
              ad.eaM4.stringValue +
              ' (Taluk), ' +
              ad.eaM3.stringValue +
              ', ' +
              ad.eaM5.stringValue +
              ', ' +
              ad.eaM6.stringValue +
              ' ' +
              ad.eaM2.stringValue;
          //
          var cc = reportDoc.fields.soilStandard.mapValue.fields.ss0.mapValue.fields;
          ccCheck = [cc.ssM0.booleanValue, cc.ssM1.booleanValue, cc.ssM2.booleanValue];
          ccChecked = [cc.ssM0.booleanValue, cc.ssM1.booleanValue, cc.ssM2.booleanValue];
          ssEC1 = cc.ssM3.doubleValue;
          _ssEC1Controller.text = ssEC1.toString();
          ssEC2 = cc.ssM4.doubleValue;
          _ssEC2Controller.text = ssEC2.toString();
          ssEC3 = cc.ssM5.doubleValue;
          _ssEC3Controller.text = ssEC3.toString();
          ssPH1 = cc.ssM6.doubleValue;
          _ssPH1Controller.text = ssPH1.toString();
          ssPH2 = cc.ssM7.doubleValue;
          _ssPH2Controller.text = ssPH2.toString();
          ssPH3 = cc.ssM8.doubleValue;
          _ssPH3Controller.text = ssPH3.toString();
          //
          var o = reportDoc.fields.soilTestResults.mapValue.fields.macroNutrients.mapValue.fields.smn0.mapValue.fields;
          strO1 = o.mnS0.doubleValue;
          _strO1Controller.text = strO1.toString();
          strO2 = o.mnS1.doubleValue;
          _strO2Controller.text = strO2.toString();
          strO3 = o.mnS2.doubleValue;
          _strO3Controller.text = strO3.toString();
          var n = reportDoc.fields.soilTestResults.mapValue.fields.macroNutrients.mapValue.fields.smn1.mapValue.fields;
          strN1 = n.mnS0.doubleValue;
          _strN1Controller.text = strN1.toString();
          strN2 = n.mnS1.doubleValue;
          _strN2Controller.text = strN2.toString();
          strN3 = n.mnS2.doubleValue;
          _strN3Controller.text = strN3.toString();
          var p = reportDoc.fields.soilTestResults.mapValue.fields.macroNutrients.mapValue.fields.smn2.mapValue.fields;
          strP1 = p.mnS0.doubleValue;
          _strP1Controller.text = strP1.toString();
          strP2 = p.mnS1.doubleValue;
          _strP2Controller.text = strP2.toString();
          strP3 = p.mnS2.doubleValue;
          _strP3Controller.text = strP3.toString();
          var k = reportDoc.fields.soilTestResults.mapValue.fields.macroNutrients.mapValue.fields.smn3.mapValue.fields;
          strK1 = k.mnS0.doubleValue;
          _strK1Controller.text = strK1.toString();
          strK2 = k.mnS1.doubleValue;
          _strK2Controller.text = strK2.toString();
          strK3 = k.mnS2.doubleValue;
          _strK3Controller.text = strK3.toString();
          //
          var fe = reportDoc.fields.soilTestResults.mapValue.fields.microNutrients.mapValue.fields.smi0.mapValue.fields;
          feCheck = [fe.miS0.booleanValue, fe.miS1.booleanValue, fe.miS2.booleanValue];
          feChecked = [fe.miS0.booleanValue, fe.miS1.booleanValue, fe.miS2.booleanValue];
          var mn = reportDoc.fields.soilTestResults.mapValue.fields.microNutrients.mapValue.fields.smi1.mapValue.fields;
          mnCheck = [mn.miS0.booleanValue, mn.miS1.booleanValue, mn.miS2.booleanValue];
          mnChecked = [mn.miS0.booleanValue, mn.miS1.booleanValue, mn.miS2.booleanValue];
          var zn = reportDoc.fields.soilTestResults.mapValue.fields.microNutrients.mapValue.fields.smi2.mapValue.fields;
          znCheck = [zn.miS0.booleanValue, zn.miS1.booleanValue, zn.miS2.booleanValue];
          znChecked = [zn.miS0.booleanValue, zn.miS1.booleanValue, zn.miS2.booleanValue];
          var cu = reportDoc.fields.soilTestResults.mapValue.fields.microNutrients.mapValue.fields.smi3.mapValue.fields;
          cuCheck = [cu.miS0.booleanValue, cu.miS1.booleanValue, cu.miS2.booleanValue];
          cuChecked = [cu.miS0.booleanValue, cu.miS1.booleanValue, cu.miS2.booleanValue];
          //
          opCc = reportDoc.fields.cultivatingCrops.stringValue;
          _opCcController.text = opCc;
          opFs = reportDoc.fields.fertilizerSuggestions.stringValue;
          _opFsController.text = opFs;
          //
          var mnN = reportDoc.fields.macroNutrients.mapValue.fields.mn0.mapValue.fields;
          mnN1 = mnN.mnM0.doubleValue;
          _mnN1Controller.text = mnN1.toString();
          mnN2 = mnN.mnM1.stringValue;
          _mnN2Controller = mnN2;
          mnN3 = mnN.mnM2.doubleValue;
          _mnN3Controller.text = mnN3.toString();
          mnN4 = mnN.mnM3.doubleValue;
          _mnN4Controller.text = mnN4.toString();
          var mnP = reportDoc.fields.macroNutrients.mapValue.fields.mn1.mapValue.fields;
          mnP1 = mnP.mnM0.doubleValue;
          _mnP1Controller.text = mnP1.toString();
          mnP2 = mnP.mnM1.stringValue;
          _mnP2Controller = mnP2;
          mnP3 = mnP.mnM2.doubleValue;
          _mnP3Controller.text = mnP3.toString();
          mnP4 = mnP.mnM3.doubleValue;
          _mnP4Controller.text = mnP4.toString();
          var mnK = reportDoc.fields.macroNutrients.mapValue.fields.mn2.mapValue.fields;
          mnK1 = mnK.mnM0.doubleValue;
          _mnK1Controller.text = mnK1.toString();
          mnK2 = mnK.mnM1.stringValue;
          _mnK2Controller = mnK2;
          mnK3 = mnK.mnM2.doubleValue;
          _mnK3Controller.text = mnK3.toString();
          mnK4 = mnK.mnM3.doubleValue;
          _mnK4Controller.text = mnK4.toString();
          //
          var miN = reportDoc.fields.microNutrients.mapValue.fields;
          mnFe = miN.mi0.mapValue.fields.miM0.stringValue;
          _mnFeController = mnFe;
          mnMn = miN.mi1.mapValue.fields.miM0.stringValue;
          _mnMnController = mnMn;
          mnZn = miN.mi2.mapValue.fields.miM0.stringValue;
          _mnZnController = mnZn;
          mnCu = miN.mi3.mapValue.fields.miM0.stringValue;
          _mnCuController = mnCu;
        }
        return StatefulBuilder(builder: (context, setState) {
          Future.delayed(Duration(microseconds: 1), () {
            if (_formKey.currentState!.validate() == true &&
                (ccChecked[0] == true
                    ? true
                    : ccChecked[1] == true
                        ? true
                        : ccChecked[2] == true
                            ? true
                            : false) &&
                _mnN2Controller != 'Choose' &&
                _mnP2Controller != 'Choose' &&
                _mnK2Controller != 'Choose' &&
                _mnFeController != 'Choose' &&
                _mnMnController != 'Choose' &&
                _mnZnController != 'Choose' &&
                _mnCuController != 'Choose' &&
                (feChecked[0] == true
                    ? true
                    : feChecked[1] == true
                        ? true
                        : feChecked[2] == true
                            ? true
                            : false) &&
                (mnChecked[0] == true
                    ? true
                    : mnChecked[1] == true
                        ? true
                        : mnChecked[2] == true
                            ? true
                            : false) &&
                (znChecked[0] == true
                    ? true
                    : znChecked[1] == true
                        ? true
                        : znChecked[2] == true
                            ? true
                            : false) &&
                (cuChecked[0] == true
                    ? true
                    : cuChecked[1] == true
                        ? true
                        : cuChecked[2] == true
                            ? true
                            : false)) {
              setState(() {
                changeHappened = true;
              });
            } else {
              setState(() {
                changeHappened = false;
              });
            }
          });
          return AlertDialog(
            actionsPadding: isPreview ? EdgeInsets.fromLTRB(0, 8, 8, 8) : EdgeInsets.fromLTRB(0, 8, 18, 8),
            title: reportDoc == null
                ? Text('Create Report')
                : Row(
                    children: [
                      Text('Report Details: ' + reportDoc.fields.reportNumber.stringValue),
                      SizedBox(
                        width: 8,
                      ),
                      isPreview ? Chip(label: Text('Preview')) : SizedBox.shrink(),
                      SizedBox(
                        width: 4,
                      ),
                      !isDraft ? Chip(label: Text('Draft')) : SizedBox.shrink(),
                    ],
                  ),
            scrollable: true,
            content: Form(
              onChanged: reportDoc == null && isPreview == false
                  ? () {
                      //print(ccChecked + feChecked + mnChecked);
                      //print(_formKey.currentState!.validate());
                      if (_formKey.currentState!.validate() == true &&
                          (ccChecked[0] == true
                              ? true
                              : ccChecked[1] == true
                                  ? true
                                  : ccChecked[2] == true
                                      ? true
                                      : false) &&
                          _mnN2Controller != 'Choose' &&
                          _mnP2Controller != 'Choose' &&
                          _mnK2Controller != 'Choose' &&
                          _mnFeController != 'Choose' &&
                          _mnMnController != 'Choose' &&
                          _mnZnController != 'Choose' &&
                          _mnCuController != 'Choose' &&
                          (feChecked[0] == true
                              ? true
                              : feChecked[1] == true
                                  ? true
                                  : feChecked[2] == true
                                      ? true
                                      : false) &&
                          (mnChecked[0] == true
                              ? true
                              : mnChecked[1] == true
                                  ? true
                                  : mnChecked[2] == true
                                      ? true
                                      : false) &&
                          (znChecked[0] == true
                              ? true
                              : znChecked[1] == true
                                  ? true
                                  : znChecked[2] == true
                                      ? true
                                      : false) &&
                          (cuChecked[0] == true
                              ? true
                              : cuChecked[1] == true
                                  ? true
                                  : cuChecked[2] == true
                                      ? true
                                      : false)) {
                        setState(() {
                          changeHappened = true;
                        });
                      } else {
                        setState(() {
                          changeHappened = false;
                        });
                      }
                    }
                  : () {
                      print(_formKey.currentState!.validate());
                      //print(ccChecked);
                      //print(ccCheck);
                      if (_formKey.currentState!.validate() == false ||
                          ccChecked.toString() == ccCheck.toString() &&
                              _ssEC1Controller.text == ssEC1.toString() &&
                              _ssEC2Controller.text == ssEC2.toString() &&
                              _ssEC3Controller.text == ssEC3.toString() &&
                              _ssPH1Controller.text == ssPH1.toString() &&
                              _ssPH2Controller.text == ssPH2.toString() &&
                              _ssPH3Controller.text == ssPH3.toString() &&
                              _strO1Controller.text == strO1.toString() &&
                              _strO2Controller.text == strO2.toString() &&
                              _strO3Controller.text == strO3.toString() &&
                              _strN1Controller.text == strN1.toString() &&
                              _strN2Controller.text == strN2.toString() &&
                              _strN3Controller.text == strN3.toString() &&
                              _strP1Controller.text == strP1.toString() &&
                              _strP2Controller.text == strP2.toString() &&
                              _strP3Controller.text == strP3.toString() &&
                              _strK1Controller.text == strK1.toString() &&
                              _strK2Controller.text == strK2.toString() &&
                              _strK3Controller.text == strK3.toString() &&
                              feChecked.toString() == feCheck.toString() &&
                              mnChecked.toString() == mnCheck.toString() &&
                              znChecked.toString() == znCheck.toString() &&
                              cuChecked.toString() == cuCheck.toString() &&
                              _opCcController.text == opCc &&
                              _opFsController.text == opFs &&
                              _mnN1Controller.text == mnN1.toString() &&
                              _mnN2Controller == mnN2 &&
                              _mnN3Controller.text == mnN3.toString() &&
                              _mnN4Controller.text == mnN4.toString() &&
                              _mnP1Controller.text == mnP1.toString() &&
                              _mnP2Controller == mnP2 &&
                              _mnP3Controller.text == mnP3.toString() &&
                              _mnP4Controller.text == mnP4.toString() &&
                              _mnK1Controller.text == mnK1.toString() &&
                              _mnK2Controller == mnK2 &&
                              _mnK3Controller.text == mnK3.toString() &&
                              _mnK4Controller.text == mnK4.toString() &&
                              _mnFeController == mnFe &&
                              _mnMnController == mnMn &&
                              _mnZnController == mnZn &&
                              _mnCuController == mnCu) {
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
                width: 960,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isPreview
                        ? Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: kReportCellColor),
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text('Farmer Name:'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: TextFormField(
                                            enabled: false,
                                            controller: _farmerNameController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text('Report Number:'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: TextFormField(
                                            enabled: false,
                                            controller: _reportNumberController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text('Survey Number:'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: TextFormField(
                                            enabled: false,
                                            controller: _surveyNumberController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              TableRow(
                                decoration: BoxDecoration(color: kReportCellColor),
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text('Address:'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: TextFormField(
                                            enabled: false,
                                            controller: _farmerAddressController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Soil Standard',
                      style: TextStyle(color: kReportTableColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Table(
                      border: TableBorder.all(color: kReportTableColor),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(120),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableHeaderWidget(
                              tableHeader: 'Soil Texture',
                              rowHeight: 80.0,
                              fontWeight: FontWeight.bold,
                              cellColor: kReportCellColor,
                              textAlign: TextAlign.center,
                            ),
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    Column(
                                      children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Calcium Carbonate',
                                          rowHeight: 40.0,
                                          fontWeight: FontWeight.bold,
                                          cellColor: kReportCellColor,
                                          textAlign: TextAlign.center,
                                        ),
                                        Table(
                                          border: TableBorder.all(
                                            color: kReportTableColor,
                                          ),
                                          children: [
                                            TableRow(children: [
                                              TableHeaderWidget(
                                                tableHeader: 'Nil',
                                                rowHeight: 40.0,
                                                fontWeight: FontWeight.w500,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                              TableHeaderWidget(
                                                tableHeader: 'Medium',
                                                rowHeight: 40.0,
                                                fontWeight: FontWeight.w500,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                              TableHeaderWidget(
                                                tableHeader: 'High',
                                                rowHeight: 40.0,
                                                fontWeight: FontWeight.w500,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ])
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    Column(
                                      children: [
                                        TableHeaderWidget(
                                          tableHeader: 'EC (dSm-1)',
                                          rowHeight: 40.0,
                                          fontWeight: FontWeight.bold,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                        Table(
                                          border: TableBorder.all(
                                            color: kReportTableColor,
                                          ),
                                          children: [
                                            TableRow(
                                              children: [
                                                TableHeaderWidget(
                                                  tableHeader: 'Medium',
                                                  rowHeight: 40.0,
                                                  fontWeight: FontWeight.w500,
                                                  cellColor: Colors.transparent,
                                                  textAlign: TextAlign.center,
                                                ),
                                                TableHeaderWidget(
                                                  tableHeader: 'Good Condition',
                                                  rowHeight: 40.0,
                                                  fontWeight: FontWeight.w500,
                                                  cellColor: Colors.transparent,
                                                  textAlign: TextAlign.center,
                                                ),
                                                TableHeaderWidget(
                                                  tableHeader: 'High',
                                                  rowHeight: 40.0,
                                                  fontWeight: FontWeight.w500,
                                                  cellColor: Colors.transparent,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    Column(
                                      children: [
                                        TableHeaderWidget(
                                          tableHeader: 'pH',
                                          rowHeight: 40.0,
                                          fontWeight: FontWeight.bold,
                                          cellColor: kReportCellColor,
                                          textAlign: TextAlign.center,
                                        ),
                                        Table(
                                          border: TableBorder.all(
                                            color: kReportTableColor,
                                          ),
                                          children: [
                                            TableRow(
                                              children: [
                                                TableHeaderWidget(
                                                  tableHeader: 'Medium Condition',
                                                  rowHeight: 40.0,
                                                  fontWeight: FontWeight.w500,
                                                  cellColor: kReportCellColor,
                                                  textAlign: TextAlign.center,
                                                ),
                                                TableHeaderWidget(
                                                  tableHeader: 'Acid',
                                                  rowHeight: 40.0,
                                                  fontWeight: FontWeight.w500,
                                                  cellColor: kReportCellColor,
                                                  textAlign: TextAlign.center,
                                                ),
                                                TableHeaderWidget(
                                                  tableHeader: 'Alkaline',
                                                  rowHeight: 40.0,
                                                  fontWeight: FontWeight.w500,
                                                  cellColor: kReportCellColor,
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        TableRow(children: [
                          TableHeaderWidget(
                            tableHeader: '',
                            rowHeight: 60.0,
                            fontWeight: FontWeight.bold,
                            cellColor: kReportCellColor,
                            textAlign: TextAlign.center,
                          ),
                          Table(
                            border: TableBorder.all(
                              color: kReportTableColor,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  TableDataCheckFormWidget(
                                      tableData: ccChecked[0],
                                      rowHeight: 60.0,
                                      cellColor: Colors.transparent,
                                      onChangeFnc: isPreview
                                          ? null
                                          : (bool? value) {
                                              setState(() {
                                                ccChecked = onCheckState(1);
                                              });
                                            }),
                                  TableDataCheckFormWidget(
                                    tableData: ccChecked[1],
                                    rowHeight: 60.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              ccChecked = onCheckState(2);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: ccChecked[2],
                                    rowHeight: 60.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              ccChecked = onCheckState(3);
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                              color: kReportTableColor,
                            ),
                            children: [
                              TableRow(children: [
                                TableDataInputWidget(
                                  cellColor: kReportCellColor,
                                  rowHeight: 60.0,
                                  textController: _ssEC1Controller,
                                  textAlign: TextAlign.center,
                                  inputState: isPreview,
                                ),
                                TableDataInputWidget(
                                  cellColor: kReportCellColor,
                                  rowHeight: 60.0,
                                  textController: _ssEC2Controller,
                                  textAlign: TextAlign.center,
                                  inputState: isPreview,
                                ),
                                TableDataInputWidget(
                                  cellColor: kReportCellColor,
                                  rowHeight: 60.0,
                                  textController: _ssEC3Controller,
                                  textAlign: TextAlign.center,
                                  inputState: isPreview,
                                ),
                              ])
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                              color: kReportTableColor,
                            ),
                            children: [
                              TableRow(children: [
                                TableDataInputWidget(
                                  cellColor: Colors.transparent,
                                  rowHeight: 60.0,
                                  textController: _ssPH1Controller,
                                  textAlign: TextAlign.center,
                                  inputState: isPreview,
                                ),
                                TableDataInputWidget(
                                  cellColor: Colors.transparent,
                                  rowHeight: 60.0,
                                  textController: _ssPH2Controller,
                                  textAlign: TextAlign.center,
                                  inputState: isPreview,
                                ),
                                TableDataInputWidget(
                                  cellColor: Colors.transparent,
                                  rowHeight: 60.0,
                                  textController: _ssPH3Controller,
                                  textAlign: TextAlign.center,
                                  inputState: isPreview,
                                ),
                              ])
                            ],
                          ),
                        ])
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Soil Test Results',
                      style: TextStyle(color: kReportTableColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Table(
                            border: TableBorder.all(color: kReportTableColor),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(200),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth(),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          TableHeaderWidget(
                                            tableHeader: 'Macro Nutrients',
                                            rowHeight: 20.0,
                                            fontWeight: FontWeight.bold,
                                            cellColor: kReportCellColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableHeaderWidget(
                                            tableHeader: '(Kilo / Acre)',
                                            rowHeight: 20.0,
                                            fontWeight: FontWeight.normal,
                                            cellColor: kReportCellColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableHeaderWidget(
                                            tableHeader: 'Organic Matters',
                                            rowHeight: 20.0,
                                            fontWeight: FontWeight.normal,
                                            cellColor: kReportCellColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              TableHeaderWidget(
                                                tableHeader: 'Low',
                                                rowHeight: 60.0,
                                                fontWeight: FontWeight.bold,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              TableHeaderWidget(
                                                tableHeader: 'Medium',
                                                rowHeight: 60.0,
                                                fontWeight: FontWeight.bold,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              TableHeaderWidget(
                                                tableHeader: 'High',
                                                rowHeight: 60.0,
                                                fontWeight: FontWeight.bold,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Organic Matters',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'O.C%',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strO1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strO2Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strO3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Nitrogen',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'N',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strN1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strN2Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strN3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Phosphorus',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'P',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strP1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strP2Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strP3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Potassium',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'K',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strK1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strK2Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strK3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Table(
                            border: TableBorder.all(color: kReportTableColor),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(200),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth(),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          TableHeaderWidget(
                                            tableHeader: 'Micro Nutrients',
                                            rowHeight: 30.0,
                                            fontWeight: FontWeight.bold,
                                            cellColor: kReportCellColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableHeaderWidget(
                                            tableHeader: '(Kilo / Acre)',
                                            rowHeight: 30.0,
                                            fontWeight: FontWeight.normal,
                                            cellColor: kReportCellColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              TableHeaderWidget(
                                                tableHeader: 'Low',
                                                rowHeight: 60.0,
                                                fontWeight: FontWeight.bold,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              TableHeaderWidget(
                                                tableHeader: 'Medium',
                                                rowHeight: 60.0,
                                                fontWeight: FontWeight.bold,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              TableHeaderWidget(
                                                tableHeader: 'High',
                                                rowHeight: 60.0,
                                                fontWeight: FontWeight.bold,
                                                cellColor: kReportCellColor,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Iron',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'Fe',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: feChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              feChecked = onCheckState(1);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: feChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              feChecked = onCheckState(2);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: feChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              feChecked = onCheckState(3);
                                            });
                                          },
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Manganese',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'Mn',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: mnChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              mnChecked = onCheckState(1);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: mnChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              mnChecked = onCheckState(2);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: mnChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              mnChecked = onCheckState(3);
                                            });
                                          },
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Zinc',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'Zn',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: znChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              znChecked = onCheckState(1);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: znChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              znChecked = onCheckState(2);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: znChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              znChecked = onCheckState(3);
                                            });
                                          },
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(color: kReportTableColor),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(148),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableHeaderWidget(
                                          tableHeader: 'Copper',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.start,
                                        ),
                                        TableHeaderWidget(
                                          tableHeader: 'Cu',
                                          rowHeight: 30.0,
                                          fontWeight: FontWeight.normal,
                                          cellColor: Colors.transparent,
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: cuChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              cuChecked = onCheckState(1);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: cuChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              cuChecked = onCheckState(2);
                                            });
                                          },
                                  ),
                                  TableDataCheckFormWidget(
                                    tableData: cuChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              cuChecked = onCheckState(3);
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(180),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: kReportCellColor),
                          children: [
                            SizedBox(
                              height: 20.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text('Cultivating Crop:'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                enabled: !isPreview,
                                controller: _opCcController,
                                validator: (v) {
                                  return v!.isNotEmpty ? null : 'false';
                                },
                                decoration: InputDecoration(
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: kReportTableColor, width: 0.5)),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: kReportTableColor, width: 0.5)),
                                  errorStyle: TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: kReportCellColor),
                          children: [
                            SizedBox(
                              height: 20.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text('Fertilizer Suggestions:'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                enabled: !isPreview,
                                controller: _opFsController,
                                validator: (v) {
                                  return v!.isNotEmpty ? null : 'false';
                                },
                                decoration: InputDecoration(
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: kReportTableColor, width: 0.5)),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: kReportTableColor, width: 0.5)),
                                  errorStyle: TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            TableHeaderWidget(
                              tableHeader: 'Macro Nutrients',
                              rowHeight: 20.0,
                              fontWeight: FontWeight.w500,
                              cellColor: Colors.transparent,
                              textAlign: TextAlign.center,
                            ),
                            TableHeaderWidget(
                              tableHeader: 'Kilo / Hecto',
                              rowHeight: 20.0,
                              fontWeight: FontWeight.normal,
                              cellColor: Colors.transparent,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: [
                            TableHeaderWidget(
                              tableHeader: 'Micro Nutrients',
                              rowHeight: 20.0,
                              fontWeight: FontWeight.w500,
                              cellColor: Colors.transparent,
                              textAlign: TextAlign.center,
                            ),
                            TableHeaderWidget(
                              tableHeader: 'Kilo / Hecto',
                              rowHeight: 20.0,
                              fontWeight: FontWeight.normal,
                              cellColor: Colors.transparent,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Table(
                            border: TableBorder.all(color: kReportTableColor),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(124),
                              1: FlexColumnWidth(),
                              2: FixedColumnWidth(164),
                              3: FlexColumnWidth(),
                              4: FlexColumnWidth(),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Nutrients',
                                    rowHeight: 50.0,
                                    fontWeight: FontWeight.bold,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableHeaderWidget(
                                    tableHeader: '(Kilo / \nAcre)',
                                    rowHeight: 50.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableHeaderWidget(
                                    tableHeader: 'Fertilizers',
                                    rowHeight: 50.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableHeaderWidget(
                                    tableHeader: '(Kilo / \nAcre)',
                                    rowHeight: 50.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableHeaderWidget(
                                    tableHeader: 'Mu / \nAcre',
                                    rowHeight: 50.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Nutrient (N)',
                                    rowHeight: 30.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: Colors.transparent,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnN1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnN2Controller,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnN2Controller = value!;
                                            });
                                          },
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnN3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnN4Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Nutrient (P2O5)',
                                    rowHeight: 30.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: Colors.transparent,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnP1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnP2Controller,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnP2Controller = value!;
                                            });
                                          },
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnP3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnP4Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Nutrient (K)',
                                    rowHeight: 30.0,
                                    fontWeight: FontWeight.normal,
                                    cellColor: Colors.transparent,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnK1Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnK2Controller,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnK2Controller = value!;
                                            });
                                          },
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnK3Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnK4Controller,
                                    textAlign: TextAlign.center,
                                    inputState: isPreview,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Table(
                            border: TableBorder.all(color: kReportTableColor),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(216),
                              1: FlexColumnWidth(),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Ferrous Sulfate (FeSO4)',
                                    rowHeight: 36.5,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnFeController,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnFeController = value!;
                                            });
                                          },
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Manganese Sulfate (MnSO4)',
                                    rowHeight: 36.5,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnMnController,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnMnController = value!;
                                            });
                                          },
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Zinc Sulfate (ZnSO4)',
                                    rowHeight: 36.5,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnZnController,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnZnController = value!;
                                            });
                                          },
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableHeaderWidget(
                                    tableHeader: 'Copper Sulfate (CuSO4)',
                                    rowHeight: 36.5,
                                    fontWeight: FontWeight.normal,
                                    cellColor: kReportCellColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnCuController,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: isPreview
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _mnCuController = value!;
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              ),
              isPreview || isDraft
                  ? SizedBox.shrink()
                  : TextButton(
                      style: TextButton.styleFrom(foregroundColor: kPrimaryColor, fixedSize: Size(76, 36)),
                      onPressed: () {
                        var reportData = jsonEncode({
                          "fields": {
                            "soilStandard": {
                              "mapValue": {
                                "fields": {
                                  "0": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"booleanValue": ccChecked[0]},
                                        "1": {"booleanValue": ccChecked[1]},
                                        "2": {"booleanValue": ccChecked[2]},
                                        "3": {
                                          "doubleValue": _ssEC1Controller.text.isEmpty ? 0.0 : _ssEC1Controller.text
                                        },
                                        "4": {
                                          "doubleValue": _ssEC2Controller.text.isEmpty ? 0.0 : _ssEC2Controller.text
                                        },
                                        "5": {
                                          "doubleValue": _ssEC3Controller.text.isEmpty ? 0.0 : _ssEC3Controller.text
                                        },
                                        "6": {
                                          "doubleValue": _ssPH1Controller.text.isEmpty ? 0.0 : _ssPH1Controller.text
                                        },
                                        "7": {
                                          "doubleValue": _ssPH2Controller.text.isEmpty ? 0.0 : _ssPH2Controller.text
                                        },
                                        "8": {
                                          "doubleValue": _ssPH3Controller.text.isEmpty ? 0.0 : _ssPH3Controller.text
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            "macroNutrients": {
                              "mapValue": {
                                "fields": {
                                  "0": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"doubleValue": _mnN1Controller.text.isEmpty ? 0.0 : _mnN1Controller.text},
                                        "1": {"stringValue": _mnN2Controller},
                                        "2": {"doubleValue": _mnN3Controller.text.isEmpty ? 0.0 : _mnN3Controller.text},
                                        "3": {"doubleValue": _mnN4Controller.text.isEmpty ? 0.0 : _mnN4Controller.text}
                                      }
                                    }
                                  },
                                  "1": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"doubleValue": _mnP1Controller.text.isEmpty ? 0.0 : _mnP1Controller.text},
                                        "1": {"stringValue": _mnP2Controller},
                                        "2": {"doubleValue": _mnP3Controller.text.isEmpty ? 0.0 : _mnP3Controller.text},
                                        "3": {"doubleValue": _mnP4Controller.text.isEmpty ? 0.0 : _mnP4Controller.text}
                                      }
                                    }
                                  },
                                  "2": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"doubleValue": _mnK1Controller.text.isEmpty ? 0.0 : _mnK1Controller.text},
                                        "1": {"stringValue": _mnK2Controller},
                                        "2": {"doubleValue": _mnK3Controller.text.isEmpty ? 0.0 : _mnK3Controller.text},
                                        "3": {"doubleValue": _mnK4Controller.text.isEmpty ? 0.0 : _mnK4Controller.text}
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            "microNutrients": {
                              "mapValue": {
                                "fields": {
                                  "0": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"stringValue": _mnFeController}
                                      }
                                    }
                                  },
                                  "1": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"stringValue": _mnMnController}
                                      }
                                    }
                                  },
                                  "2": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"stringValue": _mnZnController}
                                      }
                                    }
                                  },
                                  "3": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {"stringValue": _mnCuController}
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            "reportCreatedAt": {"timestampValue": DateTime.now().toUtc().toIso8601String()},
                            "reportCreatedBy": {"stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"},
                            "reportModifiedAt": {"timestampValue": DateTime.now().toUtc().toIso8601String()},
                            "reportModifiedBy": {"stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"},
                            "soilTestResults": {
                              "mapValue": {
                                "fields": {
                                  "MicroNutrients": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {"booleanValue": feChecked[0]},
                                              "1": {"booleanValue": feChecked[1]},
                                              "2": {"booleanValue": feChecked[2]}
                                            }
                                          }
                                        },
                                        "1": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {"booleanValue": mnChecked[0]},
                                              "1": {"booleanValue": mnChecked[1]},
                                              "2": {"booleanValue": mnChecked[2]}
                                            }
                                          }
                                        },
                                        "2": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {"booleanValue": znChecked[0]},
                                              "1": {"booleanValue": znChecked[1]},
                                              "2": {"booleanValue": znChecked[2]}
                                            }
                                          }
                                        },
                                        "3": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {"booleanValue": cuChecked[0]},
                                              "1": {"booleanValue": cuChecked[1]},
                                              "2": {"booleanValue": cuChecked[2]}
                                            }
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "MacroNutrients": {
                                    "mapValue": {
                                      "fields": {
                                        "0": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {
                                                "doubleValue":
                                                    _strO1Controller.text.isEmpty ? 0.0 : _strO1Controller.text
                                              },
                                              "1": {
                                                "doubleValue":
                                                    _strO2Controller.text.isEmpty ? 0.0 : _strO2Controller.text
                                              },
                                              "2": {
                                                "doubleValue":
                                                    _strO3Controller.text.isEmpty ? 0.0 : _strO3Controller.text
                                              }
                                            }
                                          }
                                        },
                                        "1": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {
                                                "doubleValue":
                                                    _strN1Controller.text.isEmpty ? 0.0 : _strN1Controller.text
                                              },
                                              "1": {
                                                "doubleValue":
                                                    _strN2Controller.text.isEmpty ? 0.0 : _strN2Controller.text
                                              },
                                              "2": {
                                                "doubleValue":
                                                    _strN3Controller.text.isEmpty ? 0.0 : _strN3Controller.text
                                              }
                                            }
                                          }
                                        },
                                        "2": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {
                                                "doubleValue":
                                                    _strP1Controller.text.isEmpty ? 0.0 : _strP1Controller.text
                                              },
                                              "1": {
                                                "doubleValue":
                                                    _strP2Controller.text.isEmpty ? 0.0 : _strP2Controller.text
                                              },
                                              "2": {
                                                "doubleValue":
                                                    _strP3Controller.text.isEmpty ? 0.0 : _strP3Controller.text
                                              }
                                            }
                                          }
                                        },
                                        "3": {
                                          "mapValue": {
                                            "fields": {
                                              "0": {
                                                "doubleValue":
                                                    _strK1Controller.text.isEmpty ? 0.0 : _strK1Controller.text
                                              },
                                              "1": {
                                                "doubleValue":
                                                    _strK2Controller.text.isEmpty ? 0.0 : _strK2Controller.text
                                              },
                                              "2": {
                                                "doubleValue":
                                                    _strK3Controller.text.isEmpty ? 0.0 : _strK3Controller.text
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            "cultivatingCrops": {
                              "stringValue": _opCcController.text.isEmpty ? '' : _opCcController.text
                            },
                            "fertilizerSuggestions": {
                              "stringValue": _opFsController.text.isEmpty ? '' : _opFsController.text
                            },
                            "sampleNumber": {"stringValue": sampleDoc.sampleNumber.stringValue},
                            "reportNumber": {
                              "stringValue": 'ARN' + DateFormat("yyyyMMddkkmmss").format(DateTime.now()).toString()
                            },
                            "reportStatus": {"booleanValue": false}
                          }
                        });
                        List httpValue = [];
                        createReport(reportData, reportDoc, sampleRef, false, httpValue);
                        _formKey.currentState!.reset();
                        Navigator.pop(context, true);
                      },
                      child: Text('Save Draft'),
                    ),
              isPreview
                  ? SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: changeHappened
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                var genARN = DateFormat("yyyyMMddkkmmss").format(DateTime.now()).toString();
                                var reportData = jsonEncode({
                                  "fields": {
                                    "soilStandard": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"booleanValue": ccChecked[0]},
                                                "1": {"booleanValue": ccChecked[1]},
                                                "2": {"booleanValue": ccChecked[2]},
                                                "3": {"doubleValue": _ssEC1Controller.text},
                                                "4": {"doubleValue": _ssEC2Controller.text},
                                                "5": {"doubleValue": _ssEC3Controller.text},
                                                "6": {"doubleValue": _ssPH1Controller.text},
                                                "7": {"doubleValue": _ssPH2Controller.text},
                                                "8": {"doubleValue": _ssPH3Controller.text}
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "macroNutrients": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"doubleValue": _mnN1Controller.text},
                                                "1": {"stringValue": _mnN2Controller},
                                                "2": {"doubleValue": _mnN3Controller.text},
                                                "3": {"doubleValue": _mnN4Controller.text}
                                              }
                                            }
                                          },
                                          "1": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"doubleValue": _mnP1Controller.text},
                                                "1": {"stringValue": _mnP2Controller},
                                                "2": {"doubleValue": _mnP3Controller.text},
                                                "3": {"doubleValue": _mnP4Controller.text}
                                              }
                                            }
                                          },
                                          "2": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"doubleValue": _mnK1Controller.text},
                                                "1": {"stringValue": _mnK2Controller},
                                                "2": {"doubleValue": _mnK3Controller.text},
                                                "3": {"doubleValue": _mnK4Controller.text}
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "microNutrients": {
                                      "mapValue": {
                                        "fields": {
                                          "0": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"stringValue": _mnFeController}
                                              }
                                            }
                                          },
                                          "1": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"stringValue": _mnMnController}
                                              }
                                            }
                                          },
                                          "2": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"stringValue": _mnZnController}
                                              }
                                            }
                                          },
                                          "3": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {"stringValue": _mnCuController}
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "reportCreatedAt": {"timestampValue": DateTime.now().toUtc().toIso8601String()},
                                    "reportCreatedBy": {"stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"},
                                    "reportModifiedAt": {"timestampValue": DateTime.now().toUtc().toIso8601String()},
                                    "reportModifiedBy": {"stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"},
                                    "soilTestResults": {
                                      "mapValue": {
                                        "fields": {
                                          "MicroNutrients": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"booleanValue": feChecked[0]},
                                                      "1": {"booleanValue": feChecked[1]},
                                                      "2": {"booleanValue": feChecked[2]}
                                                    }
                                                  }
                                                },
                                                "1": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"booleanValue": mnChecked[0]},
                                                      "1": {"booleanValue": mnChecked[1]},
                                                      "2": {"booleanValue": mnChecked[2]}
                                                    }
                                                  }
                                                },
                                                "2": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"booleanValue": znChecked[0]},
                                                      "1": {"booleanValue": znChecked[1]},
                                                      "2": {"booleanValue": znChecked[2]}
                                                    }
                                                  }
                                                },
                                                "3": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"booleanValue": cuChecked[0]},
                                                      "1": {"booleanValue": cuChecked[1]},
                                                      "2": {"booleanValue": cuChecked[2]}
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          },
                                          "MacroNutrients": {
                                            "mapValue": {
                                              "fields": {
                                                "0": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"doubleValue": _strO1Controller.text},
                                                      "1": {"doubleValue": _strO2Controller.text},
                                                      "2": {"doubleValue": _strO3Controller.text}
                                                    }
                                                  }
                                                },
                                                "1": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"doubleValue": _strN1Controller.text},
                                                      "1": {"doubleValue": _strN2Controller.text},
                                                      "2": {"doubleValue": _strN3Controller.text}
                                                    }
                                                  }
                                                },
                                                "2": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"doubleValue": _strP1Controller.text},
                                                      "1": {"doubleValue": _strP2Controller.text},
                                                      "2": {"doubleValue": _strP3Controller.text}
                                                    }
                                                  }
                                                },
                                                "3": {
                                                  "mapValue": {
                                                    "fields": {
                                                      "0": {"doubleValue": _strK1Controller.text},
                                                      "1": {"doubleValue": _strK2Controller.text},
                                                      "2": {"doubleValue": _strK3Controller.text}
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    "cultivatingCrops": {"stringValue": _opCcController.text},
                                    "fertilizerSuggestions": {"stringValue": _opFsController.text},
                                    "sampleNumber": {"stringValue": sampleDoc.sampleNumber.stringValue},
                                    "reportNumber": {"stringValue": 'ARN' + genARN},
                                    "reportStatus": {"booleanValue": true}
                                  }
                                });
                                var ad = farmerDoc.addressDetails.mapValue.fields.mn0.mapValue.fields;
                                List httpValue = [
                                  '${farmerDoc.firstName.stringValue + ' ' + farmerDoc.lastName.stringValue}',
                                  '${reportDoc == null ? 'ARN' + genARN : reportDoc.fields.reportNumber.stringValue}',
                                  '${ad.eaM1.stringValue}',
                                  '${ad.eaM0.stringValue + ', ' + ad.eaM4.stringValue + ' (Taluk), ' + ad.eaM3.stringValue + ', ' + ad.eaM5.stringValue + ', ' + ad.eaM6.stringValue + ' ' + ad.eaM2.stringValue}',
                                  '${DateFormat('MM/dd/yyyy hh:mm aaa').format(DateTime.parse(sampleDoc.sampleCreatedAt.timestampValue))}',
                                  '${DateFormat('MM/dd/yyyy hh:mm aaa').format(reportDoc == null ? DateTime.now().toUtc() : DateTime.parse(reportDoc.reportCreatedAt.timestampValue))}',
                                  ccChecked[0],
                                  ccChecked[1],
                                  ccChecked[2],
                                  _ssEC1Controller.text.isEmpty ? 0.0 : _ssEC1Controller.text.toString(),
                                  _ssEC2Controller.text.isEmpty ? 0.0 : _ssEC2Controller.text.toString(),
                                  _ssEC3Controller.text.isEmpty ? 0.0 : _ssEC3Controller.text.toString(),
                                  _ssPH1Controller.text.isEmpty ? 0.0 : _ssPH1Controller.text.toString(),
                                  _ssPH2Controller.text.isEmpty ? 0.0 : _ssPH2Controller.text.toString(),
                                  _ssPH3Controller.text.isEmpty ? 0.0 : _ssPH3Controller.text.toString(),
                                  _strO1Controller.text.isEmpty ? 0.0 : _strO1Controller.text.toString(),
                                  _strO2Controller.text.isEmpty ? 0.0 : _strO2Controller.text.toString(),
                                  _strO3Controller.text.isEmpty ? 0.0 : _strO3Controller.text.toString(),
                                  _strN1Controller.text.isEmpty ? 0.0 : _strN1Controller.text.toString(),
                                  _strN2Controller.text.isEmpty ? 0.0 : _strN2Controller.text.toString(),
                                  _strN3Controller.text.isEmpty ? 0.0 : _strN3Controller.text.toString(),
                                  _strP1Controller.text.isEmpty ? 0.0 : _strP1Controller.text.toString(),
                                  _strP2Controller.text.isEmpty ? 0.0 : _strP2Controller.text.toString(),
                                  _strP3Controller.text.isEmpty ? 0.0 : _strP3Controller.text.toString(),
                                  _strK1Controller.text.isEmpty ? 0.0 : _strK1Controller.text.toString(),
                                  _strK2Controller.text.isEmpty ? 0.0 : _strK2Controller.text.toString(),
                                  _strK3Controller.text.isEmpty ? 0.0 : _strK3Controller.text.toString(),
                                  feChecked[0],
                                  feChecked[1],
                                  feChecked[2],
                                  mnChecked[0],
                                  mnChecked[1],
                                  mnChecked[2],
                                  znChecked[0],
                                  znChecked[1],
                                  znChecked[2],
                                  cuChecked[0],
                                  cuChecked[1],
                                  cuChecked[2],
                                  _opCcController.text.toString(),
                                  _opFsController.text.toString(),
                                  _mnN1Controller.text.isEmpty ? 0.0 : _mnN1Controller.text.toString(),
                                  _mnN2Controller.toString(),
                                  _mnN3Controller.text.isEmpty ? 0.0 : _mnN3Controller.text.toString(),
                                  _mnN4Controller.text.isEmpty ? 0.0 : _mnN4Controller.text.toString(),
                                  _mnP1Controller.text.isEmpty ? 0.0 : _mnP1Controller.text.toString(),
                                  _mnP2Controller.toString(),
                                  _mnP3Controller.text.isEmpty ? 0.0 : _mnP3Controller.text.toString(),
                                  _mnP4Controller.text.isEmpty ? 0.0 : _mnP4Controller.text.toString(),
                                  _mnK1Controller.text.isEmpty ? 0.0 : _mnK1Controller.text.toString(),
                                  _mnK2Controller.toString(),
                                  _mnK3Controller.text.isEmpty ? 0.0 : _mnK3Controller.text.toString(),
                                  _mnK4Controller.text.isEmpty ? 0.0 : _mnK4Controller.text.toString(),
                                  _mnFeController.toString(),
                                  _mnMnController.toString(),
                                  _mnZnController.toString(),
                                  _mnCuController.toString()
                                ];
                                createReport(reportData, reportDoc, sampleRef, true, httpValue);
                                _formKey.currentState!.reset();
                                Navigator.pop(context, true);
                              }
                            }
                          : null,
                      child: Text('Submit'),
                    ),
            ],
          );
        });
      }).then((value) {
    return value == null
        ? false
        : value == true
            ? true
            : false;
  });
}

class TableDataDropWidget extends StatelessWidget {
  final String dropValue;
  final List<String> dropItems;
  final Function(String?)? onChangeFnc;
  const TableDataDropWidget({Key? key, required this.dropValue, required this.dropItems, required this.onChangeFnc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
              value: dropValue,
              items: dropItems
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: onChangeFnc,
            ),
          ),
        ),
      ),
    );
  }
}

class TableDataInputWidget extends StatelessWidget {
  final Color cellColor;
  final double rowHeight;
  final TextEditingController textController;
  final TextAlign textAlign;
  final bool inputState;
  const TableDataInputWidget({
    Key? key,
    required this.cellColor,
    required this.rowHeight,
    required this.textController,
    required this.textAlign,
    required this.inputState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cellColor,
      child: SizedBox(
        height: rowHeight,
        child: Center(
          child: TextFormField(
            enabled: !inputState,
            controller: textController,
            textAlign: textAlign,
            validator: (v) {
              return v!.contains(RegExp(r'^\b([0-9]|[1-9][0-9]|[1-9][0-9][0-9]|1000)\b.\b([0-9]|[0-9][0-9])\b$'))
                  ? null
                  : 'false';
            },
            decoration: InputDecoration(
              errorStyle: TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
              hintText: 'X.XX',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class TableHeaderWidget extends StatelessWidget {
  final String tableHeader;
  final double rowHeight;
  final FontWeight fontWeight;
  final Color cellColor;
  final TextAlign textAlign;
  const TableHeaderWidget(
      {Key? key,
      required this.tableHeader,
      required this.rowHeight,
      required this.fontWeight,
      required this.cellColor,
      required this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cellColor,
      child: SizedBox(
        height: rowHeight,
        child: Center(
          child: Text(
            tableHeader,
            textAlign: textAlign,
            style: TextStyle(
              color: kReportTableColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      ValueChanged<bool>? onChanged,
      bool? initialValue,
      bool autoValidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              void onChangedHandler(value) {
                Future.delayed(Duration(microseconds: 1), () {
                  state.didChange(value);
                });
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              return Checkbox(
                value: initialValue,
                onChanged: onChangedHandler,
              );
            });
}

class TableDataCheckFormWidget extends StatelessWidget {
  final bool tableData;
  final double rowHeight;
  final Color cellColor;
  final void Function(bool?)? onChangeFnc;
  const TableDataCheckFormWidget(
      {Key? key, required this.tableData, required this.rowHeight, required this.cellColor, required this.onChangeFnc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cellColor,
      child: SizedBox(
        height: rowHeight,
        child: Center(
          child: CheckboxFormField(
            initialValue: tableData,
            onChanged: onChangeFnc,
          ),
        ),
      ),
    );
  }
}

class TableDataCheckWidget extends StatelessWidget {
  final bool tableData;
  final double rowHeight;
  final Color cellColor;
  final void Function(bool?)? onChangeFnc;
  const TableDataCheckWidget(
      {Key? key, required this.tableData, required this.rowHeight, required this.cellColor, required this.onChangeFnc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cellColor,
      child: SizedBox(
        height: rowHeight,
        child: Center(
          child: Checkbox(
            value: tableData,
            onChanged: onChangeFnc,
          ),
        ),
      ),
    );
  }
}

List<bool> onCheckState(int isChecked) {
  List<bool> boolList = [];
  switch (isChecked) {
    case 1:
      {
        boolList = [true, false, false];
      }
      break;
    case 2:
      {
        boolList = [false, true, false];
      }
      break;
    case 3:
      {
        boolList = [false, false, true];
      }
      break;
    default:
      {
        boolList = [false, false, false];
      }
      break;
  }
  return boolList;
}

Future<void> createReport(reportData, reportDoc, sampleRef, isDraft, httpValue) async {
  print(httpValue);
  if (isDraft) {
    List key = [
      "farmerName",
      "reportNumber",
      "surveyNumber",
      "addressDetails",
      "dateSample",
      "dateReport",
      "cc0",
      "cc1",
      "cc2",
      "ec0",
      "ec1",
      "ec2",
      "ph0",
      "ph1",
      "ph2",
      "oc0",
      "oc1",
      "oc2",
      "nc0",
      "nc1",
      "nc2",
      "np0",
      "np1",
      "np2",
      "nk0",
      "nk1",
      "nk2",
      "fe0",
      "fe1",
      "fe2",
      "mn0",
      "mn1",
      "mn2",
      "zn0",
      "zn1",
      "zn2",
      "cu0",
      "cu1",
      "cu2",
      "opc",
      "ops",
      "sn0",
      "sn1",
      "sn2",
      "sn3",
      "sp0",
      "sp1",
      "sp2",
      "sp3",
      "sk0",
      "sk1",
      "sk2",
      "sk3",
      "sfe",
      "smn",
      "szn",
      "scu"
    ];
    String fin = '';
    for (var i = 0; i <= 56; i++) {
      var condition = [
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i] == true,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i] != 0,
        httpValue[i].toString().length != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i].toString().length != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i].toString().length != 0,
        httpValue[i] != 0,
        httpValue[i] != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0,
        httpValue[i].toString().length != 0
      ];
      //console.log(key[i] + ' ' + condition[i] + ' ' +httpValue[i]);
      if (condition[i]) {
        // var check = httpValue[i] == true ? "✔" : httpValue[i];
        // fin += '${"${key[i]}" + ":" + "$check,"}';
        var check = httpValue[i] == true ? "✔" : httpValue[i];
        fin += '"${key[i]}":' + '"$check"' + '${i == 56 ? '' : ','}';
      }
    }
    print('{$fin}');

    final response = await http.post(
      Uri.parse(
          'https://prod-14.centralindia.logic.azure.com:443/workflows/4d804d256a274c7c99336ee0eb90113e/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=RUNTHzDRobzhcZ_4iVmNYKYTozbJk9bELL_hONqOORg'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: '{$fin}',
    );
    print(response.statusCode);
    print(response.body);
  }
  if (reportDoc == null) {
    await http
        .post(
      Uri.parse('http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents/reports'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: reportData,
    )
        .then((responseFireStore) async {
      var reportD = jsonEncode({
        "fields": {
          "reportCreated": {"booleanValue": true},
          "sampleModifiedBy": {"stringValue": "Y3B6AadviKsLu0QZbHoANIYyjqyy"},
          "sampleModifiedAt": {"timestampValue": DateTime.now().toUtc().toIso8601String()}
        }
      });
      await http.patch(
        Uri.parse(
            'http://localhost:8080/v1/$sampleRef?updateMask.fieldPaths=reportCreated&updateMask.fieldPaths=sampleModifiedAt&updateMask.fieldPaths=sampleModifiedBy'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: reportD,
      );
    });
  } else {
    await http.patch(
      Uri.parse(
          'http://localhost:8080/v1/${reportDoc.name}?updateMask.fieldPaths=reportModifiedAt&updateMask.fieldPaths=reportModifiedBy&updateMask.fieldPaths=cultivatingCrops&updateMask.fieldPaths=fertilizerSuggestions&updateMask.fieldPaths=macroNutrients&updateMask.fieldPaths=microNutrients&updateMask.fieldPaths=reportStatus&updateMask.fieldPaths=soilStandard&updateMask.fieldPaths=soilTestResults'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: reportData,
    );
  }
}
