import 'package:flutter/material.dart';
import 'package:flutterexamlab/models/ui.dart';
import 'package:flutterexamlab/screens/home/drawer_menu.dart';
import 'package:flutterexamlab/screens/word/model_word.dart';
import 'package:flutterexamlab/utils/database_helper.dart';
import 'package:flutterexamlab/utils/loading_row.dart';
import 'package:provider/provider.dart';

class ListWord extends StatefulWidget {
  final String? english;
  const ListWord({Key? key, this.english}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ListWord();
  }
}

class _ListWord extends State<ListWord> {
  var loading = const LoadingRow(text: "Sending...");
  bool isLoading = true;
  bool isCheck = true;
  bool flag = true;
  String title = '';
  String? sTodo = '';
  late FocusNode myFocusNode;
  final formStateKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> data = [];
  final DatabaseHelper db = DatabaseHelper.instance;
  final NewWord _newWord =
      NewWord(iId: null, sEnglish: '', sVietnamese: '', iStatus: 0);
  var idController = TextEditingController();
  var englishController = TextEditingController();
  var vietnameseController = TextEditingController();
  var statusComtroller = TextEditingController();

  Future<void> listWord() async {
    try {
      if (sTodo!.isEmpty) {
        data = await db.queryAll('myTable');
      } else {
        data = await db.getById('myTable', sTodo!);
      }

      setState(() {
        data = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          content: Text(e.toString())));
    }
  }

  Future<void> showDialogWithFields() async {
    setState(() {
      title = flag ? 'Add new word' : 'Update word';
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(// StatefulBuilder
            builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
                child: Column(
              children: [
                Form(
                  key: formStateKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: englishController,
                        decoration: const InputDecoration(hintText: 'English'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the contain';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: vietnameseController,
                        decoration:
                            const InputDecoration(hintText: 'Vietnamese'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the contain';
                          }
                          return null;
                        },
                      ),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Status'),
                        value: (_newWord.iStatus == 0 ? false : true),
                        onChanged: (bool? value) {
                          setState(() {
                            _newWord.iStatus = (value == true ? 1 : 0);
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            )),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              isLoading == true
                  ? loading
                  : TextButton(
                      onPressed: () {
                        if (formStateKey.currentState!.validate()) {
                          myFocusNode.unfocus();
                          var english = englishController.text;
                          var vietnamese = vietnameseController.text;
                          _newWord.sEnglish = english;
                          _newWord.sVietnamese = vietnamese;
                          _addItem(context, _newWord);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
            ],
          );
        });
      },
    );
  }

  Future<void> _addItem(BuildContext context, NewWord newWord) async {
    final form = formStateKey.currentState;
    if (formStateKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      form!.save();
      try {
        if (flag == true) {
          await db.insert(newWord.toMap());
          setState(() {
            sTodo = '';
          });
        } else {
          await db.update(newWord.toMap());
          setState(() {
            if (widget.english != null || widget.english!.isNotEmpty) {
              sTodo = newWord.sEnglish;
            }
          });
        }
        setState(() {
          isLoading = false;
        });
        listWord();
        flag
            ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.teal,
                duration: Duration(seconds: 3),
                content: Text('Successfully add')))
            : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.teal,
                duration: Duration(seconds: 3),
                content: Text('Successfully update')));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            content: Text(e.toString())));
      }
    }
  }

  void _deleteItem(int id) async {
    await db.delete(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.teal,
      content: Text('Successfully deleted!'),
    ));
    listWord();
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    myFocusNode = FocusNode();
    if (widget.english != null && widget.english!.isNotEmpty) {
      sTodo = widget.english;
    }
    listWord();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Word'),
        backgroundColor: Colors.teal,
      ),
      drawer: const DrawerMenu(),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Consumer<UI>(
          builder: (context, ui, child) {
            return ListView(children: <Widget>[
              DataTable(
                  showBottomBorder: false,
                  columnSpacing: 0.0,
                  columns: const [
                    DataColumn(
                        label: Text('English',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Vietnamese',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  rows: data.map((e) {
                    return DataRow(cells: [
                      DataCell(Text(e['english'])),
                      DataCell(Text(e['vietnamese'])),
                      DataCell(Checkbox(
                        value: e['status'] == 0 ? false : true,
                        onChanged: (bool? value) {},
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Delete dialog'),
                                      content: Text(
                                          'Do you want delete this word: ' +
                                              e['english']),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteItem(e['id']);
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                              child: const Icon(Icons.delete)),
                          TextButton(
                              onPressed: () {
                                flag = false;
                                _newWord.iId = e['id'];
                                englishController.text = e['english'];
                                vietnameseController.text = e['vietnamese'];
                                _newWord.iStatus = e['status'];
                                showDialogWithFields();
                              },
                              child: const Icon(Icons.update)),
                        ],
                      )),
                    ]);
                  }).toList()),
            ]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          flag = true;
          _newWord.iId = null;
          englishController.text = '';
          vietnameseController.text = '';
          _newWord.iStatus = 0;
          showDialogWithFields();
        },
      ),
    );
  }
}
