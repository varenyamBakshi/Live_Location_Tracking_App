// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// class SearchPage extends StatefulWidget {
//   const SearchPage({Key? key}) : super(key: key);
//
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//
//   late String _username;
//   List<String>  _usernames = <String>[];
//   List<String> _selectedusernames = <String>[];
//   Map<String, bool> _selectedusernamesbool = <String, bool> {};
//   final TextEditingController _searchQuery = TextEditingController();
//
//   Widget buildSearchField() {
//   return new TextField(
//   controller: _searchQuery,
//   autofocus: true,
//   decoration: const InputDecoration(
//   hintText: "Search by username",
//
//   border: InputBorder.none,
//
//   hintStyle: const TextStyle(color: Colors.white30),
//
//   ), // Input Decoration
//
//   style: const TextStyle(color: Colors.white, fontSize: 16.0),
//   onChanged: (text) {
//   int i = 0;
//   _usernames.clear();
//
//   FirebaseFirestore.instance.collection('users').where('searchname', isEqualTo: text).get().then((snapshot) {
//
//   setState(() {
//   snapshot.docs.forEach((element) (
//   if (element['name'] != _username) {
//   if (!_usernames.contains(element['name'])) {
//   _usernames.insert(i, element('name']);
//   if (_selectedusernames.contains(element['name'])) {
//
//   _selectedusernamesbool.update(
//   element['name'], (value) => true,
//   ifAbsent: () => true);
//
//   } else {
//   _selectedusernamesbool.update(
//
//   element['name'], (value) => false, ifAbsent: () => false);
//   }
//   }i++;
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
