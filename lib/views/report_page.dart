import 'dart:async';
import 'dart:convert';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:agrigo_kia/models/delete_allDialog.dart';
import 'package:agrigo_kia/models/report_PreForm.dart';
import 'package:agrigo_kia/models/report_PreviewForm.dart';
import 'package:agrigo_kia/models/report_newForm.dart';
import 'package:agrigo_kia/models/report_query_model.dart';
import 'package:agrigo_kia/resources/fetch_model.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

enum sortOptions { lastModByMe, lastCreByMe, lastMod, lastCre, reportPending, reportCompleted, reportNumber }

enum gridOptions { editReport, deleteReport, printReport, downloadReport, previewReport, viewReport }

class ReportForm extends StatefulWidget {
  final bool connectionState;
  final Function selectionState;
  ReportForm({Key? key, required this.connectionState, required this.selectionState}) : super(key: key);
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> with TickerProviderStateMixin {
  late TabController _tabController;
  //
  bool filterState = false;
  var selectedOption = sortOptions.reportNumber;
  var currentOption = 'reportNumber';
  bool sortBy = false;
  bool sortOn = false;
  //
  TextEditingController _searchFilterController = TextEditingController();
  bool searchState = false;
  //
  late Timer _timer;
  //Connection
  late bool currentConnection;

  late AnimationController _animationController;

  //Reports
  int reportCount = 0;
  int totalCount = 0;
  StreamController<List<ReportQuery>> _reportController = StreamController<List<ReportQuery>>.broadcast();

  Future<List<ReportQuery>> fetchReportsSort(String sortOption, String sortMe, bool sortBy, bool sortOn) async {
    var queryStructureBy = jsonEncode({
      "structuredQuery": {
        "where": {
          "fieldFilter": {
            "field": {"fieldPath": sortOption},
            "op": "EQUAL",
            "value": {"stringValue": sortMe}
          }
        },
        "orderBy": [
          {
            "field": {"fieldPath": sortOption},
            "direction": "DESCENDING"
          }
        ],
        "from": [
          {"collectionId": "reports", "allDescendants": true}
        ]
      }
    });
    var queryStructure = sortOption == "reportStatus"
        ? jsonEncode({
            "structuredQuery": {
              "where": {
                "fieldFilter": {
                  "field": {"fieldPath": sortOption},
                  "op": "EQUAL",
                  "value": {"booleanValue": sortOn}
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
              "orderBy": [
                {
                  "field": {"fieldPath": sortOption},
                  "direction": sortOption == 'reportNumber' ? "ASCENDING" : "DESCENDING"
                }
              ],
              "from": [
                {"collectionId": "reports", "allDescendants": true}
              ]
            }
          });
    final response = await http.post(
        Uri.parse('http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents:runQuery'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: sortBy ? queryStructureBy : queryStructure);
    return parseReportQuery(utf8.decode(response.bodyBytes));
  }

  List<ReportQuery> parseReportQuery(String bodyBytes) {
    final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

    return parsed.map<ReportQuery>((json) => ReportQuery.fromJson(json)).toList();
  }

  loadData() async {
    List<ReportQuery> fakeRes = [];
    fetchReportsSort(currentOption, 'Y3B6AadviKsLu0QZbHoANIYyjqyy', sortBy, sortOn).then((res) {
      _reportController.add(res);
      setState(() {
        reportCount = 0;
        totalCount = res.length;
      });
      res.forEach((element) {
        if (element.document.fields.reportStatus.booleanValue == false) {
          setState(() {
            reportCount = reportCount + 1;
          });
        }
      });
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentConnection = widget.connectionState;
    });
    _tabController = TabController(length: 2, vsync: this);
    _timer = Timer.periodic(Duration(seconds: 1), (_) => currentConnection ? loadData() : null);
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void didUpdateWidget(covariant ReportForm oldWidget) {
    //print(widget.connectionState);
    setState(() {
      currentConnection = widget.connectionState;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 112, top: 24, right: 112, bottom: 24),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(152, 36),
                  ),
                  onPressed: () async {
                    await reportPreForm(context, _animationController);
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text("New Report"),
                ),
                Text(greeting() + ', ' + DateFormat.yMMMMEEEEd().format(DateTime.now())),
              ],
            ),
            SizedBox(
              height: 56,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      onTap: (event) {
                        switch (event) {
                          case 0:
                            setState(() {
                              currentOption = 'reportNumber';
                              sortBy = false;
                              sortOn = false;
                            });
                            break;
                          case 1:
                            reportCount == 0
                                ? _tabController.index = _tabController.previousIndex
                                : setState(() {
                                    currentOption = 'reportStatus';
                                    sortBy = false;
                                    sortOn = false;
                                  });
                            break;
                        }
                      },
                      tabs: <Widget>[
                        Text(
                          'Reports',
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              'Pending',
                            ),
                            Positioned(
                              child: CircleAvatar(
                                backgroundColor: _tabController.index == 1 ? kPrimaryColor : kGreyColor,
                                child: Text(
                                  reportCount > 9 ? '9+' : reportCount.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                                radius: 8,
                              ),
                              top: -12,
                              right: -12,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: TextField(
                        controller: _searchFilterController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kPrimaryColor.withAlpha(25),
                          isDense: true,
                          hintText: 'Type to filter list',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          suffixIcon: IconButton(
                            color: kPrimaryColor,
                            tooltip: 'Clear text',
                            splashRadius: 16,
                            iconSize: 16,
                            constraints: BoxConstraints(
                              minHeight: 24,
                              minWidth: 24,
                            ),
                            icon: searchState ? Icon(Icons.clear) : Icon(Icons.filter_alt_outlined),
                            onPressed: () {
                              _searchFilterController.clear();
                              setState(() {
                                searchState = false;
                              });
                            },
                          ),
                          suffixIconConstraints: BoxConstraints(
                            minHeight: 24,
                            minWidth: 24,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              searchState = true;
                            });
                          } else {
                            setState(() {
                              searchState = false;
                            });
                          }
                        },
                      ),
                    ),
                    PopupMenuButton<sortOptions>(
                      enabled: _tabController.index == 0,
                      offset: Offset(100, 50),
                      tooltip: 'Sort options',
                      icon: Icon(
                        Icons.sort_by_alpha_outlined,
                        color: _tabController.index == 0 ? kPrimaryColor : kGreyColor,
                      ),
                      onSelected: (sortOptions result) {
                        switch (result) {
                          case sortOptions.lastModByMe:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportModifiedBy';
                              sortBy = true;
                            });
                            break;
                          case sortOptions.lastCreByMe:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportCreatedBy';
                              sortBy = true;
                            });
                            break;
                          case sortOptions.lastMod:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportModifiedAt';
                              sortBy = false;
                            });
                            break;
                          case sortOptions.lastCre:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportCreatedAt';
                              sortBy = false;
                            });
                            break;
                          case sortOptions.reportPending:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportStatus';
                              sortBy = false;
                              sortOn = false;
                            });
                            break;
                          case sortOptions.reportCompleted:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportStatus';
                              sortBy = false;
                              sortOn = true;
                            });
                            break;
                          case sortOptions.reportNumber:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportNumber';
                              sortBy = false;
                            });
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<sortOptions>>[
                        CheckedPopupMenuItem<sortOptions>(
                          checked: sortOptions.lastModByMe == selectedOption,
                          value: sortOptions.lastModByMe,
                          child: Text('Last modified by me'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          checked: sortOptions.lastCreByMe == selectedOption,
                          value: sortOptions.lastCreByMe,
                          child: Text('Last created by me'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          checked: sortOptions.lastMod == selectedOption,
                          value: sortOptions.lastMod,
                          child: Text('Last modified'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          checked: sortOptions.lastCre == selectedOption,
                          value: sortOptions.lastCre,
                          child: Text('Last created'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          enabled: reportCount != totalCount,
                          checked: sortOptions.reportCompleted == selectedOption,
                          value: sortOptions.reportCompleted,
                          child: Text('Completed'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          enabled: reportCount == 0 ? false : true,
                          checked: sortOptions.reportPending == selectedOption,
                          value: sortOptions.reportPending,
                          child: Text('Pending'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          checked: sortOptions.reportNumber == selectedOption,
                          value: sortOptions.reportNumber,
                          child: Text('Number'),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: filterState ? 'Grid view' : 'List view',
                      splashRadius: 16,
                      icon: Icon(
                        filterState ? Icons.view_module_outlined : Icons.view_list_outlined,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          filterState = !filterState;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  StreamBuilder<List<ReportQuery>>(
                    stream: _reportController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? ReportList(
                              report: snapshot.data!,
                              filterState: filterState,
                              filterText: _searchFilterController.text,
                              filterTextController: _searchFilterController,
                              selectionState: widget.selectionState,
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                  StreamBuilder<List<ReportQuery>>(
                    stream: _reportController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? ReportList(
                              report: snapshot.data!,
                              filterState: filterState,
                              filterText: _searchFilterController.text,
                              filterTextController: _searchFilterController,
                              selectionState: widget.selectionState,
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportList extends StatefulWidget {
  final List<ReportQuery> report;
  final bool filterState;
  final String filterText;
  final TextEditingController filterTextController;
  final Function selectionState;
  ReportList({
    Key? key,
    required this.report,
    required this.filterState,
    required this.filterText,
    required this.filterTextController,
    required this.selectionState,
  }) : super(key: key);

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  List reports = [];
  List filteredReports = [];
  TextEditingController controller = TextEditingController();

  int indexCheck = -1;
  int initialIndex = -1;

  @override
  void initState() {
    setState(() {
      filteredReports = widget.report;
      reports = widget.report;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReportList oldWidget) {
    if (widget.report.toString().length != reports.toString().length) {
      setState(() {
        filteredReports = widget.report;
        reports = widget.report;
      });
    } else if (widget.filterText.isNotEmpty) {
      setState(() {
        filteredReports = widget.report
            .where(
                (element) => element.document.fields.reportNumber.stringValue.toLowerCase().contains(widget.filterText))
            .toList();
      });
    } else {
      setState(() {
        filteredReports = widget.report;
        reports = widget.report;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        widget.filterState
            ? Flexible(
                child: filteredReports.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '(≥o≤)',
                              style: TextStyle(
                                fontSize: 180,
                                color: kGreyColor.withOpacity(0.25),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Can’t find any reports.',
                              style: TextStyle(fontSize: 24, color: kGreyColor),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  widget.filterTextController.clear();
                                });
                              },
                              child: Text(
                                ' Clear your filters and try again',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(8, 20, 10, 20),
                        itemCount: filteredReports.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              widget.selectionState(false);
                              fetchSampleDetails(filteredReports[index].document.fields.sampleNumber.stringValue)
                                  .then((valueSample) {
                                fetchFarmerDetails(valueSample.first.document.fields.farmerNumber.stringValue)
                                    .then((valueFarmer) {
                                  reportNewDialog(
                                    context,
                                    filteredReports[index].document,
                                    true,
                                    valueFarmer.first.document.fields,
                                    valueSample.first.document.fields,
                                    valueSample.first.document.name,
                                    filteredReports[index].document.fields.reportStatus.booleanValue,
                                  ).then((value) => widget.selectionState(value));
                                });
                              });
                            },
                            onSecondaryTapDown: (value) {
                              showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(value.globalPosition.dx, value.globalPosition.dy,
                                      value.globalPosition.dx, value.globalPosition.dx),
                                  items: <PopupMenuEntry<gridOptions>>[
                                    PopupMenuItem(
                                        value: gridOptions.viewReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.launch_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('View'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        enabled: filteredReports[index].document.fields.reportStatus.booleanValue,
                                        value: gridOptions.previewReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.preview_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Preview'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        enabled: filteredReports[index].document.fields.reportStatus.booleanValue,
                                        value: gridOptions.downloadReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Download'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        enabled: filteredReports[index].document.fields.reportStatus.booleanValue,
                                        value: gridOptions.printReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.print_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Print'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.editReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Edit',
                                            ),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.deleteReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_forever_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Remove'),
                                          ],
                                        )),
                                  ]).then((value) {
                                switch (value) {
                                  case gridOptions.viewReport:
                                    widget.selectionState(false);
                                    fetchSampleDetails(filteredReports[index].document.fields.sampleNumber.stringValue)
                                        .then((valueSample) {
                                      fetchFarmerDetails(valueSample.first.document.fields.farmerNumber.stringValue)
                                          .then((valueFarmer) {
                                        reportNewDialog(
                                          context,
                                          filteredReports[index].document,
                                          true,
                                          valueFarmer.first.document.fields,
                                          valueSample.first.document.fields,
                                          valueSample.first.document.name,
                                          filteredReports[index].document.fields.reportStatus.booleanValue,
                                        ).then((value) => widget.selectionState(value));
                                      });
                                    });
                                    break;
                                  case gridOptions.previewReport:
                                    widget.selectionState(false);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                ),
                                                Text(
                                                  'Loading document...',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    http
                                        .get(Uri.parse(
                                            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      reportPreviewForm(context, value.bodyBytes)
                                          .then((value) => widget.selectionState(value));
                                    });
                                    break;
                                  case gridOptions.downloadReport:
                                    widget.selectionState(false);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  'Generating document...',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    http
                                        .get(Uri.parse(
                                            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      _saveFile(value.bodyBytes,
                                              filteredReports[index].document.fields.reportNumber.stringValue + '.pdf')
                                          .then((value) {
                                        if (value) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              margin: EdgeInsets.fromLTRB(16, 16, 1024, 16),
                                              behavior: SnackBarBehavior.floating,
                                              content: Text(
                                                  filteredReports[index].document.fields.reportNumber.stringValue +
                                                      '.pdf downloaded')));
                                        }
                                        widget.selectionState(true);
                                      });
                                    });
                                    break;
                                  case gridOptions.printReport:
                                    widget.selectionState(false);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                ),
                                                Text(
                                                  'Printing document...',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    http
                                        .get(Uri.parse(
                                            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      _printFile(
                                        value.bodyBytes,
                                      ).then((value) {
                                        widget.selectionState(true);
                                      });
                                    });
                                    break;
                                  case gridOptions.editReport:
                                    widget.selectionState(false);
                                    fetchSampleDetails(filteredReports[index].document.fields.sampleNumber.stringValue)
                                        .then((valueSample) {
                                      fetchFarmerDetails(valueSample.first.document.fields.farmerNumber.stringValue)
                                          .then((valueFarmer) {
                                        reportNewDialog(
                                          context,
                                          filteredReports[index].document,
                                          false,
                                          valueFarmer.first.document.fields,
                                          valueSample.first.document.fields,
                                          valueSample.first.document.name,
                                          filteredReports[index].document.fields.reportStatus.booleanValue,
                                        ).then((value) => widget.selectionState(value));
                                      });
                                    });
                                    break;
                                  case gridOptions.deleteReport:
                                    widget.selectionState(false);
                                    deleteAllDialog(
                                            context,
                                            filteredReports[index].document.fields.reportNumber.stringValue,
                                            'Report',
                                            filteredReports[index].document.fields.reportNumber.stringValue,
                                            filteredReports[index].document.name,
                                            filteredReports[index].document.fields.sampleNumber.stringValue)
                                        .then((value) => widget.selectionState(value));
                                    break;
                                  default:
                                    break;
                                }
                              });
                            },
                            child: MouseRegion(
                              onEnter: (event) {
                                setState(() {
                                  indexCheck = index;
                                });
                              },
                              onHover: (event) {
                                setState(() {
                                  indexCheck = index;
                                });
                              },
                              onExit: (event) {
                                setState(() {
                                  indexCheck = initialIndex;
                                });
                              },
                              child: Card(
                                elevation: indexCheck == index ? 8 : 2,
                                shadowColor: kGreyColor.withOpacity(0.25),
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      ClipRRect(
                                        child: Lottie.asset(
                                          filteredReports[index].document.fields.reportStatus.booleanValue
                                              ? 'assets/reportAnim.json'
                                              : 'assets/sampleAnim.json',
                                          fit: BoxFit.fill,
                                          width: 34,
                                          height: 34,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      Positioned(
                                        child: filteredReports[index].document.fields.reportStatus.booleanValue
                                            ? CircleAvatar(
                                                backgroundColor: kReportTableColor,
                                                child: Icon(
                                                  filteredReports[index].document.fields.reportStatus.booleanValue
                                                      ? Icons.done
                                                      : Icons.edit,
                                                  size: 6,
                                                ),
                                                radius: 6,
                                              )
                                            : SizedBox.shrink(),
                                        top: -3,
                                        right: -3,
                                      )
                                    ],
                                    clipBehavior: Clip.none,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 296,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredReports[index].document.fields.reportNumber.stringValue,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                                            ),
                                            Text(
                                              'Dummy',
                                              style: TextStyle(color: kGreyColor, fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 248,
                                        child: indexCheck == index
                                            ? Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.launch_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(false);
                                                      fetchSampleDetails(filteredReports[index]
                                                              .document
                                                              .fields
                                                              .sampleNumber
                                                              .stringValue)
                                                          .then((valueSample) {
                                                        fetchFarmerDetails(valueSample
                                                                .first.document.fields.farmerNumber.stringValue)
                                                            .then((valueFarmer) {
                                                          reportNewDialog(
                                                            context,
                                                            filteredReports[index].document,
                                                            true,
                                                            valueFarmer.first.document.fields,
                                                            valueSample.first.document.fields,
                                                            valueSample.first.document.name,
                                                            filteredReports[index]
                                                                .document
                                                                .fields
                                                                .reportStatus
                                                                .booleanValue,
                                                          ).then((value) => widget.selectionState(value));
                                                        });
                                                      });
                                                    },
                                                    tooltip: 'View',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.preview_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(false);
                                                      showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              elevation: 0,
                                                              content: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    strokeWidth: 3.0,
                                                                  ),
                                                                  Text(
                                                                    'Loading document...',
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                      http
                                                          .get(Uri.parse(
                                                              'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                                          .then((value) {
                                                        Navigator.of(context).pop();
                                                        reportPreviewForm(context, value.bodyBytes)
                                                            .then((value) => widget.selectionState(value));
                                                      });
                                                    },
                                                    tooltip: 'Preview',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.download_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(false);
                                                      showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              elevation: 0,
                                                              content: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    strokeWidth: 3.0,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.0,
                                                                  ),
                                                                  Text(
                                                                    'Generating document...',
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                      http
                                                          .get(Uri.parse(
                                                              'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                                          .then((value) {
                                                        Navigator.of(context).pop();
                                                        _saveFile(
                                                                value.bodyBytes,
                                                                filteredReports[index]
                                                                        .document
                                                                        .fields
                                                                        .reportNumber
                                                                        .stringValue +
                                                                    '.pdf')
                                                            .then((value) {
                                                          if (value) {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                margin: EdgeInsets.fromLTRB(16, 16, 1024, 16),
                                                                behavior: SnackBarBehavior.floating,
                                                                content: Text(filteredReports[index]
                                                                        .document
                                                                        .fields
                                                                        .reportNumber
                                                                        .stringValue +
                                                                    '.pdf downloaded')));
                                                          }
                                                          widget.selectionState(true);
                                                        });
                                                      });
                                                    },
                                                    tooltip: 'Download',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.print_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(false);
                                                      showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              elevation: 0,
                                                              content: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    strokeWidth: 3.0,
                                                                  ),
                                                                  Text(
                                                                    'Printing document...',
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                      http
                                                          .get(Uri.parse(
                                                              'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                                          .then((value) {
                                                        Navigator.of(context).pop();
                                                        _printFile(
                                                          value.bodyBytes,
                                                        ).then((value) {
                                                          widget.selectionState(true);
                                                        });
                                                      });
                                                    },
                                                    tooltip: 'Print',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(false);
                                                      fetchSampleDetails(filteredReports[index]
                                                              .document
                                                              .fields
                                                              .sampleNumber
                                                              .stringValue)
                                                          .then((valueSample) {
                                                        fetchFarmerDetails(valueSample
                                                                .first.document.fields.farmerNumber.stringValue)
                                                            .then((valueFarmer) {
                                                          reportNewDialog(
                                                            context,
                                                            filteredReports[index].document,
                                                            false,
                                                            valueFarmer.first.document.fields,
                                                            valueSample.first.document.fields,
                                                            valueSample.first.document.name,
                                                            filteredReports[index]
                                                                .document
                                                                .fields
                                                                .reportStatus
                                                                .booleanValue,
                                                          ).then((value) => widget.selectionState(value));
                                                        });
                                                      });
                                                    },
                                                    tooltip: 'Edit',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_forever_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(false);
                                                      deleteAllDialog(
                                                              context,
                                                              filteredReports[index]
                                                                  .document
                                                                  .fields
                                                                  .reportNumber
                                                                  .stringValue,
                                                              'Report',
                                                              filteredReports[index]
                                                                  .document
                                                                  .fields
                                                                  .reportNumber
                                                                  .stringValue,
                                                              filteredReports[index].document.name,
                                                              filteredReports[index]
                                                                  .document
                                                                  .fields
                                                                  .sampleNumber
                                                                  .stringValue)
                                                          .then((value) => widget.selectionState(value));
                                                    },
                                                    tooltip: 'Remove',
                                                  ),
                                                ],
                                              )
                                            : null,
                                      ),
                                      Text(
                                        DateFormat.yMMMMd('en_US')
                                            .format(DateTime.parse(filteredReports[index]
                                                    .document
                                                    .fields
                                                    .reportCreatedAt
                                                    .timestampValue)
                                                .toLocal())
                                            .toString(),
                                        style: TextStyle(color: kGreyColor, fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              )
            : Flexible(
                child: filteredReports.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '(≥o≤)',
                              style: TextStyle(
                                fontSize: 180,
                                color: kGreyColor.withOpacity(0.25),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Can’t find any reports.',
                              style: TextStyle(fontSize: 24, color: kGreyColor),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  widget.filterTextController.clear();
                                });
                              },
                              child: Text(
                                ' Clear your filters and try again',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            )
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(8, 20, 10, 20),
                        itemCount: filteredReports.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 24.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              widget.selectionState(false);
                              fetchSampleDetails(filteredReports[index].document.fields.sampleNumber.stringValue)
                                  .then((valueSample) {
                                fetchFarmerDetails(valueSample.first.document.fields.farmerNumber.stringValue)
                                    .then((valueFarmer) {
                                  reportNewDialog(
                                    context,
                                    filteredReports[index].document,
                                    true,
                                    valueFarmer.first.document.fields,
                                    valueSample.first.document.fields,
                                    valueSample.first.document.name,
                                    filteredReports[index].document.fields.reportStatus.booleanValue,
                                  ).then((value) => widget.selectionState(value));
                                });
                              });
                            },
                            onSecondaryTapDown: (value) {
                              showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(value.globalPosition.dx, value.globalPosition.dy,
                                      value.globalPosition.dx, value.globalPosition.dx),
                                  items: <PopupMenuEntry<gridOptions>>[
                                    PopupMenuItem(
                                        value: gridOptions.viewReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.launch_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('View'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        enabled: filteredReports[index].document.fields.reportStatus.booleanValue,
                                        value: gridOptions.previewReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.preview_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Preview'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        enabled: filteredReports[index].document.fields.reportStatus.booleanValue,
                                        value: gridOptions.downloadReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Download'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        enabled: filteredReports[index].document.fields.reportStatus.booleanValue,
                                        value: gridOptions.printReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.print_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Print'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.editReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Edit',
                                            ),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.deleteReport,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_forever_outlined,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Remove'),
                                          ],
                                        )),
                                  ]).then((value) {
                                switch (value) {
                                  case gridOptions.viewReport:
                                    widget.selectionState(false);
                                    fetchSampleDetails(filteredReports[index].document.fields.sampleNumber.stringValue)
                                        .then((valueSample) {
                                      fetchFarmerDetails(valueSample.first.document.fields.farmerNumber.stringValue)
                                          .then((valueFarmer) {
                                        reportNewDialog(
                                          context,
                                          filteredReports[index].document,
                                          true,
                                          valueFarmer.first.document.fields,
                                          valueSample.first.document.fields,
                                          valueSample.first.document.name,
                                          filteredReports[index].document.fields.reportStatus.booleanValue,
                                        ).then((value) => widget.selectionState(value));
                                      });
                                    });
                                    break;
                                  case gridOptions.previewReport:
                                    widget.selectionState(false);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                ),
                                                Text(
                                                  'Loading document...',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    http
                                        .get(Uri.parse(
                                            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      reportPreviewForm(context, value.bodyBytes)
                                          .then((value) => widget.selectionState(value));
                                    });
                                    break;
                                  case gridOptions.downloadReport:
                                    widget.selectionState(false);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  'Generating document...',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    http
                                        .get(Uri.parse(
                                            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      _saveFile(value.bodyBytes,
                                              filteredReports[index].document.fields.reportNumber.stringValue + '.pdf')
                                          .then((value) {
                                        if (value) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              margin: EdgeInsets.fromLTRB(16, 16, 1024, 16),
                                              behavior: SnackBarBehavior.floating,
                                              content: Text(
                                                  filteredReports[index].document.fields.reportNumber.stringValue +
                                                      '.pdf downloaded')));
                                        }
                                        widget.selectionState(true);
                                      });
                                    });
                                    break;
                                  case gridOptions.printReport:
                                    widget.selectionState(false);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                ),
                                                Text(
                                                  'Printing document...',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    http
                                        .get(Uri.parse(
                                            'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FS${filteredReports[index].document.fields.reportNumber.stringValue}.pdf?alt=media'))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      _printFile(
                                        value.bodyBytes,
                                      ).then((value) {
                                        widget.selectionState(true);
                                      });
                                    });
                                    break;
                                  case gridOptions.editReport:
                                    widget.selectionState(false);
                                    fetchSampleDetails(filteredReports[index].document.fields.sampleNumber.stringValue)
                                        .then((valueSample) {
                                      fetchFarmerDetails(valueSample.first.document.fields.farmerNumber.stringValue)
                                          .then((valueFarmer) {
                                        reportNewDialog(
                                          context,
                                          filteredReports[index].document,
                                          false,
                                          valueFarmer.first.document.fields,
                                          valueSample.first.document.fields,
                                          valueSample.first.document.name,
                                          filteredReports[index].document.fields.reportStatus.booleanValue,
                                        ).then((value) => widget.selectionState(value));
                                      });
                                    });
                                    break;
                                  case gridOptions.deleteReport:
                                    widget.selectionState(false);
                                    deleteAllDialog(
                                            context,
                                            filteredReports[index].document.fields.reportNumber.stringValue,
                                            'Report',
                                            filteredReports[index].document.fields.reportNumber.stringValue,
                                            filteredReports[index].document.name,
                                            filteredReports[index].document.fields.sampleNumber.stringValue)
                                        .then((value) => widget.selectionState(value));
                                    break;
                                  default:
                                    break;
                                }
                              });
                            },
                            child: MouseRegion(
                              onEnter: (event) {
                                setState(() {
                                  indexCheck = index;
                                });
                              },
                              onHover: (event) {
                                setState(() {
                                  indexCheck = index;
                                });
                              },
                              onExit: (event) {
                                setState(() {
                                  indexCheck = initialIndex;
                                });
                              },
                              child: Card(
                                elevation: indexCheck == index ? 8 : 2,
                                shadowColor: kGreyColor.withOpacity(0.25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          child: Lottie.asset(
                                              filteredReports[index].document.fields.reportStatus.booleanValue
                                                  ? 'assets/reportAnim.json'
                                                  : 'assets/sampleAnim.json',
                                              fit: BoxFit.fill,
                                              width: 100,
                                              height: 100,
                                              animate: indexCheck == index),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        Positioned(
                                          child: CircleAvatar(
                                            backgroundColor: kReportTableColor,
                                            child: Icon(
                                              filteredReports[index].document.fields.reportStatus.booleanValue
                                                  ? Icons.done
                                                  : Icons.edit,
                                              size: 10,
                                            ),
                                            radius: 8,
                                          ),
                                          top: -6,
                                          right: -6,
                                        )
                                      ],
                                      alignment: AlignmentDirectional.topEnd,
                                      clipBehavior: Clip.none,
                                    ),
                                    SizedBox(
                                      height: 14.0,
                                    ),
                                    Text(
                                      filteredReports[index].document.fields.reportNumber.stringValue,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 14.0,
                                    ),
                                    Text(
                                      DateFormat.yMMMMd('en_US')
                                          .format(DateTime.parse(
                                                  filteredReports[index].document.fields.reportCreatedAt.timestampValue)
                                              .toLocal())
                                          .toString(),
                                      style: TextStyle(color: kGreyColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ],
    );
  }
}

// import 'dart:async';
//
// import 'package:agrigo_kia/constants/colors.dart';
// import 'package:agrigo_kia/models/report_PreForm.dart';
// import 'package:agrigo_kia/models/report_editForm.dart';
// import 'package:agrigo_kia/models/report_page_model.dart';
// import 'package:agrigo_kia/models/sample_query_model.dart';
// import 'package:agrigo_kia/models/farmer_query_model.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
//
// class ReportForm extends StatefulWidget {
//   final bool connectionState;
//   final Function selectionState;
//   ReportForm(
//       {Key? key, required this.connectionState, required this.selectionState})
//       : super(key: key);
//   @override
//   _ReportFormState createState() => _ReportFormState();
// }
//
// class _ReportFormState extends State<ReportForm> with TickerProviderStateMixin {
//   late TabController _tabController;
//
//   //Farmers
//   StreamController<Reports> _reportController =
//       StreamController<Reports>.broadcast();
//
//   Future<Reports> fetchReports() async {
//     final response = await http.get(Uri.parse(
//         'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents/reports'));
//     return Reports.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
//   }
//
//   loadData() async {
//     fetchReports().then((res) async {
//       _reportController.add(res);
//     });
//   }
//
//   String greeting() {
//     var hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Good Morning';
//     }
//     if (hour < 17) {
//       return 'Good Afternoon';
//     }
//     return 'Good Evening';
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     Timer.periodic(Duration(seconds: 1), (_) => loadData());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 112, top: 24, right: 112, bottom: 24),
//       child: Container(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(152, 36),
//                   ),
//                   onPressed: () async {
//                     await reportPreForm(context).then((valueSample) =>
//                         print(valueSample.toString() + 'here'));
//                   },
//                   icon: Icon(Icons.add, size: 18),
//                   label: Text('New Report'),
//                 ),
//                 Text(greeting() +
//                     ', ' +
//                     DateFormat.yMMMMEEEEd().format(DateTime.now())),
//               ],
//             ),
//             SizedBox(
//               height: 56,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 PreferredSize(
//                   preferredSize: Size.fromHeight(0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: TabBar(
//                       isScrollable: true,
//                       controller: _tabController,
//                       tabs: <Widget>[
//                         Text(
//                           'Reports',
//                         ),
//                         Text('Others'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   splashRadius: 16,
//                   icon: Icon(
//                     Icons.filter_list,
//                     color: kPrimaryColor,
//                   ),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: <Widget>[
//                   StreamBuilder<Reports>(
//                     stream: _reportController.stream,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) print(snapshot.error);
//                       return snapshot.hasData
//                           ? ReportList(report: snapshot.data!)
//                           : Center(child: CircularProgressIndicator());
//                     },
//                   ),
//                   Text('data'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ReportList extends StatefulWidget {
//   final Reports report;
//
//   ReportList({Key? key, required this.report}) : super(key: key);
//
//   @override
//   _ReportListState createState() => _ReportListState();
// }
//
// class _ReportListState extends State<ReportList> {
//   List reports = [];
//   List filteredReports = [];
//   TextEditingController controller = TextEditingController();
//
//   @override
//   void initState() {
//     setState(() {
//       filteredReports = widget.report.documents;
//       reports = widget.report.documents;
//     });
//     super.initState();
//   }
//
//   onSearchTextChanged(String text) async {
//     setState(() {
//       filteredReports = widget.report.documents
//           .where((element) => element.fields.sampleNumber.stringValue == text)
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           child: ListTile(
//             leading: Icon(Icons.search),
//             title: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 border: InputBorder.none,
//               ),
//               onChanged: onSearchTextChanged,
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.cancel),
//               onPressed: () {
//                 controller.clear();
//                 filteredReports = reports.toList();
//               },
//             ),
//           ),
//         ),
//         Flexible(
//           child: filteredReports.length == 0
//               ? Center(
//                   child: Text('No Data'),
//                 )
//               : ListView.builder(
//                   itemCount: filteredReports.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: 8.0),
//                       child: GestureDetector(
//                         onTap: () async {
//                           sampleDetails(filteredReports[index]
//                                   .fields
//                                   .sampleNumber
//                                   .stringValue)
//                               .then((sample) => farmerDetails(sample[0]
//                                       .document
//                                       .fields
//                                       .farmerNumber
//                                       .stringValue)
//                                   .then((farmer) => reportEditDialog(context,
//                                       filteredReports[index], sample, farmer)));
//                         },
//                         child: Container(
//                           color: Colors.green,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(filteredReports[index]
//                                         .fields
//                                         .sampleNumber
//                                         .stringValue),
//                                     Text(filteredReports[index]
//                                         .fields
//                                         .sampleNumber
//                                         .stringValue),
//                                   ],
//                                 ),
//                                 Icon(Icons.ice_skating),
//                                 Text(filteredReports[index]
//                                     .fields
//                                     .reportNumber
//                                     .stringValue)
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//       ],
//     );
//   }
// }
//
// Future<List<FarmerQuery>> farmerDetails(String afn) async {
//   var farmerData = jsonEncode({
//     "structuredQuery": {
//       "from": [
//         {"collectionId": "farmers", "allDescendants": true}
//       ],
//       "where": {
//         "fieldFilter": {
//           "field": {"fieldPath": "farmerNumber"},
//           "op": "EQUAL",
//           "value": {
//             "stringValue": afn,
//           }
//         }
//       }
//     }
//   });
//
//   final responseFarmer = await http.post(
//     Uri.parse(
//         'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents:runQuery'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: farmerData,
//   );
//
//   return parseFarmerQuery(utf8.decode(responseFarmer.bodyBytes));
// }
//
// List<FarmerQuery> parseFarmerQuery(String bodyBytes) {
//   final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();
//
//   return parsed.map<FarmerQuery>((json) => FarmerQuery.fromJson(json)).toList();
// }
//
// Future<List<SampleQuery>> sampleDetails(String asn) async {
//   var sampleData = jsonEncode({
//     "structuredQuery": {
//       "from": [
//         {"collectionId": "samples", "allDescendants": true}
//       ],
//       "where": {
//         "fieldFilter": {
//           "field": {"fieldPath": "sampleNumber"},
//           "op": "EQUAL",
//           "value": {
//             "stringValue": asn,
//           }
//         }
//       }
//     }
//   });
//   final responseSample = await http.post(
//     Uri.parse(
//         'http://localhost:8080/v1/projects/coun-ab246/databases/(default)/documents:runQuery'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: sampleData,
//   );
//
//   return parseSampleQuery(utf8.decode(responseSample.bodyBytes));
// }
//
// List<SampleQuery> parseSampleQuery(String bodyBytes) {
//   final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();
//
//   return parsed.map<SampleQuery>((json) => SampleQuery.fromJson(json)).toList();
// }

Future<bool> _saveFile(fileData, fileName) async {
  final path = await FileSelectorPlatform.instance.getSavePath(
    suggestedName: fileName,
  );
  if (path == null) {
    return false;
  }

  const fileMimeType = 'application/pdf';
  final textFile = XFile.fromData(fileData, mimeType: fileMimeType, name: fileName);
  await textFile.saveTo(path);
  return true;
}

Future<bool> _printFile(fileData) async {
  return true;
}
