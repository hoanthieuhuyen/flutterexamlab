import 'package:flutter/material.dart';

abstract class show_dialog {
  Future<void> _showMyDialogDelete(
      BuildContext context, String title, String request) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(request),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đồng ý'),
              onPressed: () {
                _delete();
              },
            ),
            TextButton(
              child: Text('Thoát'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete() {}
}
