import 'package:flutter/material.dart';
import 'package:flutterexamlab/screens/home/home.dart';
import 'package:flutterexamlab/screens/home/about.dart';
import 'package:flutterexamlab/screens/home/settings.dart';
import 'package:provider/provider.dart';
import 'package:flutterexamlab/models/ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UI()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          '/about': (context) => About(),
          '/settings': (context) => Settings(),
        },
      ),
    );
  }
}
