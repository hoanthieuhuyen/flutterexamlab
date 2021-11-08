import 'package:flutter/material.dart';

class LoadingRow extends StatelessWidget{
  final String text;
  const LoadingRow({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(text),
          )
        ],
      ),
    );
  }
}