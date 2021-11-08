import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterexamlab/screens/home/drawer_menu.dart';
import 'package:flutterexamlab/screens/word/list_word.dart';
import 'package:flutterexamlab/utils/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutterexamlab/models/ui.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? timer;
  bool bStart = false;
  String sTitleTime = 'Time start';
  List<Map<String, dynamic>> data = [];
  final DatabaseHelper db = DatabaseHelper.instance;
  final _textDurationController = TextEditingController();
  int iDuration = 5;

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    setState(() {
      _textDurationController.text = '5';
    });
    try {
      iDuration = _textDurationController.text as int;
    } catch (e) {
      iDuration = 5;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> listWord() async {
    try {
      data = await db.queryNotification('myTable');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          content: Text(e.toString())));
    }
  }

  void startTime() {
    try {
      iDuration = int.parse(_textDurationController.text);
    } catch (e) {
      iDuration = 5;
    }
    timer = Timer.periodic(Duration(seconds: iDuration),
        (Timer t) => _showNotificationWithSound());
  }

  // Method 1
  Future _showNotificationWithSound() async {
    listWord();
    if (data.isNotEmpty) {
      int iIndex = Random().nextInt(data.length);
      String sContain =
          data[iIndex]['english'] + ': ' + data[iIndex]['vietnamese'];
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'your channel id', 'your channel name',
          playSound: true, importance: Importance.max, priority: Priority.high);
      var iOSPlatformChannelSpecifics =
          const IOSNotificationDetails(sound: "slow_spring_board.aiff");
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'New Word',
        sContain,
        platformChannelSpecifics,
        payload: data[iIndex]['english'],
      );
    }
  }

// Method 2
  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Default Notification',
      'Đây là thông báo với default sound và default icon',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

// Method 3
  Future _showNotificationWithoutSound() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        playSound: false, importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics =
        const IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification',
      'Đây là thông báo không có sound và default icon',
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Manager Alert'),
        ),
        drawer: const DrawerMenu(),
        body: Center(
          child: Consumer<UI>(builder: (context, ui, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 130,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _textDurationController,
                    decoration: const InputDecoration(
                      hintText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!bStart) {
                      startTime();
                      bStart = true;
                      setState(() {
                        sTitleTime = 'Time stop';
                      });
                    } else {
                      timer?.cancel();
                      bStart = false;
                      setState(() {
                        sTitleTime = 'Time start';
                      });
                    }
                  },
                  child: Text(sTitleTime),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: ui.fontSize, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _showNotificationWithSound,
                  child: const Text('Show Notification With Sound'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future onSelectNotification(String? payload) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListWord(
                  english: payload,
                )));

    /*showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thông báo"),
          content: Text("Push Notification : $payload"),
        );
      },
    );*/
  }
}
