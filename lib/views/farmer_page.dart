import 'dart:async';
import 'dart:convert';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:agrigo_kia/models/delete_allDialog.dart';
import 'package:agrigo_kia/models/farmer_newForm.dart';
import 'package:agrigo_kia/models/farmer_query_model.dart';
import 'package:agrigo_kia/models/insert_allDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

enum sortOptions { lastModByMe, lastCreByMe, lastMod, lastCre, name }
enum gridOptions { editFarmer, deleteFarmer, addSample }

class FarmerForm extends StatefulWidget {
  final bool connectionState;
  final Function selectionState;
  FarmerForm(
      {Key? key, required this.connectionState, required this.selectionState})
      : super(key: key);
  @override
  _FarmerFormState createState() => _FarmerFormState();
}

class _FarmerFormState extends State<FarmerForm> with TickerProviderStateMixin {
  late TabController _tabController;
  //
  bool filterState = false;
  var selectedOption = sortOptions.name;
  var currentOption = 'firstName';
  bool sortBy = false;
  //
  TextEditingController _searchFilterController = TextEditingController();
  bool searchState = false;
  //
  late Timer _timer;
  //Connection
  late bool currentConnection;

  //Farmers
  StreamController<List<FarmerQuery>> _farmerController =
      StreamController<List<FarmerQuery>>.broadcast();

  Future<List<FarmerQuery>> fetchFarmersSort(
      String sortOption, String sortMe, bool sortBy) async {
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
          {"collectionId": "farmers", "allDescendants": true}
        ]
      }
    });
    var queryStructure = jsonEncode({
      "structuredQuery": {
        "orderBy": [
          {
            "field": {"fieldPath": sortOption},
            "direction": sortOption == 'firstName' ? "ASCENDING" : "DESCENDING"
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
        body: sortBy ? queryStructureBy : queryStructure);
    return parseFarmerQuery(utf8.decode(response.bodyBytes));
  }

  List<FarmerQuery> parseFarmerQuery(String bodyBytes) {
    final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

    return parsed
        .map<FarmerQuery>((json) => FarmerQuery.fromJson(json))
        .toList();
  }

  loadData() async {
    fetchFarmersSort(currentOption, 'Y3B6AadviKsLu0QZbHoANIYyjqyy', sortBy)
        .then((res) {
      _farmerController.add(res);
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
  void didUpdateWidget(covariant FarmerForm oldWidget) {
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
                    await farmerNewDialog(context, null, false, null);
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text("New Farmer"),
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
                              currentOption = 'firstName';
                              sortBy = false;
                            });
                            break;
                          case 1:
                            _tabController.index = _tabController.previousIndex;
                            break;
                        }
                      },
                      tabs: <Widget>[
                        Text(
                          'Farmers',
                        ),
                        Text(
                          'Others',
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
                      offset: Offset(100, 50),
                      tooltip: 'Sort options',
                      icon: Icon(
                        Icons.sort_by_alpha_outlined,
                        color: kPrimaryColor,
                      ),
                      onSelected: (sortOptions result) {
                        switch (result) {
                          case sortOptions.lastModByMe:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'farmerModifiedBy';
                              sortBy = true;
                            });
                            break;
                          case sortOptions.lastCreByMe:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'farmerCreatedBy';
                              sortBy = true;
                            });
                            break;
                          case sortOptions.lastMod:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'farmerModifiedAt';
                              sortBy = false;
                            });
                            break;
                          case sortOptions.lastCre:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'farmerCreatedAt';
                              sortBy = false;
                            });
                            break;
                          case sortOptions.name:
                            setState(() {
                              selectedOption = result;
                              currentOption = 'firstName';
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
                          checked: sortOptions.name == selectedOption,
                          value: sortOptions.name,
                          child: Text('Name'),
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
                  StreamBuilder<List<FarmerQuery>>(
                    stream: _farmerController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? FarmerList(
                              farmer: snapshot.data!,
                              filterState: filterState,
                              filterText: _searchFilterController.text,
                              filterTextController: _searchFilterController,
                              selectionState: widget.selectionState,
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                  Text('Disabled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerList extends StatefulWidget {
  final List<FarmerQuery> farmer;
  final bool filterState;
  final String filterText;
  final TextEditingController filterTextController;
  final Function selectionState;
  FarmerList({
    Key? key,
    required this.farmer,
    required this.filterState,
    required this.filterText,
    required this.filterTextController,
    required this.selectionState,
  }) : super(key: key);

  @override
  _FarmerListState createState() => _FarmerListState();
}

class _FarmerListState extends State<FarmerList> {
  List farmers = [];
  List filteredFarmers = [];
  TextEditingController controller = TextEditingController();

  int indexCheck = -1;
  int initialIndex = -1;

  @override
  void initState() {
    setState(() {
      filteredFarmers = widget.farmer;
      farmers = widget.farmer;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FarmerList oldWidget) {
    if (widget.farmer.toString().length != farmers.toString().length) {
      setState(() {
        filteredFarmers = widget.farmer;
        farmers = widget.farmer;
      });
    } else if (widget.filterText.isNotEmpty) {
      setState(() {
        filteredFarmers = widget.farmer
            .where((element) => element.document.fields.firstName.stringValue
                .toLowerCase()
                .contains(widget.filterText))
            .toList();
      });
    } else {
      setState(() {
        filteredFarmers = widget.farmer;
        farmers = widget.farmer;
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
                child: filteredFarmers.length == 0
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
                              'Can’t find any farmers.',
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
                        itemCount: filteredFarmers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              widget.selectionState(false);
                              farmerNewDialog(
                                      context,
                                      filteredFarmers[index].document.fields,
                                      true,
                                      null)
                                  .then(
                                      (value) => widget.selectionState(value));
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
                                    PopupMenuItem(
                                        value: gridOptions.addSample,
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
                                            Text('Add sample'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.editFarmer,
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
                                        value: gridOptions.deleteFarmer,
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
                                  case gridOptions.addSample:
                                    widget.selectionState(false);
                                    insertAllDialog(
                                      context,
                                      filteredFarmers[index]
                                          .document
                                          .fields
                                          .farmerNumber
                                          .stringValue,
                                      'Sample',
                                    ).then((value) =>
                                        widget.selectionState(value));
                                    break;
                                  case gridOptions.editFarmer:
                                    widget.selectionState(false);
                                    farmerNewDialog(
                                            context,
                                            filteredFarmers[index]
                                                .document
                                                .fields,
                                            false,
                                            filteredFarmers[index]
                                                .document
                                                .name)
                                        .then((value) =>
                                            widget.selectionState(value));
                                    break;
                                  case gridOptions.deleteFarmer:
                                    widget.selectionState(false);
                                    deleteAllDialog(
                                            context,
                                            filteredFarmers[index]
                                                    .document
                                                    .fields
                                                    .firstName
                                                    .stringValue +
                                                ' ' +
                                                filteredFarmers[index]
                                                    .document
                                                    .fields
                                                    .lastName
                                                    .stringValue,
                                            'Farmer',
                                            filteredFarmers[index]
                                                .document
                                                .fields
                                                .farmerNumber
                                                .stringValue,
                                            filteredFarmers[index]
                                                .document
                                                .name,
                                            filteredFarmers[index]
                                                .document
                                                .fields
                                                .farmerRefresh
                                                .stringValue)
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
                                child: ListTile(
                                  leading: ClipRRect(
                                    child: Image.network(
                                      filteredFarmers[index]
                                          .document
                                          .fields
                                          .profilePicture
                                          .mapValue
                                          .fields
                                          .mn0
                                          .mapValue
                                          .fields
                                          .mnM0
                                          .stringValue,
                                      fit: BoxFit.fill,
                                      width: 34,
                                      height: 34,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
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
                                              filteredFarmers[index]
                                                      .document
                                                      .fields
                                                      .firstName
                                                      .stringValue +
                                                  ' ' +
                                                  filteredFarmers[index]
                                                      .document
                                                      .fields
                                                      .lastName
                                                      .stringValue,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              filteredFarmers[index]
                                                  .document
                                                  .fields
                                                  .emailAddress
                                                  .mapValue
                                                  .fields
                                                  .mn0
                                                  .mapValue
                                                  .fields
                                                  .eaM0
                                                  .stringValue,
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
                                                      Icons.post_add_rounded,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(
                                                          false);
                                                      insertAllDialog(
                                                        context,
                                                        filteredFarmers[index]
                                                            .document
                                                            .fields
                                                            .farmerNumber
                                                            .stringValue,
                                                        'Sample',
                                                      ).then((value) =>
                                                          widget.selectionState(
                                                              value));
                                                    },
                                                    tooltip: 'Add sample',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(
                                                          false);
                                                      farmerNewDialog(
                                                              context,
                                                              filteredFarmers[
                                                                      index]
                                                                  .document
                                                                  .fields,
                                                              false,
                                                              filteredFarmers[
                                                                      index]
                                                                  .document
                                                                  .name)
                                                          .then((value) => widget
                                                              .selectionState(
                                                                  value));
                                                    },
                                                    tooltip: 'Edit',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .delete_forever_outlined,
                                                      size: 24,
                                                      color: kGreyColor,
                                                    ),
                                                    onPressed: () {
                                                      widget.selectionState(
                                                          false);
                                                      deleteAllDialog(
                                                              context,
                                                              filteredFarmers[
                                                                          index]
                                                                      .document
                                                                      .fields
                                                                      .firstName
                                                                      .stringValue +
                                                                  ' ' +
                                                                  filteredFarmers[
                                                                          index]
                                                                      .document
                                                                      .fields
                                                                      .lastName
                                                                      .stringValue,
                                                              'Farmer',
                                                              filteredFarmers[
                                                                      index]
                                                                  .document
                                                                  .fields
                                                                  .farmerNumber
                                                                  .stringValue,
                                                              filteredFarmers[
                                                                      index]
                                                                  .document
                                                                  .name,
                                                              filteredFarmers[
                                                                      index]
                                                                  .document
                                                                  .fields
                                                                  .farmerRefresh
                                                                  .stringValue)
                                                          .then((value) => widget
                                                              .selectionState(
                                                                  value));
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
                                                    filteredFarmers[index]
                                                        .document
                                                        .fields
                                                        .farmerCreatedAt
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
                child: filteredFarmers.length == 0
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
                              'Can’t find any farmers.',
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
                        itemCount: filteredFarmers.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 24.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              widget.selectionState(false);
                              farmerNewDialog(
                                      context,
                                      filteredFarmers[index].document.fields,
                                      true,
                                      null)
                                  .then(
                                      (value) => widget.selectionState(value));
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
                                    PopupMenuItem(
                                        value: gridOptions.addSample,
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
                                            Text('Add sample'),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: gridOptions.editFarmer,
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
                                        value: gridOptions.deleteFarmer,
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
                                  case gridOptions.addSample:
                                    widget.selectionState(false);
                                    insertAllDialog(
                                      context,
                                      filteredFarmers[index]
                                          .document
                                          .fields
                                          .farmerNumber
                                          .stringValue,
                                      'Sample',
                                    ).then((value) =>
                                        widget.selectionState(value));
                                    break;
                                  case gridOptions.editFarmer:
                                    widget.selectionState(false);
                                    farmerNewDialog(
                                            context,
                                            filteredFarmers[index]
                                                .document
                                                .fields,
                                            false,
                                            filteredFarmers[index]
                                                .document
                                                .name)
                                        .then((value) =>
                                            widget.selectionState(value));
                                    break;
                                  case gridOptions.deleteFarmer:
                                    widget.selectionState(false);
                                    deleteAllDialog(
                                            context,
                                            filteredFarmers[index]
                                                    .document
                                                    .fields
                                                    .firstName
                                                    .stringValue +
                                                ' ' +
                                                filteredFarmers[index]
                                                    .document
                                                    .fields
                                                    .lastName
                                                    .stringValue,
                                            'Farmer',
                                            filteredFarmers[index]
                                                .document
                                                .fields
                                                .farmerNumber
                                                .stringValue,
                                            filteredFarmers[index]
                                                .document
                                                .name,
                                            filteredFarmers[index]
                                                .document
                                                .fields
                                                .farmerRefresh
                                                .stringValue)
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
                                    ClipRRect(
                                      child: Stack(
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade100,
                                            highlightColor:
                                                Colors.grey.shade300,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          Image.network(
                                            filteredFarmers[index]
                                                .document
                                                .fields
                                                .profilePicture
                                                .mapValue
                                                .fields
                                                .mn0
                                                .mapValue
                                                .fields
                                                .mnM0
                                                .stringValue,
                                            fit: BoxFit.fill,
                                            height: 100,
                                            width: 100,
                                          ),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    SizedBox(
                                      height: 14.0,
                                    ),
                                    Text(
                                      filteredFarmers[index]
                                              .document
                                              .fields
                                              .firstName
                                              .stringValue +
                                          ' ' +
                                          filteredFarmers[index]
                                              .document
                                              .fields
                                              .lastName
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
                                                  filteredFarmers[index]
                                                      .document
                                                      .fields
                                                      .farmerCreatedAt
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
