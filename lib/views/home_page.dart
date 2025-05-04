import 'dart:async';
import 'dart:ui';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:agrigo_kia/main.dart';
import 'package:agrigo_kia/models/farmer_query_model.dart';
import 'package:agrigo_kia/models/report_query_model.dart';
import 'package:agrigo_kia/models/sample_query_model.dart';
import 'package:agrigo_kia/resources/fetch_directory.dart';
import 'package:agrigo_kia/resources/fetch_model.dart';
import 'package:agrigo_kia/views/farmer_page.dart';
import 'package:agrigo_kia/views/report_page.dart';
import 'package:agrigo_kia/views/sample_page.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // void _closeDrawer() {
  //   Navigator.of(context).pop();
  // }

  //switch
  bool _switchLanguage = true;

  List<bool> _selections = [true, false, false, false];
  int _selectedIndex = 0;
  bool _selectedOption = true;
  //check callback select or none
  _selectedOptionCallBack(bool selected) {
    setState(() {
      _selectedOption = selected;
    });
  }

  //check callback current selection
  _selectionsCallBack(List<bool> selections, int selectIndex) {
    _searchCentralController.clear();
    farmerFilteredList.clear();
    sampleFilteredList.clear();
    reportFilteredList.clear();
    _searchControllerNode.unfocus();
    setState(() {
      searchCentralState = false;
      _selections = selections;
      _selectedIndex = selectIndex;
    });
  }

  TextEditingController _searchCentralController = TextEditingController();
  final _searchControllerNode = FocusNode();
  bool searchCentralState = false;
  bool profileCardState = false;
  bool searchHasFocus = false;
  //
  bool searchHasValid = false;
  List<FarmerQuery> farmerSearchValue = [];
  List<FarmerQuery> farmerFilteredList = [];
  List<SampleQuery> sampleSearchValue = [];
  List<SampleQuery> sampleFilteredList = [];
  List<ReportQuery> reportSearchValue = [];
  List<ReportQuery> reportFilteredList = [];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _connectionState = true;

  //
  String displayName = '';
  String emailId = '';
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2FAFN20210714202126.jpg?alt=media';

  void loadUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> tempData = pref.getStringList('userData') ?? [];
    setState(() {
      profilePicture = tempData[0];
      displayName = tempData[1];
      emailId = tempData[2];
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    loadUserData();

    fetchFarmerDetails('null').then((value) {
      setState(() {
        farmerSearchValue = value;
      });
    });
    fetchSampleDetails('null').then((value) {
      setState(() {
        sampleSearchValue = value;
      });
    });
    fetchReportDetails('null').then((value) {
      setState(() {
        reportSearchValue = value;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = ConnectivityResult.ethernet;
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.mobile:
        setState(() {
          _connectionStatus = result;
          _connectionState = true;
        });
        break;
      case ConnectivityResult.wifi:
        setState(() {
          _connectionStatus = result;
          _connectionState = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result;
          _connectionState = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: EdgeInsets.fromLTRB(16, 16, 1024, 16),
            behavior: SnackBarBehavior.floating,
            content: Text('No connection'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // menubar.setApplicationMenu([
    //   menubar.Submenu(label: 'File', children: [
    //     menubar.Submenu(label: 'Create', children: [
    //       menubar.MenuItem(
    //         enabled: _selectedOption,
    //         shortcut: LogicalKeySet(LogicalKeyboardKey.keyS),
    //         label: 'Farmer',
    //         onClicked: () {
    //           setState(() {
    //             _selectedOption = false;
    //           });
    //           farmerNewDialog(context, null, false, null).then((value) {
    //             setState(() {
    //               _selectedOption = value;
    //             });
    //           });
    //         },
    //       ),
    //       menubar.MenuItem(
    //         enabled: _selectedOption,
    //         shortcut: LogicalKeySet(LogicalKeyboardKey.keyS),
    //         label: 'Sample',
    //         onClicked: () {
    //           setState(() {
    //             _selectedOption = false;
    //           });
    //           insertAllDialog(context, null, 'Sample').then((value) {
    //             setState(() {
    //               _selectedOption = value;
    //             });
    //           });
    //         },
    //       ),
    //       menubar.MenuItem(
    //         enabled: _selectedOption,
    //         shortcut: LogicalKeySet(LogicalKeyboardKey.keyS),
    //         label: 'Report',
    //         onClicked: () {
    //           setState(() {
    //             _selectedOption = false;
    //           });
    //           insertAllDialog(context, null, 'Report').then((value) {
    //             setState(() {
    //               _selectedOption = value;
    //             });
    //           });
    //         },
    //       ),
    //     ]),
    //     menubar.MenuItem(
    //       enabled: _selectedOption,
    //       label: 'Search',
    //       onClicked: () {
    //         _searchControllerNode.requestFocus();
    //         setState(() {});
    //       },
    //     ),
    //     menubar.MenuDivider(),
    //     menubar.MenuItem(
    //       label: 'Preference',
    //       onClicked: () {
    //         setState(() {});
    //       },
    //     ),
    //     menubar.MenuDivider(),
    //     menubar.MenuItem(
    //       label: 'Exit Agrigo',
    //       onClicked: () {
    //         setState(() {});
    //       },
    //     ),
    //   ]),
    //   menubar.Submenu(label: 'Window', children: [
    //     menubar.MenuItem(
    //       enabled: _selectedIndex == 0 || !_selectedOption ? false : true,
    //       label: 'Dashboard',
    //       onClicked: () {
    //         setState(() {
    //           _selections = [true, false, false, false];
    //           _selectedIndex = 0;
    //         });
    //       },
    //     ),
    //     menubar.MenuItem(
    //       enabled: _selectedIndex == 1 || !_selectedOption ? false : true,
    //       label: 'Farmer',
    //       onClicked: () {
    //         setState(() {
    //           _selections = [false, true, false, false];
    //           _selectedIndex = 1;
    //         });
    //       },
    //     ),
    //     menubar.MenuItem(
    //       enabled: _selectedIndex == 2 || !_selectedOption ? false : true,
    //       label: 'Sample',
    //       onClicked: () {
    //         setState(() {
    //           _selections = [false, false, true, false];
    //           _selectedIndex = 2;
    //         });
    //       },
    //     ),
    //     menubar.MenuItem(
    //       enabled: _selectedIndex == 3 || !_selectedOption ? false : true,
    //       label: 'Report',
    //       onClicked: () {
    //         setState(() {
    //           _selections = [false, false, false, true];
    //           _selectedIndex = 3;
    //         });
    //       },
    //     ),
    //     menubar.MenuDivider(),
    //     menubar.MenuItem(
    //       label: 'Minimize',
    //       onClicked: () {},
    //     ),
    //     menubar.MenuItem(
    //       label: 'Enter Full Screen',
    //       onClicked: () {},
    //     ),
    //   ]),
    //   menubar.Submenu(label: 'About', children: [
    //     menubar.MenuItem(
    //       label: 'Agrigo account...',
    //       onClicked: () {},
    //     ),
    //     menubar.MenuItem(
    //       label: 'Sign Out',
    //       onClicked: () {},
    //     ),
    //     menubar.MenuDivider(),
    //     menubar.MenuItem(
    //       label: 'About Agrigo',
    //       onClicked: () {},
    //     ),
    //   ])
    // ]);

    _searchControllerNode.addListener(() {
      setState(() {
        searchHasFocus = _searchControllerNode.hasFocus;
      });
    });

    return GestureDetector(
      onTap: () {
        if (searchHasFocus) {
          _searchCentralController.clear();
          _searchControllerNode.unfocus();
          farmerFilteredList.clear();
          sampleFilteredList.clear();
          reportFilteredList.clear();
          setState(() {
            searchCentralState = false;
          });
        }
        setState(() {
          profileCardState = false;
        });
      },
      onSecondaryTap: () {
        if (searchHasFocus) {
          _searchCentralController.clear();
          _searchControllerNode.unfocus();
          farmerFilteredList.clear();
          sampleFilteredList.clear();
          reportFilteredList.clear();
          setState(() {
            searchCentralState = false;
          });
        }
        setState(() {
          profileCardState = false;
        });
      },
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     _connectionState
        //         ? SizedBox.shrink()
        //         : Padding(
        //             padding: EdgeInsets.all(8.0),
        //             child: Chip(
        //               backgroundColor: kWhiteColor,
        //               label: Text('offline'),
        //               labelStyle: TextStyle(color: kPrimaryColor),
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.all(Radius.circular(4))),
        //             ),
        //           ),
        //     PopupMenuButton(
        //       tooltip: 'SOIL DEV',
        //       padding: EdgeInsets.all(2),
        //       offset: Offset(0, 56),
        //       icon: CircleAvatar(
        //         backgroundImage: AssetImage('assets/sd.jpg'),
        //         backgroundColor: Color(0xFFD6E3E9),
        //       ),
        //       itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        //         PopupMenuItem(
        //           child: Tooltip(
        //             message: 'Soil Developer',
        //             verticalOffset: 10,
        //             child: Column(
        //               children: [
        //                 ListTile(
        //                   contentPadding: EdgeInsets.all(0),
        //                   leading: Container(
        //                     width: 64,
        //                     height: 64,
        //                     child: Stack(
        //                       children: [
        //                         Align(
        //                           alignment: Alignment.topCenter,
        //                           child: SizedBox(
        //                             width: 52,
        //                             child: CircleAvatar(
        //                               backgroundColor: Colors.white,
        //                               child: Align(
        //                                 alignment: Alignment.bottomRight,
        //                                 child: CircleAvatar(
        //                                   backgroundColor: Colors.lightGreen,
        //                                   radius: 8.0,
        //                                   child: Icon(
        //                                     Icons.done,
        //                                     size: 10.0,
        //                                     color: Colors.white,
        //                                   ),
        //                                 ),
        //                               ),
        //                               radius: 64.0,
        //                               backgroundImage:
        //                                   AssetImage('assets/sd.jpg'),
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                   title: Text('SOIL DEVELOPER'),
        //                   subtitle: Text(
        //                     'soil@ag.go.in',
        //                     style: TextStyle(
        //                       color: Colors.black.withOpacity(0.5),
        //                     ),
        //                   ),
        //                 ),
        //                 Divider(),
        //                 ButtonBar(
        //                   alignment: MainAxisAlignment.start,
        //                   children: [
        //                     TextButton(
        //                       onPressed: () {},
        //                       child: Text(
        //                         'Sign out',
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.normal,
        //                             color: Colors.black),
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       width: 8,
        //     )
        //   ],
        //   elevation: 2,
        //   title: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               RichText(
        //                 text: TextSpan(
        //                   children: [
        //                     TextSpan(
        //                       text: 'Agrigo',
        //                       style: TextStyle(
        //                         fontSize: 24,
        //                         fontWeight: FontWeight.w500,
        //                       ),
        //                     ),
        //             WidgetSpan(
        //               child: Transform.translate(
        //                 offset: Offset(0.0, -10.0),
        //                 child: Text(
        //                   ' BETA',
        //                   style: TextStyle(
        //                     fontSize: 10,
        //                     fontWeight: FontWeight.w500,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       SizedBox(
        //         width: searchHasFocus ? 500 : 400,
        //         child: Card(
        //           child: ListTile(
        //             dense: true,
        //             leading: searchCentralState
        //                 ? IconButton(
        //                     splashRadius: 16,
        //                     icon: Icon(Icons.arrow_back_outlined),
        //                     onPressed: () {
        //                       _searchCentralController.clear();
        //                       farmerSearchValue.clear();
        //                       setState(() {
        //                         searchCentralState = false;
        //                       });
        //                     },
        //                   )
        //                 : IconButton(
        //                     splashRadius: 16,
        //                     icon: Icon(Icons.search_outlined),
        //                     onPressed: () {},
        //                   ),
        //             title: TextField(
        //               focusNode: _searchControllerNode,
        //               controller: _searchCentralController,
        //               decoration: InputDecoration(
        //                   isDense: true,
        //                   border: InputBorder.none,
        //                   hintText: _connectionStatus.toString() //'Search',
        //                   ),
        //               onChanged: (value) {
        //                 if (value.isNotEmpty) {
        //                   var demo = farmerSearchValue
        //                       .where((element) =>
        //                           element.document.fields.firstName.stringValue
        //                               .toLowerCase()
        //                               .contains(value.toLowerCase()) ||
        //                           element.document.fields.lastName.stringValue
        //                               .toLowerCase()
        //                               .contains(value.toLowerCase()) ||
        //                           element
        //                               .document
        //                               .fields
        //                               .phoneNumber
        //                               .mapValue
        //                               .fields
        //                               .mn0
        //                               .mapValue
        //                               .fields
        //                               .eaM2
        //                               .stringValue
        //                               .toLowerCase()
        //                               .contains(value.toLowerCase()) ||
        //                           element
        //                               .document
        //                               .fields
        //                               .emailAddress
        //                               .mapValue
        //                               .fields
        //                               .mn0
        //                               .mapValue
        //                               .fields
        //                               .eaM0
        //                               .stringValue
        //                               .toLowerCase()
        //                               .contains(value.toLowerCase()) ||
        //                           element
        //                               .document.fields.farmerNumber.stringValue
        //                               .toLowerCase()
        //                               .contains(value.toLowerCase()))
        //                       .toList();
        //                   demo.forEach((element) {
        //                     print(
        //                         element.document.fields.firstName.stringValue);
        //                   });
        //                   setState(() {
        //                     searchCentralState = true;
        //                   });
        //                 } else {
        //                   setState(() {
        //                     searchCentralState = false;
        //                   });
        //                 }
        //               },
        //             ),
        //             trailing: searchCentralState
        //                 ? IconButton(
        //                     splashRadius: 16,
        //                     icon: Icon(Icons.search_outlined),
        //                     onPressed: () {},
        //                   )
        //                 : null,
        //           ),
        //         ),
        //       ),
        //       SizedBox.shrink(),
        //     ],
        //   ),
        //   leading: Builder(
        //       builder: (context) => IconButton(
        //             icon: Icon(Icons.apps),
        //             onPressed: () => Scaffold.of(context).openDrawer(),
        //           )),
        // ),
        appBar: AppBar(
          titleSpacing: 0,
          toolbarHeight: 32,
          leading: Builder(
              builder: (context) => IconButton(
                    icon: Icon(
                      Icons.flutter_dash,
                      color: kWhiteColor,
                      size: 16,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
          title: WindowTitleBarBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: MoveWindow(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Agrigo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: Offset(0.0, -8.0),
                                child: Text(
                                  ' BETA',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(
                  width: 80,
                ),
                SizedBox(
                  width: searchHasFocus ? 500 : 400,
                  height: 24,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    focusNode: _searchControllerNode,
                    controller: _searchCentralController,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: searchHasFocus ? kWhiteColor : kWhiteColor.withAlpha(20),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: searchHasFocus ? kGreyColor : kWhiteColor),
                      prefixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        color: searchHasFocus ? kPrimaryColor : kWhiteColor,
                        splashRadius: 16,
                        iconSize: 12,
                        icon: searchCentralState ? Icon(Icons.arrow_back_outlined) : Icon(Icons.search_outlined),
                        onPressed: () {
                          _searchCentralController.clear();
                          farmerFilteredList.clear();
                          sampleFilteredList.clear();
                          reportFilteredList.clear();
                          setState(() {
                            searchCentralState = false;
                          });
                        },
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 24,
                        minWidth: 24,
                      ),
                      suffixIcon: searchCentralState
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              color: kPrimaryColor,
                              splashRadius: 16,
                              iconSize: 12,
                              icon: Icon(Icons.search_outlined),
                              onPressed: () {
                                //_searchFilterController.clear();
                                setState(() {
                                  //searchState = false;
                                });
                              },
                            )
                          : null,
                      suffixIconConstraints: BoxConstraints(
                        minHeight: 24,
                        minWidth: 24,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          farmerFilteredList = farmerSearchValue
                              .where((element) =>
                                  element.document.fields.firstName.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.document.fields.lastName.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element
                                      .document.fields.phoneNumber.mapValue.fields.mn0.mapValue.fields.eaM2.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element
                                      .document.fields.emailAddress.mapValue.fields.mn0.mapValue.fields.eaM0.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.document.fields.farmerNumber.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                          sampleFilteredList = sampleSearchValue
                              .where((element) =>
                                  element.document.fields.sampleNumber.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.document.fields.farmerNumber.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                          reportFilteredList = reportSearchValue
                              .where((element) =>
                                  element.document.fields.reportNumber.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.document.fields.sampleNumber.stringValue
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                          searchCentralState = true;
                        });
                      } else {
                        setState(() {
                          searchCentralState = false;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: MoveWindow(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch(
                          value: _switchLanguage,
                          activeThumbImage: Image.asset('assets/ta.png').image,
                          inactiveThumbImage: Image.asset('assets/en.png').image,
                          activeTrackColor: kWhiteColor.withAlpha(20),
                          thumbColor: MaterialStateProperty.resolveWith((states) => kWhiteColor),
                          onChanged: (bool value) {
                            setState(() {
                              _switchLanguage = value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 160,
                          child: Text(
                            emailId,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        MouseRegion(
                          onHover: (e) {
                            setState(() {
                              profileCardState = true;
                            });
                          },
                          child: Stack(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Color(0xFFD6E3E9),
                                ),
                              ),
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: Image.network(
                                  profilePicture,
                                ).image,
                                backgroundColor: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        _connectionState
                            ? SizedBox.shrink()
                            : Chip(
                                backgroundColor: kWhiteColor,
                                label: Text(
                                  'offline',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                                labelPadding: EdgeInsets.fromLTRB(3, -3, 3, -3),
                                labelStyle: TextStyle(color: kPrimaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                              ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    MinimizeWindowButton(
                      colors: kWindowBtnColor,
                    ),
                    MaximizeWindowButton(
                      colors: kWindowBtnColor,
                    ),
                    CloseWindowButton(
                      colors: kWindowCloseBtnColor,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Under Constructions'),
                TextButton(
                  onPressed: null,
                  child: Text('_closeDrawer'),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            renderBorder: false,
                            color: Color(0x50444444),
                            fillColor: Colors.transparent,
                            selectedColor: Colors.white,
                            direction: Axis.vertical,
                            hoverColor: Color(0x20444444),
                            children: <Widget>[
                              Tooltip(
                                message: 'Dashboard',
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return RadialGradient(
                                      center: Alignment.bottomLeft,
                                      radius: 0.5,
                                      colors: <Color>[Colors.green, Colors.lightGreen],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  },
                                  child: Icon(Icons.dashboard_customize),
                                ),
                              ),
                              Tooltip(
                                message: 'Farmer',
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return RadialGradient(
                                      center: Alignment.bottomLeft,
                                      radius: 0.5,
                                      colors: <Color>[Colors.green, Colors.lightGreen],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  },
                                  child: Icon(Icons.person_add_alt_1),
                                ),
                              ),
                              Tooltip(
                                message: 'Sample',
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return RadialGradient(
                                      center: Alignment.bottomLeft,
                                      radius: 0.5,
                                      colors: <Color>[Colors.green, Colors.lightGreen],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  },
                                  child: Icon(Icons.post_add),
                                ),
                              ),
                              Tooltip(
                                message: 'Report',
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return RadialGradient(
                                      center: Alignment.bottomLeft,
                                      radius: 0.5,
                                      colors: <Color>[Colors.green, Colors.lightGreen],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  },
                                  child: Icon(Icons.add_chart),
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
                                  if (buttonIndex == index) {
                                    _selections[buttonIndex] = true;
                                    _selectedIndex = buttonIndex;
                                  } else {
                                    _selections[buttonIndex] = false;
                                  }
                                }
                              });
                            },
                            isSelected: _selections,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _connectionState
                        ? <Widget>[
                            FarmerForm(connectionState: _connectionState, selectionState: _selectedOptionCallBack),
                            SampleForm(connectionState: _connectionState, selectionState: _selectedOptionCallBack),
                            ReportForm(connectionState: _connectionState, selectionState: _selectedOptionCallBack)
                          ].elementAt(_selectedIndex)
                        : Stack(alignment: Alignment.centerLeft, children: [
                            <Widget>[
                              FarmerForm(connectionState: _connectionState, selectionState: _selectedOptionCallBack),
                              SampleForm(connectionState: _connectionState, selectionState: _selectedOptionCallBack),
                              ReportForm(connectionState: _connectionState, selectionState: _selectedOptionCallBack)
                            ].elementAt(_selectedIndex),
                            AbsorbPointer(
                              absorbing: !_connectionState,
                              child: Center(
                                child: Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No internet Connection',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'You can still access some features offline. For the full experience of\nthis app, please connect to the internet.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                  ),
                ],
              ),
            ),
            searchCentralState
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      elevation: 8,
                      child: Container(
                        child: SearchWidget(
                            farmerList: farmerFilteredList.length == 0 ? farmerSearchValue : farmerFilteredList,
                            sampleList: sampleFilteredList.length == 0 ? sampleSearchValue : sampleFilteredList,
                            reportList: reportFilteredList.length == 0 ? reportSearchValue : reportFilteredList,
                            callBack: _selectionsCallBack),
                        width: 500,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            profileCardState
                ? Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      elevation: 8,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade100,
                                        highlightColor: Colors.grey.shade300,
                                        child: CircleAvatar(),
                                      ),
                                      CircleAvatar(
                                        foregroundImage: Image.network(profilePicture).image,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          displayName,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          emailId,
                                          style: TextStyle(color: kGreyColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        width: 180,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 16, 8),
                              child: TextButton(
                                  style: TextButton.styleFrom(fixedSize: Size(72, 24)),
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('isLoggedIn', false);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (BuildContext context) => MyApp(userStatus: false)));
                                  },
                                  child: Text(
                                    'Sign out',
                                    style: TextStyle(fontWeight: FontWeight.normal, color: kPrimaryColor),
                                  )),
                            )
                          ],
                        ),
                        width: 280,
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final List<FarmerQuery> farmerList;
  final List<SampleQuery> sampleList;
  final List<ReportQuery> reportList;
  final Function callBack;

  const SearchWidget(
      {Key? key, required this.farmerList, required this.sampleList, required this.reportList, required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Farmers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              farmerList.length > 2
                  ? TextButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.resolveWith((states) => Size(60, 12)),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                          shadowColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)),
                      onPressed: () {
                        callBack([false, true, false, false], 1);
                      },
                      child: Text(
                        'SEE MORE',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: farmerList.length > 2 ? 2 : farmerList.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                leading: ClipRRect(
                  child: Stack(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade300,
                        child: Container(
                          color: Colors.grey.shade300,
                          width: 34,
                          height: 34,
                        ),
                      ),
                      Image.network(
                        farmerList[index]
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
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                trailing: Text(
                  DateFormat.yMMMMd('en_US')
                      .format(
                          DateTime.parse(farmerList[index].document.fields.farmerCreatedAt.timestampValue).toLocal())
                      .toString(),
                  style: TextStyle(color: kGreyColor, fontSize: 14.0),
                ),
                title: Text(
                    farmerList[index].document.fields.firstName.stringValue +
                        ' ' +
                        farmerList[index].document.fields.lastName.stringValue,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                    overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  farmerList[index].document.fields.emailAddress.mapValue.fields.mn0.mapValue.fields.eaM0.stringValue,
                  style: TextStyle(color: kGreyColor, fontSize: 14.0),
                ),
              );
            }),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Samples',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              sampleList.length > 2
                  ? TextButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.resolveWith((states) => Size(60, 12)),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                          shadowColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)),
                      onPressed: () {},
                      child: Text(
                        'SEE MORE',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: sampleList.length > 2 ? 2 : sampleList.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                leading: ClipRRect(
                  child: Lottie.asset(
                    'assets/sampleAnim.json',
                    fit: BoxFit.fill,
                    width: 34,
                    height: 34,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                trailing: Text(
                  DateFormat.yMMMMd('en_US')
                      .format(
                          DateTime.parse(sampleList[index].document.fields.sampleCreatedAt.timestampValue).toLocal())
                      .toString(),
                  style: TextStyle(color: kGreyColor, fontSize: 14.0),
                ),
                title: Text(sampleList[index].document.fields.sampleNumber.stringValue,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  sampleList[index].document.fields.farmerNumber.stringValue,
                  style: TextStyle(color: kGreyColor, fontSize: 14.0),
                ),
              );
            }),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              reportList.length > 2
                  ? TextButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.resolveWith((states) => Size(60, 12)),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                          shadowColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)),
                      onPressed: () {},
                      child: Text(
                        'SEE MORE',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: reportList.length > 2 ? 2 : reportList.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                leading: ClipRRect(
                  child: Lottie.asset(
                    'assets/reportAnim.json',
                    fit: BoxFit.fill,
                    width: 34,
                    height: 34,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                trailing: Text(
                  DateFormat.yMMMMd('en_US')
                      .format(
                          DateTime.parse(reportList[index].document.fields.reportCreatedAt.timestampValue).toLocal())
                      .toString(),
                  style: TextStyle(color: kGreyColor, fontSize: 14.0),
                ),
                title: Text(reportList[index].document.fields.reportNumber.stringValue,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  reportList[index].document.fields.sampleNumber.stringValue,
                  style: TextStyle(color: kGreyColor, fontSize: 14.0),
                ),
              );
            }),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
