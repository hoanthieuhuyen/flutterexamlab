import 'package:flutter/material.dart';
import 'package:flutterexamlab/screens/home/settings.dart';
import 'package:flutterexamlab/screens/word/list_word.dart';
import 'package:flutterexamlab/screens/word/manager_word.dart';

import 'about.dart';

const kTitle = 'English Alert';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                kTitle,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            title: const Text(
              'Home',
            ),
            leading: const Icon(
              Icons.house,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: const Text(
              'About',
            ),
            leading: const Icon(
              Icons.info,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => About(),
                  ));
            },
          ),
          ListTile(
            title: const Text(
              'Settings',
            ),
            leading: const Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => Settings(),
                  ));
            },
          ),
          ListTile(
            title: const Text(
              'List Word1',
            ),
            leading: const Icon(
              Icons.list,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManagerWord(),
                  ));
            },

          ),
          ListTile(
            title: const Text(
              'List Word 2',
            ),
            leading: const Icon(
              Icons.list,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListWord(),
                  ));
            },

          )
        ],
      ),
    );
  }

  Widget getLine() {
    return SizedBox(
      height: 0.5,
      child: Container(
        color: Colors.grey,
      ),
    );
  }

  Widget getListTile(title, {Function? onTap1}) {
    return ListTile(
      title: Text(title),
      onTap: onTap1!(),
    );
  }
}
