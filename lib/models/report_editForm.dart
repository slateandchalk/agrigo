import 'package:agrigo_kia/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//Farmer Details
final TextEditingController _farmerNameController = TextEditingController();
final TextEditingController _farmerNumberController = TextEditingController();
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
String _mnN2Controller = mnN2Choose.first;
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
String _mnP2Controller = mnP2Choose.first;
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
String _mnK2Controller = mnK2Choose.first;
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
String _mnFeController = mnFeChoose.first;
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
String _mnMnController = mnMnChoose.first;
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
String _mnZnController = mnZnChoose.first;
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
String _mnCuController = mnCuChoose.first;

//submit button
bool _enableBtn = false;

// ignore: non_constant_identifier_names
Future<void> reportEditDialog(
    BuildContext context, report, sample, farmer) async {
  return await showDialog(
      context: context,
      builder: (context) {
        _farmerNameController.text =
            farmer[0].document.fields.firstName.stringValue +
                ' ' +
                farmer[0].document.fields.lastName.stringValue;
        _farmerNumberController.text =
            farmer[0].document.fields.farmerNumber.stringValue;
        _farmerAddressController.text =
            farmer[0].document.fields.firstName.stringValue;
        var cc = report.fields.soilStandard.mapValue.fields.ss0.mapValue.fields;
        List<bool> ccChecked = [
          cc.ssM0.booleanValue,
          cc.ssM1.booleanValue,
          cc.ssM2.booleanValue
        ];
        _ssEC1Controller.text = cc.ssM3.doubleValue.toString();
        _ssEC2Controller.text = cc.ssM4.doubleValue.toString();
        _ssEC3Controller.text = cc.ssM5.doubleValue.toString();
        _ssPH1Controller.text = cc.ssM6.doubleValue.toString();
        _ssPH2Controller.text = cc.ssM7.doubleValue.toString();
        _ssPH3Controller.text = cc.ssM8.doubleValue.toString();
        var fe = report.fields.soilTestResults.mapValue.fields.microNutrients
            .mapValue.fields.smi0.mapValue.fields;
        List<bool> feChecked = [
          fe.miS0.booleanValue,
          fe.miS1.booleanValue,
          fe.miS2.booleanValue
        ];
        var mn = report.fields.soilTestResults.mapValue.fields.microNutrients
            .mapValue.fields.smi1.mapValue.fields;
        List<bool> mnChecked = [
          mn.miS0.booleanValue,
          mn.miS1.booleanValue,
          mn.miS2.booleanValue
        ];
        var zn = report.fields.soilTestResults.mapValue.fields.microNutrients
            .mapValue.fields.smi2.mapValue.fields;
        List<bool> znChecked = [
          zn.miS0.booleanValue,
          zn.miS1.booleanValue,
          zn.miS2.booleanValue
        ];
        var cu = report.fields.soilTestResults.mapValue.fields.microNutrients
            .mapValue.fields.smi3.mapValue.fields;
        List<bool> cuChecked = [
          cu.miS0.booleanValue,
          cu.miS1.booleanValue,
          cu.miS2.booleanValue
        ];
        var o = report.fields.soilTestResults.mapValue.fields.macroNutrients
            .mapValue.fields.smn0.mapValue.fields;
        _strO1Controller.text = o.mnS0.doubleValue.toString();
        _strO2Controller.text = o.mnS1.doubleValue.toString();
        _strO3Controller.text = o.mnS2.doubleValue.toString();
        var n = report.fields.soilTestResults.mapValue.fields.macroNutrients
            .mapValue.fields.smn1.mapValue.fields;
        _strN1Controller.text = n.mnS0.doubleValue.toString();
        _strN2Controller.text = n.mnS1.doubleValue.toString();
        _strN3Controller.text = n.mnS2.doubleValue.toString();
        var p = report.fields.soilTestResults.mapValue.fields.macroNutrients
            .mapValue.fields.smn2.mapValue.fields;
        _strP1Controller.text = p.mnS0.doubleValue.toString();
        _strP2Controller.text = p.mnS1.doubleValue.toString();
        _strP3Controller.text = p.mnS2.doubleValue.toString();
        var k = report.fields.soilTestResults.mapValue.fields.macroNutrients
            .mapValue.fields.smn3.mapValue.fields;
        _strK1Controller.text = k.mnS0.doubleValue.toString();
        _strK2Controller.text = k.mnS1.doubleValue.toString();
        _strK3Controller.text = k.mnS2.doubleValue.toString();
        _opCcController.text = report.fields.cultivatingCrops.stringValue;
        _opFsController.text = report.fields.fertilizerSuggestions.stringValue;
        var mnN =
            report.fields.macroNutrients.mapValue.fields.mn0.mapValue.fields;
        _mnN1Controller.text = mnN.mnM0.doubleValue.toString();
        _mnN2Controller = mnN.mnM1.stringValue;
        _mnN3Controller.text = mnN.mnM2.doubleValue.toString();
        _mnN4Controller.text = mnN.mnM3.doubleValue.toString();
        var mnP =
            report.fields.macroNutrients.mapValue.fields.mn1.mapValue.fields;
        _mnP1Controller.text = mnP.mnM0.doubleValue.toString();
        _mnP2Controller = mnP.mnM1.stringValue;
        _mnP3Controller.text = mnP.mnM2.doubleValue.toString();
        _mnP4Controller.text = mnP.mnM3.doubleValue.toString();
        var mnK =
            report.fields.macroNutrients.mapValue.fields.mn2.mapValue.fields;
        _mnK1Controller.text = mnK.mnM0.doubleValue.toString();
        _mnK2Controller = mnK.mnM1.stringValue;
        _mnK3Controller.text = mnK.mnM2.doubleValue.toString();
        _mnK4Controller.text = mnK.mnM3.doubleValue.toString();
        var miN = report.fields.microNutrients.mapValue.fields;
        _mnFeController = miN.mi0.mapValue.fields.miM0.stringValue;
        _mnMnController = miN.mi1.mapValue.fields.miM0.stringValue;
        _mnZnController = miN.mi2.mapValue.fields.miM0.stringValue;
        _mnCuController = miN.mi3.mapValue.fields.miM0.stringValue;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(18),
            title: Text('Create Report'),
            scrollable: true,
            content: Form(
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                setState(() {
                  _enableBtn = _formKey.currentState!.validate();
                });
              },
              key: _formKey,
              child: SizedBox(
                width: 960,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                                    child: Text('Farmer Number:'),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: TextFormField(
                                      enabled: false,
                                      controller: _farmerNumberController,
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
                                      controller: _farmerNameController,
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Soil Standard',
                      style: TextStyle(
                          color: kReportTableColor,
                          fontWeight: FontWeight.bold),
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
                                                  tableHeader:
                                                      'Medium Condition',
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
                                  TableDataCheckWidget(
                                    tableData: ccChecked[0],
                                    rowHeight: 60.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        ccChecked = onCheckState(1);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: ccChecked[1],
                                    rowHeight: 60.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        ccChecked = onCheckState(2);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: ccChecked[2],
                                    rowHeight: 60.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
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
                                ),
                                TableDataInputWidget(
                                  cellColor: kReportCellColor,
                                  rowHeight: 60.0,
                                  textController: _ssEC2Controller,
                                  textAlign: TextAlign.center,
                                ),
                                TableDataInputWidget(
                                  cellColor: kReportCellColor,
                                  rowHeight: 60.0,
                                  textController: _ssEC3Controller,
                                  textAlign: TextAlign.center,
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
                                ),
                                TableDataInputWidget(
                                  cellColor: Colors.transparent,
                                  rowHeight: 60.0,
                                  textController: _ssPH2Controller,
                                  textAlign: TextAlign.center,
                                ),
                                TableDataInputWidget(
                                  cellColor: Colors.transparent,
                                  rowHeight: 60.0,
                                  textController: _ssPH3Controller,
                                  textAlign: TextAlign.center,
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
                      style: TextStyle(
                          color: kReportTableColor,
                          fontWeight: FontWeight.bold),
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
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strO2Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strO3Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strN2Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strN3Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strP2Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strP3Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Table(
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strK2Controller,
                                    textAlign: TextAlign.center,
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _strK3Controller,
                                    textAlign: TextAlign.center,
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
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  TableDataCheckWidget(
                                    tableData: feChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        feChecked = onCheckState(1);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: feChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        feChecked = onCheckState(2);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: feChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
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
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  TableDataCheckWidget(
                                    tableData: mnChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        mnChecked = onCheckState(1);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: mnChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        mnChecked = onCheckState(2);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: mnChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
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
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  TableDataCheckWidget(
                                    tableData: znChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        znChecked = onCheckState(1);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: znChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        znChecked = onCheckState(2);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: znChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
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
                                    border: TableBorder.all(
                                        color: kReportTableColor),
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
                                  TableDataCheckWidget(
                                    tableData: cuChecked[0],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        cuChecked = onCheckState(1);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: cuChecked[1],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
                                      setState(() {
                                        cuChecked = onCheckState(2);
                                      });
                                    },
                                  ),
                                  TableDataCheckWidget(
                                    tableData: cuChecked[2],
                                    rowHeight: 30.0,
                                    cellColor: Colors.transparent,
                                    onChangeFnc: (bool? value) {
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                                controller: _opCcController,
                                decoration: InputDecoration(
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
                                controller: _opFsController,
                                decoration: InputDecoration(
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
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnN2Controller,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: (value) {
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnN4Controller,
                                    textAlign: TextAlign.center,
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
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnP2Controller,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: (value) {
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnP4Controller,
                                    textAlign: TextAlign.center,
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
                                  ),
                                  TableDataDropWidget(
                                    dropValue: _mnK2Controller,
                                    dropItems: mnN2Choose,
                                    onChangeFnc: (value) {
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
                                  ),
                                  TableDataInputWidget(
                                    cellColor: Colors.transparent,
                                    rowHeight: 30.0,
                                    textController: _mnK4Controller,
                                    textAlign: TextAlign.center,
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
                                    onChangeFnc: (value) {
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
                                    onChangeFnc: (value) {
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
                                    onChangeFnc: (value) {
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
                                    onChangeFnc: (value) {
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
                  _enableBtn = false;
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _enableBtn
                    ? () {
                        var farmerData = jsonEncode({
                          "fields": {
                            "farmerUID": {"stringValue": "dummyUID"}
                          }
                        });
                        _formKey.currentState!.reset();
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text('Submit'),
              ),
            ],
          );
        });
      }).then((value) => _enableBtn = false);
}

class TableDataDropWidget extends StatelessWidget {
  final String dropValue;
  final List<String> dropItems;
  final Function(String?)? onChangeFnc;
  const TableDataDropWidget(
      {Key? key,
      required this.dropValue,
      required this.dropItems,
      required this.onChangeFnc})
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
  const TableDataInputWidget(
      {Key? key,
      required this.cellColor,
      required this.rowHeight,
      required this.textController,
      required this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cellColor,
      child: SizedBox(
        height: rowHeight,
        child: Center(
          child: TextFormField(
            // inputFormatters: [
            //   FilteringTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'),
            //       allow: true),
            // ],
            controller: textController,
            textAlign: textAlign,
            decoration: InputDecoration(
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

class TableDataCheckWidget extends StatelessWidget {
  final bool tableData;
  final double rowHeight;
  final Color cellColor;
  final void Function(bool?)? onChangeFnc;
  const TableDataCheckWidget(
      {Key? key,
      required this.tableData,
      required this.rowHeight,
      required this.cellColor,
      required this.onChangeFnc})
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
