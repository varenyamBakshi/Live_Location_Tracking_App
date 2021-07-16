import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  bool _isLoading = false;
  String searchQuery = "Search query";

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  late String _username;
  List<String> _usernames = <String>[];
  List<String> _selectedusernames = <String>[];
  Map<String, bool> _selectedusernamesbool = <String, bool>{};
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _username = _auth.currentUser!.displayName.toString();
    super.initState();
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search by username",
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ), // Input Decoration

      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (text) {
        int i = 0;
        _usernames.clear(); // clear all the usernames in this list

        FirebaseFirestore.instance
            .collection('data')
            .where('SearchQueries', arrayContains: text)
            .get()
            .then((snapshot) {
          setState(() {
            _isLoading = true;
          });

          setState(() {
            snapshot.docs.forEach((element) {
              if (element['full_name'] != _username) {
                // if the current document is not of the current user

                if (!_usernames.contains(element['full_name'])) {
                  // if _usernames list doesn't contain this
                  _usernames.insert(i, element['full_name']); // add it

                  if (_selectedusernames.contains(element['full_name'])) {
                    // if this element user is in _selectedusernames update the map accordingly
                    _selectedusernamesbool.update(
                        element['full_name'], (value) => true,
                        ifAbsent: () => true);
                  } else {
                    _selectedusernamesbool.update(
                        element['full_name'], (value) => false,
                        ifAbsent: () => false);
                  }
                }
                i++;
              }
              ;
            });
            _isLoading = false;
          });
        });
      },
    );
  }

  // search box in AppBar template functions

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)!
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isLoading = true;
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState!.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text('Seach box'),
          ],
        ),
      ),
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      _isLoading = true;
    });
    print("search query " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      deleteIcon: Icon(
        Icons.close,
      ),
      onDeleted: () => _deleteselected(label),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  void _deleteselected(String label) {
    setState(() {
      _selectedusernames.remove(label);
    });
  }

  TextEditingController _groupNamecontroller = TextEditingController();

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Color(0xff121212),
              title: Text(
                "Enter Group Name: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9)),
              ),
              content: TextField(
                controller: _groupNamecontroller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBB86FC), width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38, width: 2.0),
                  ),
                  hintText: 'Enter your name',
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    child: Text(
                      'Create',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xffBB86FC)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      createcollectiongroup();
                    })
              ]);
        });
  }

  Future<void> createcollectiongroup() async {
    _selectedusernames.insert(_selectedusernames.length, _username);
    Map<String, dynamic> mapgroups = {
      'groupName': _groupNamecontroller.text,
      'users': _selectedusernames
    };
    try {
      await FirebaseFirestore.instance.collection('groups').add(mapgroups);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Group created')));
      setState(() {
        _selectedusernames.clear();
        _selectedusernamesbool.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to create group ${e}')));
    }
    Navigator.pushReplacementNamed(context, "/Groups");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xff121212),
        key: scaffoldKey,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffBB86FC),
          child: Icon(
            Icons.check,
            color: Colors.black,
            size: 36,
          ),
          onPressed: () {
            createAlertDialog(context);
          },
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: _selectedusernames
                                .map((item) =>
                                    _buildChip(item, Color(0xffBB86FC)))
                                .toList()
                                .cast<Widget>()),
                      )),
                  Divider(thickness: 1.0),
                  SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      itemCount: _usernames.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: _selectedusernames.contains(_usernames[index])
                              ? Colors.grey
                              : Colors.white,
                          child: ListTile(
                            title: Text('${_usernames[index]}'),
                            onTap: () {
                              setState(() {
                                if (!_selectedusernames
                                    .contains(_usernames[index])) {
                                  _selectedusernames.add(_usernames[index]);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }
}

/////// Have to put the below code somewhere

// _isLoading = true;
