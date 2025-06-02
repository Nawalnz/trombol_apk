import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/homepage/search_result.dart';
import 'package:trombol_apk/screens/homepage/tour_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      recentSearches = List<String>.from(doc.data()?['recentSearches'] ?? []);
    });
  }

  Future<void> _saveRecentSearch(String value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    List<String> updatedSearches = List.from(recentSearches);

    updatedSearches.remove(value);
    updatedSearches.insert(0, value);
    if (updatedSearches.length > 3) {
      updatedSearches = updatedSearches.sublist(0, 3);
    }

    await docRef.update({'recentSearches': updatedSearches});
    setState(() => recentSearches = updatedSearches);
  }

  Future<void> _removeRecentSearch(String value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await docRef.update({
      'recentSearches': FieldValue.arrayRemove([value])
    });

    setState(() => recentSearches.remove(value));
  }

  void _onSearchSubmitted(String value) async {
    if (value.isNotEmpty) {
      await _saveRecentSearch(value);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResult(searchKeyword: value),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Where do you plan to go?',
                  border: InputBorder.none,
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Recently Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final search = recentSearches[index];
                  return ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(search),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _removeRecentSearch(search),
                    ),
                    onTap: () => _onSearchSubmitted(search),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}