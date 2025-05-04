import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(60, 117, 56, .1),
  100: Color.fromRGBO(60, 117, 56, .2),
  200: Color.fromRGBO(60, 117, 56, .3),
  300: Color.fromRGBO(60, 117, 56, .4),
  400: Color.fromRGBO(60, 117, 56, .5),
  500: Color.fromRGBO(60, 117, 56, 1),
  600: Color.fromRGBO(60, 117, 56, .7),
  700: Color.fromRGBO(60, 117, 56, .8),
  800: Color.fromRGBO(60, 117, 56, .9),
  900: Color.fromRGBO(60, 117, 56, 1.0),
};

MaterialColor kPrimarySwatch = MaterialColor(0xFF3C7538, color);
const kPrimaryColor = Color(0xFF3C7538);
const kGreyColor = Colors.grey;
const kWhiteColor = Color(0xFFFFFFFF);

//ReportTable
const kReportTableColor = Color(0xFF3C4F61);
const kReportCellColor = Color(0xFFD7DCE2);

//windowButtonColor
var kWindowBtnColor = WindowButtonColors(
  iconNormal: kWhiteColor,
  iconMouseOver: kWhiteColor,
  mouseOver: kWhiteColor.withAlpha(50),
  mouseDown: kWhiteColor.withAlpha(20),
);

var kWindowCloseBtnColor = WindowButtonColors(
  iconNormal: kWhiteColor,
  iconMouseOver: kWhiteColor,
  mouseOver: Color(0xFFD32F2F),
  mouseDown: Color(0xFFB71C1C),
);
