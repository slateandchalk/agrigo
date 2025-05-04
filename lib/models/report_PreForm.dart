import 'package:agrigo_kia/models/report_newForm.dart';
import 'package:agrigo_kia/resources/fetch_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

final TextEditingController _sampleNumberController = TextEditingController();
final _sampleNumberFocusNode = FocusNode();

Future<bool> reportPreForm(
    BuildContext context, AnimationController _animationController) async {
  return await showDialog(
      context: context,
      builder: (context) {
        String forWhich = '?';
        bool show = false;
        bool fetchState = false;
        bool inValid = false;
        bool insertState = false;
        bool inAlready = false;
        var reportDoc;
        var sampleDoc;
        var farmerDoc;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: EdgeInsets.fromLTRB(18, 0, 18, 18),
            contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              height: 180,
              width: 720,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate Report',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'To generate report, type the Sample ID${show ? ': ' + _sampleNumberController.text : forWhich}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          SizedBox(
                            width: 360,
                            child: TextField(
                              controller: _sampleNumberController,
                              focusNode: _sampleNumberFocusNode,
                              decoration: InputDecoration(
                                  labelText: 'Sample ID',
                                  hintText: 'ASNYYYYMMDDHHMMSS'),
                              onChanged: (value) {
                                if (value.length <= 17) {
                                  _animationController
                                      .animateTo(value.length / 17);
                                }
                                if (value.length == 17 &&
                                    value.contains(RegExp(
                                        r'\b^((ASN)(20)(21|22|23)(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-9]|2[0-4])([0-5][0-9]|60)([0-5][0-9]|60))$\b'))) {
                                  setState(() {
                                    insertState = true;
                                    show = true;
                                  });
                                } else {
                                  setState(() {
                                    insertState = false;
                                    inValid = false;
                                    inAlready = false;
                                    show = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          inValid
                              ? Text(
                                  'Enter correct sample ID to generate report.',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                )
                              : inAlready
                                  ? Row(
                                      children: [
                                        Text(
                                          'Report detected for this sample ID: ${_sampleNumberController.text}',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              reportNewDialog(
                                                  context,
                                                  reportDoc,
                                                  true,
                                                  farmerDoc,
                                                  sampleDoc
                                                      .first.document.fields,
                                                  sampleDoc.first.document.name,
                                                  reportDoc.fields.reportStatus
                                                      .booleanValue);
                                            },
                                            style: ButtonStyle(),
                                            child: Text('Click'))
                                      ],
                                    )
                                  : SizedBox.shrink()
                        ],
                      ),
                      Lottie.asset(
                        'assets/samplePreAnim.json',
                        height: 160,
                        width: 160,
                        fit: BoxFit.fill,
                        controller: _animationController,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fetchState
                      ? Text('Fetching sample details...')
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(fixedSize: Size(76, 36)),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        child: Text('Next'),
                        onPressed: insertState
                            ? () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        content: SizedBox(
                                          width: 720,
                                          height: 240,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                setState(() {
                                  inValid = false;
                                  fetchState = true;
                                });
                                fetchSampleDetails(_sampleNumberController.text)
                                    .then((valueSample) {
                                  Navigator.of(context).pop();
                                  if (valueSample.first.document.name ==
                                      'fakeData') {
                                    setState(() {
                                      inValid = true;
                                      inAlready = false;
                                      insertState = false;
                                      fetchState = false;
                                    });
                                  } else if (valueSample.first.document.fields
                                          .reportCreated.booleanValue ==
                                      true) {
                                    fetchFarmerDetails(valueSample
                                            .first
                                            .document
                                            .fields
                                            .farmerNumber
                                            .stringValue)
                                        .then((valueFarmer) {
                                      fetchReportDetails(valueSample
                                              .first
                                              .document
                                              .fields
                                              .sampleNumber
                                              .stringValue)
                                          .then((valueReport) {
                                        setState(() {
                                          sampleDoc = valueSample;
                                          farmerDoc =
                                              valueFarmer.first.document.fields;
                                          reportDoc =
                                              valueReport.first.document;
                                          inAlready = true;
                                          inValid = false;
                                          insertState = false;
                                          fetchState = false;
                                        });
                                      });
                                    });
                                  } else {
                                    fetchFarmerDetails(valueSample
                                            .first
                                            .document
                                            .fields
                                            .farmerNumber
                                            .stringValue)
                                        .then((valueFarmer) {
                                      reportNewDialog(
                                              context,
                                              null,
                                              false,
                                              valueFarmer.first.document.fields,
                                              valueSample.first.document.fields,
                                              valueSample.first.document.name,
                                              false)
                                          .then((value) {
                                        if (value == true) {
                                          setState(() {
                                            inValid = false;
                                            inAlready = false;
                                            insertState = false;
                                            fetchState = false;
                                          });
                                          Navigator.of(context).pop();
                                        } else {
                                          setState(() {
                                            inValid = false;
                                            fetchState = false;
                                            inAlready = false;
                                            insertState = true;
                                          });
                                        }
                                      });
                                    });
                                  }
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
      }).then((value) {
    _sampleNumberController.clear();
    return true;
  });
}
