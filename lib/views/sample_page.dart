import 'dart:async';
import 'dart:convert';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:agrigo_kia/models/delete_allDialog.dart';
import 'package:agrigo_kia/models/farmer_newForm.dart';
import 'package:agrigo_kia/models/report_newForm.dart';
import 'package:agrigo_kia/models/sample_query_model.dart';
import 'package:agrigo_kia/resources/fetch_model.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

enum sortOptions {
  lastModByMe,
  lastCreByMe,
  lastMod,
  lastCre,
  samplePending,
  sampleCompleted,
  sampleNumber
}
enum gridOptions { deleteSample, viewFarmer, viewReport, addReport }

class SampleForm extends StatefulWidget {
  final bool connectionState;
  final Function selectionState;
  SampleForm(
      {Key? key, required this.connectionState, required this.selectionState})
      : super(key: key);
  @override
  _SampleFormState createState() => _SampleFormState();
}

class _SampleFormState extends State<SampleForm> with TickerProviderStateMixin {
  late TabController _tabController;
  //
  bool filterState = false;
  var selectedOption = sortOptions.sampleNumber;
  var currentOption = 'sampleNumber';
  bool sortBy = false;
  bool sortOn = false;
  //
  TextEditingController _searchFilterController = TextEditingController();
  bool searchState = false;
  //
  late Timer _timer;
  //Connection
  late bool currentConnection;

  //Samples
  int sampleCount = 0;
  int totalCount = 0;
  StreamController<List<SampleQuery>> _sampleController =
      StreamController<List<SampleQuery>>.broadcast();

  Future<List<SampleQuery>> fetchSamplesSort(
      String sortOption, String sortMe, bool sortBy, bool sortOn) async {
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
          {"collectionId": "samples", "allDescendants": true}
        ]
      }
    });
    var queryStructure = sortOption == "reportCreated"
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
              "orderBy": [
                {
                  "field": {"fieldPath": sortOption},
                  "direction":
                      sortOption == 'sampleNumber' ? "ASCENDING" : "DESCENDING"
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
        body: sortBy ? queryStructureBy : queryStructure);
    return parseSampleQuery(utf8.decode(response.bodyBytes));
  }

  List<SampleQuery> parseSampleQuery(String bodyBytes) {
    final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

    return parsed
        .map<SampleQuery>((json) => SampleQuery.fromJson(json))
        .toList();
  }

  loadData() async {
    fetchSamplesSort(
            currentOption, 'Y3B6AadviKsLu0QZbHoANIYyjqyy', sortBy, sortOn)
        .then((res) {
      _sampleController.add(res);
      setState(() {
        sampleCount = 0;
        totalCount = res.length;
      });
      res.forEach((element) {
        if (element.document.fields.reportCreated.booleanValue == false) {
          setState(() {
            sampleCount = sampleCount + 1;
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
    _timer = Timer.periodic(
        Duration(seconds: 1), (_) => currentConnection ? loadData() : null);
  }

  @override
  void didUpdateWidget(covariant SampleForm oldWidget) {
    print(widget.connectionState);
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
                    //await insertAllDialog(context, null, 'Sample');
                    await createData("ASN20211").then((value) => print(value));
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text("New Sample"),
                ),
                Text(greeting() +
                    ', ' +
                    DateFormat.yMMMMEEEEd().format(DateTime.now())),
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
                              currentOption = 'sampleNumber';
                              sortBy = false;
                              sortOn = false;
                            });
                            break;
                          case 1:
                            sampleCount == 0
                                ? _tabController.index =
                                    _tabController.previousIndex
                                : setState(() {
                                    currentOption = 'reportCreated';
                                    sortBy = false;
                                    sortOn = false;
                                  });
                            break;
                        }
                      },
                      tabs: <Widget>[
                        Text(
                          'Samples',
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              'Pending',
                            ),
                            Positioned(
                              child: CircleAvatar(
                                backgroundColor: _tabController.index == 1
                                    ? kPrimaryColor
                                    : kGreyColor,
                                child: Text(
                                  sampleCount > 9
                                      ? '9+'
                                      : sampleCount.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
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
                            icon: searchState
                                ? Icon(Icons.clear)
                                : Icon(Icons.filter_alt_outlined),
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
                        color: _tabController.index == 0
                            ? kPrimaryColor
                            : kGreyColor,
                      ),
                      onSelected: (sortOptions result) {
                        switch (result) {
                          case sortOptions.lastModByMe:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'sampleModifiedBy';
                              sortBy = true;
                            });
                            break;
                          case sortOptions.lastCreByMe:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'sampleCreatedBy';
                              sortBy = true;
                            });
                            break;
                          case sortOptions.lastMod:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'sampleModifiedAt';
                              sortBy = false;
                            });
                            break;
                          case sortOptions.lastCre:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'sampleCreatedAt';
                              sortBy = false;
                            });
                            break;
                          case sortOptions.samplePending:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportCreated';
                              sortBy = false;
                              sortOn = false;
                            });
                            break;
                          case sortOptions.sampleCompleted:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'reportCreated';
                              sortBy = false;
                              sortOn = true;
                            });
                            break;
                          case sortOptions.sampleNumber:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'sampleNumber';
                              sortBy = false;
                            });
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<sortOptions>>[
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
                          enabled: sampleCount != totalCount,
                          checked:
                              sortOptions.sampleCompleted == selectedOption,
                          value: sortOptions.sampleCompleted,
                          child: Text('Completed'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          enabled: sampleCount == 0 ? false : true,
                          checked: sortOptions.samplePending == selectedOption,
                          value: sortOptions.samplePending,
                          child: Text('Pending'),
                        ),
                        CheckedPopupMenuItem<sortOptions>(
                          checked: sortOptions.sampleNumber == selectedOption,
                          value: sortOptions.sampleNumber,
                          child: Text('Number'),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: filterState ? 'Grid view' : 'List view',
                      splashRadius: 16,
                      icon: Icon(
                        filterState
                            ? Icons.view_module_outlined
                            : Icons.view_list_outlined,
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
                  StreamBuilder<List<SampleQuery>>(
                    stream: _sampleController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? SampleList(
                              sample: snapshot.data!,
                              filterState: filterState,
                              filterText: _searchFilterController.text,
                              filterTextController: _searchFilterController,
                              selectionState: widget.selectionState,
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                  StreamBuilder<List<SampleQuery>>(
                    stream: _sampleController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? SampleList(
                              sample: snapshot.data!,
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

class SampleList extends StatefulWidget {
  final List<SampleQuery> sample;
  final bool filterState;
  final String filterText;
  final TextEditingController filterTextController;
  final Function selectionState;
  SampleList({
    Key? key,
    required this.sample,
    required this.filterState,
    required this.filterText,
    required this.filterTextController,
    required this.selectionState,
  }) : super(key: key);

  @override
  _SampleListState createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {
  List samples = [];
  List filteredSamples = [];
  TextEditingController controller = TextEditingController();

  int indexCheck = -1;
  int initialIndex = -1;

  @override
  void initState() {
    setState(() {
      filteredSamples = widget.sample;
      samples = widget.sample;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SampleList oldWidget) {
    if (widget.sample.toString().length != samples.toString().length) {
      setState(() {
        filteredSamples = widget.sample;
        samples = widget.sample;
      });
    } else if (widget.filterText.isNotEmpty) {
      setState(() {
        filteredSamples = widget.sample
            .where((element) => element.document.fields.sampleNumber.stringValue
                .toLowerCase()
                .contains(widget.filterText))
            .toList();
      });
    } else {
      setState(() {
        filteredSamples = widget.sample;
        samples = widget.sample;
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
                child: filteredSamples.length == 0
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
                              'Can’t find any samples.',
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
                        itemCount: filteredSamples.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(
                                  text: filteredSamples[index]
                                      .document
                                      .fields
                                      .sampleNumber
                                      .stringValue));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  margin: EdgeInsets.fromLTRB(16, 16, 1024, 16),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      'Copied ${filteredSamples[index].document.fields.sampleNumber.stringValue}'),
                                ),
                              );
                            },
                            onTap: () {
                              // widget.selectionState(false);
                              // farmerNewDialog(
                              //         context,
                              //         filteredSamples[index].document.fields,
                              //         true,
                              //         null)
                              //     .then(
                              //         (value) => widget.selectionState(value));
                            },
                            onSecondaryTapDown: (value) {
                              showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                      value.globalPosition.dx,
                                      value.globalPosition.dy,
                                      value.globalPosition.dx,
                                      value.globalPosition.dx),
                                  items: <PopupMenuEntry<gridOptions>>[
                                    filteredSamples[index]
                                            .document
                                            .fields
                                            .reportCreated
                                            .booleanValue
                                        ? PopupMenuItem(
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
                                                Text(
                                                  'View report',
                                                ),
                                              ],
                                            ))
                                        : PopupMenuItem(
                                            value: gridOptions.addReport,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.post_add_rounded,
                                                  size: 24,
                                                  color: kGreyColor,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text('Add report'),
                                              ],
                                            )),
                                    PopupMenuItem(
                                        value: gridOptions.viewFarmer,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.nature_people,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('View farmer'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.deleteSample,
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
                                  case gridOptions.addReport:
                                    // widget.selectionState(false);
                                    // insertAllDialog(
                                    //   context,
                                    //   filteredSamples[index]
                                    //       .document
                                    //       .fields
                                    //       .farmerNumber
                                    //       .stringValue,
                                    //   'Sample',
                                    // ).then((value) =>
                                    //     widget.selectionState(value));
                                    break;
                                  case gridOptions.viewReport:
                                    // widget.selectionState(false);
                                    // farmerNewDialog(
                                    //         context,
                                    //         filteredSamples[index]
                                    //             .document
                                    //             .fields,
                                    //         false,
                                    //         filteredSamples[index]
                                    //             .document
                                    //             .name)
                                    //     .then((value) =>
                                    //         widget.selectionState(value));
                                    break;
                                  case gridOptions.viewFarmer:
                                    widget.selectionState(false);
                                    fetchFarmerDetails(filteredSamples[index]
                                            .document
                                            .fields
                                            .farmerNumber
                                            .stringValue)
                                        .then((value) => farmerNewDialog(
                                                context,
                                                value.first.document.fields,
                                                true,
                                                null)
                                            .then((value) =>
                                                widget.selectionState(value)));
                                    break;
                                  case gridOptions.deleteSample:
                                    // widget.selectionState(false);
                                    // deleteAllDialog(
                                    //         context,
                                    //         filteredSamples[index]
                                    //                 .document
                                    //                 .fields
                                    //                 .firstName
                                    //                 .stringValue +
                                    //             ' ' +
                                    //             filteredSamples[index]
                                    //                 .document
                                    //                 .fields
                                    //                 .lastName
                                    //                 .stringValue,
                                    //         'Farmer',
                                    //         filteredSamples[index]
                                    //             .document
                                    //             .fields
                                    //             .farmerNumber
                                    //             .stringValue,
                                    //         filteredSamples[index]
                                    //             .document
                                    //             .name,
                                    //         filteredSamples[index]
                                    //             .document
                                    //             .fields
                                    //             .farmerRefresh
                                    //             .stringValue)
                                    //     .then((value) =>
                                    //         widget.selectionState(value));
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
                                          'assets/sampleAnim.json',
                                          fit: BoxFit.fill,
                                          width: 34,
                                          height: 34,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      Positioned(
                                        child: filteredSamples[index]
                                                .document
                                                .fields
                                                .reportCreated
                                                .booleanValue
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    kReportTableColor,
                                                child: Icon(
                                                  Icons.done,
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
                                        width: 360,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredSamples[index]
                                                  .document
                                                  .fields
                                                  .sampleNumber
                                                  .stringValue,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              'Dummy',
                                              style: TextStyle(
                                                  color: kGreyColor,
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: indexCheck == index
                                            ? Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .content_copy_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: filteredSamples[
                                                                      index]
                                                                  .document
                                                                  .fields
                                                                  .sampleNumber
                                                                  .stringValue));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          margin: EdgeInsets
                                                              .fromLTRB(16, 16,
                                                                  1024, 16),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          content: Text(
                                                              'Copied ${filteredSamples[index].document.fields.sampleNumber.stringValue}'),
                                                        ),
                                                      );
                                                    },
                                                    tooltip: 'Clipboard Sample',
                                                  ),
                                                  filteredSamples[index]
                                                          .document
                                                          .fields
                                                          .reportCreated
                                                          .booleanValue
                                                      ? IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .launch_outlined,
                                                            size: 24,
                                                            color: kGreyColor,
                                                          ),
                                                          onPressed: () {
                                                            // widget.selectionState(
                                                            //     false);
                                                            // farmerNewDialog(
                                                            //         context,
                                                            //         filteredSamples[
                                                            //                 index]
                                                            //             .document
                                                            //             .fields,
                                                            //         false,
                                                            //         filteredSamples[
                                                            //                 index]
                                                            //             .document
                                                            //             .name)
                                                            //     .then((value) => widget
                                                            //         .selectionState(
                                                            //             value));
                                                          },
                                                          tooltip:
                                                              'View report',
                                                        )
                                                      : IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .post_add_rounded,
                                                            size: 24,
                                                            color: kGreyColor,
                                                          ),
                                                          onPressed: () {
                                                            // widget.selectionState(
                                                            //     false);
                                                            // insertAllDialog(
                                                            //   context,
                                                            //   filteredSamples[index]
                                                            //       .document
                                                            //       .fields
                                                            //       .farmerNumber
                                                            //       .stringValue,
                                                            //   'Sample',
                                                            // ).then((value) =>
                                                            //     widget.selectionState(
                                                            //         value));
                                                          },
                                                          tooltip: 'Add report',
                                                        ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.nature_people,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(
                                                          false);
                                                      fetchFarmerDetails(
                                                              filteredSamples[
                                                                      index]
                                                                  .document
                                                                  .fields
                                                                  .farmerNumber
                                                                  .stringValue)
                                                          .then((value) => farmerNewDialog(
                                                                  context,
                                                                  value
                                                                      .first
                                                                      .document
                                                                      .fields,
                                                                  true,
                                                                  null)
                                                              .then((value) => widget
                                                                  .selectionState(
                                                                      value)));
                                                    },
                                                    tooltip: 'View farmer',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .delete_forever_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      // widget.selectionState(
                                                      //     false);
                                                      // deleteAllDialog(
                                                      //         context,
                                                      //         filteredSamples[
                                                      //                     index]
                                                      //                 .document
                                                      //                 .fields
                                                      //                 .firstName
                                                      //                 .stringValue +
                                                      //             ' ' +
                                                      //             filteredSamples[
                                                      //                     index]
                                                      //                 .document
                                                      //                 .fields
                                                      //                 .lastName
                                                      //                 .stringValue,
                                                      //         'Farmer',
                                                      //         filteredSamples[
                                                      //                 index]
                                                      //             .document
                                                      //             .fields
                                                      //             .farmerNumber
                                                      //             .stringValue,
                                                      //         filteredSamples[
                                                      //                 index]
                                                      //             .document
                                                      //             .name,
                                                      //         filteredSamples[
                                                      //                 index]
                                                      //             .document
                                                      //             .fields
                                                      //             .farmerRefresh
                                                      //             .stringValue)
                                                      //     .then((value) => widget
                                                      //         .selectionState(
                                                      //             value));
                                                    },
                                                    tooltip: 'Remove',
                                                  ),
                                                ],
                                              )
                                            : null,
                                      ),
                                      Text(
                                        DateFormat.yMMMMd('en_US')
                                            .format(DateTime.parse(
                                                    filteredSamples[index]
                                                        .document
                                                        .fields
                                                        .sampleCreatedAt
                                                        .timestampValue)
                                                .toLocal())
                                            .toString(),
                                        style: TextStyle(
                                            color: kGreyColor, fontSize: 14.0),
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
                child: filteredSamples.length == 0
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
                              'Can’t find any samples.',
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
                        itemCount: filteredSamples.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 24.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // widget.selectionState(false);
                              // farmerNewDialog(
                              //         context,
                              //         filteredSamples[index].document.fields,
                              //         true,
                              //         null)
                              //     .then(
                              //         (value) => widget.selectionState(value));
                            },
                            onSecondaryTapDown: (value) {
                              showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                      value.globalPosition.dx,
                                      value.globalPosition.dy,
                                      value.globalPosition.dx,
                                      value.globalPosition.dx),
                                  items: <PopupMenuEntry<gridOptions>>[
                                    filteredSamples[index]
                                            .document
                                            .fields
                                            .reportCreated
                                            .booleanValue
                                        ? PopupMenuItem(
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
                                                Text(
                                                  'View report',
                                                ),
                                              ],
                                            ))
                                        : PopupMenuItem(
                                            value: gridOptions.addReport,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.post_add_rounded,
                                                  size: 24,
                                                  color: kGreyColor,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text('Add report'),
                                              ],
                                            )),
                                    PopupMenuItem(
                                        value: gridOptions.viewFarmer,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.nature_people,
                                              size: 24,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('View farmer'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.deleteSample,
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
                                  case gridOptions.addReport:
                                    widget.selectionState(false);
                                    reportNewDialog(
                                            context,
                                            null,
                                            false,
                                            null,
                                            filteredSamples[index]
                                                .document
                                                .fields,
                                            filteredSamples[index]
                                                .document
                                                .name,
                                            false)
                                        .then((value) =>
                                            widget.selectionState(value));
                                    break;
                                  case gridOptions.viewReport:
                                    widget.selectionState(false);
                                    fetchReportDetails(filteredSamples[index]
                                            .document
                                            .fields
                                            .sampleNumber
                                            .stringValue)
                                        .then((valueReport) =>
                                            fetchFarmerDetails(
                                                    filteredSamples[index]
                                                        .document
                                                        .fields
                                                        .farmerNumber
                                                        .stringValue)
                                                .then((valueFarmer) =>
                                                    reportNewDialog(
                                                      context,
                                                      valueReport
                                                          .first.document,
                                                      true,
                                                      valueFarmer.first.document
                                                          .fields,
                                                      filteredSamples[index]
                                                          .document
                                                          .fields,
                                                      filteredSamples[index]
                                                          .document
                                                          .name,
                                                      valueReport
                                                          .first
                                                          .document
                                                          .fields
                                                          .reportStatus
                                                          .booleanValue,
                                                    ).then((value) =>
                                                        widget.selectionState(
                                                            value))));
                                    break;
                                  case gridOptions.viewFarmer:
                                    widget.selectionState(false);
                                    fetchFarmerDetails(filteredSamples[index]
                                            .document
                                            .fields
                                            .farmerNumber
                                            .stringValue)
                                        .then((value) => farmerNewDialog(
                                                context,
                                                value.first.document.fields,
                                                true,
                                                null)
                                            .then((value) =>
                                                widget.selectionState(value)));
                                    break;
                                  case gridOptions.deleteSample:
                                    widget.selectionState(false);
                                    deleteAllDialog(
                                            context,
                                            filteredSamples[index]
                                                .document
                                                .fields
                                                .sampleNumber
                                                .stringValue,
                                            'Sample',
                                            filteredSamples[index]
                                                .document
                                                .fields
                                                .sampleNumber
                                                .stringValue,
                                            filteredSamples[index]
                                                .document
                                                .name,
                                            null)
                                        .then((value) =>
                                            widget.selectionState(value));
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
                                              filteredSamples[index]
                                                      .document
                                                      .fields
                                                      .reportCreated
                                                      .booleanValue
                                                  ? 'assets/reportAnim.json'
                                                  : 'assets/sampleAnim.json',
                                              fit: BoxFit.fill,
                                              width: 100,
                                              height: 100,
                                              animate: indexCheck == index),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        Positioned(
                                          child: filteredSamples[index]
                                                  .document
                                                  .fields
                                                  .reportCreated
                                                  .booleanValue
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      kReportTableColor,
                                                  child: Icon(
                                                    Icons.done,
                                                    size: 10,
                                                  ),
                                                  radius: 8,
                                                )
                                              : SizedBox.shrink(),
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
                                      filteredSamples[index]
                                          .document
                                          .fields
                                          .sampleNumber
                                          .stringValue,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 14.0,
                                    ),
                                    Text(
                                      DateFormat.yMMMMd('en_US')
                                          .format(DateTime.parse(
                                                  filteredSamples[index]
                                                      .document
                                                      .fields
                                                      .sampleCreatedAt
                                                      .timestampValue)
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

// import 'package:agrigo_kia/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:agrigo_kia/models/farmer_newForm.dart';
// import 'package:intl/intl.dart';
//
// class SampleForm extends StatefulWidget {
//   @override
//   _SampleFormState createState() => _SampleFormState();
// }
//
// class _SampleFormState extends State<SampleForm> with TickerProviderStateMixin {
//   late TabController _tabController;
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
//                     await farmerNewDialog(
//                         context, DateTime.now().toIso8601String(), null, true);
//                   },
//                   icon: Icon(Icons.add, size: 18),
//                   label: Text("New Sample"),
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
//                           'Samples',
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
//                   Text('data'),
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

Future<String> createData(String title) async {
  //https://prod-07.centralindia.logic.azure.com:443/workflows/393dc0b023c44cdd8cbaaa0bc17feb47/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=uiPT-0rlQkFfs1pNxzG9lkw2AsTAo8lz19iUChYsuzc
  //https://prod-28.centralindia.logic.azure.com:443/workflows/73e6006cff164427ace8620b28dede03/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zdu9N5i-mEx3Tk02O1MrEeS8Py6_9h48tA6YYOzBQnw
  //https://prod-24.centralindia.logic.azure.com:443/workflows/cc3daa4cc26c4527bc6aff69e68ed888/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ne-O4DxNHaY2J82NJSzhA-BLgb2sBW5IoRgkh5cVwl8
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
  List value = [
    "shanthosh",
    "ARN",
    "1256",
    "158",
    "2021",
    "2021",
    true,
    false,
    false,
    0,
    1.7,
    0,
    2.0,
    0,
    0,
    0,
    0,
    1000.0,
    0,
    0,
    172.0,
    0,
    22.0,
    0,
    0,
    0,
    100.0,
    true,
    false,
    false,
    true,
    false,
    false,
    true,
    false,
    false,
    true,
    false,
    false,
    "demo",
    "demo",
    0,
    "Choose",
    0,
    100.0,
    0,
    "Potsium",
    158.2,
    0,
    500.0,
    "Calcium",
    0,
    0,
    "demo",
    "demo",
    "demo",
    "demo"
  ];
  String fin = '';
  for (var i = 0; i <= 56; i++) {
    List condition = [
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i] == true,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i] != 0,
      value[i].toString() != "Choose",
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i].toString() != "Choose",
      value[i] != 0,
      value[i] != 0,
      value[i] != 0,
      value[i].toString() != "Choose",
      value[i] != 0,
      value[i] != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0,
      value[i].toString().length != 0
    ];
    if (condition[i]) {
      var check = value[i] == true ? "✔" : value[i];
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
  // http
  //     .get(Uri.parse(
  //         'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FgeneratedReports%2FASN20211.docx?alt=media'))
  //     .then((value) async {
  //   _saveFile(value.bodyBytes);
  // });

  return 'response.body.toString()';

  // http
  //     .get(Uri.parse(
  //         'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2FASN20211.docx?alt=media'))
  //     .then((value) async {
  //   //Printing.layoutPdf(onLayout: (_) => value.bodyBytes);
  // });
  // await Printing.layoutPdf(
  //     onLayout: (_) => pdf.readAsBytesSync().buffer.asUint8List());
  return '';
}

void _saveFile(fileData) async {
  final fileName = 'demo.docx';
  final path = await FileSelectorPlatform.instance.getSavePath(
    suggestedName: fileName,
  );
  if (path == null) {
    return;
  }

  const fileMimeType =
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  final textFile =
      XFile.fromData(fileData, mimeType: fileMimeType, name: fileName);
  await textFile.saveTo(path);
}
//
// Future<String> _openImageFile(BuildContext context) async {
//   // final fileName = 'fileName1.svg';
//   // final path = await FileSelectorPlatform.instance.getSavePath(
//   //   suggestedName: fileName,
//   // );
//   //
// final text = Uri.parse(
//     'https://avatar.oxro.io/avatar.svg?name=Sharvesh+Design&length=2&background=d6e3e9&color=2e4752');
//   // final fileData = text.data!.contentAsBytes();
//   // print(fileData);
//   // const fileMimeType = 'image/svg+xml';
//   // final textFile =
//   //     XFile.fromData(fileData, mimeType: fileMimeType, name: fileName);
//   // await textFile.saveTo(path!);
//   final typeGroup = XTypeGroup(
//     label: 'images',
//     extensions: ['jpg', 'png'],
//   );
//   final files = await FileSelectorPlatform.instance
//       .openFiles(acceptedTypeGroups: [typeGroup]);
//   if (files.isEmpty) {
//     return 'Cancel';
//   }
//   final file = files[0];
//   return file.path;
// }
