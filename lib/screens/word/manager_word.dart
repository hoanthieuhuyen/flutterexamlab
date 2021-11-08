import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterexamlab/screens/home/drawer_menu.dart';
import 'package:flutterexamlab/utils/sql_helper.dart';

class ManagerWord extends StatefulWidget {
  const ManagerWord({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<ManagerWord> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  final formStateKey = GlobalKey<FormState>();
  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id, Size size) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 1,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                        key: formStateKey,
                        child: Column(children: [
                          TextFormField(
                            controller: _titleController,
                            decoration:
                                const InputDecoration(hintText: 'Title'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the contain';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration:
                                const InputDecoration(hintText: 'Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the contain';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Save new journal
                              if (id == null) {
                                await _addItem();
                              }

                              if (id != null) {
                                await _updateItem(id);
                              }

                              // Clear the text fields
                              _titleController.text = '';
                              _descriptionController.text = '';

                              // Close the bottom sheet
                              Navigator.of(context).pop();
                            },
                            child: Text(id == null ? 'Create New' : 'Update'),
                          )
                        ]))
                  ],
                ),
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    final form = formStateKey.currentState;
    if (formStateKey.currentState!.validate()) {
      await SQLHelper.createItem(
          _titleController.text, _descriptionController.text);
      _refreshJournals();
    }
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Word'),
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Container(
                color: Colors.teal,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                    title: Text(_journals[index]['title']),
                    subtitle: Text(_journals[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(_journals[index]['id'], size),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null, size),
      ),
    );
  }
}
