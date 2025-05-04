import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<bool> reportPreviewForm(BuildContext context, Url) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            elevation: 0,
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                IconButton(
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
          );
        });
      }).then((value) {
    return true;
  });
}
