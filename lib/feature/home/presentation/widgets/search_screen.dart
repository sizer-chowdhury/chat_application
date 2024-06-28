import 'package:chat_app/feature/home/presentation/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Stream<List<User>>? _usersStream;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.trim().toLowerCase();

    if (searchText.isEmpty) {
      setState(() {
        _usersStream = null;
      });
    } else {
      setState(() {
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: searchText)
            .where('name', isLessThanOrEqualTo: searchText + '\uf8ff')
            .snapshots()
            .map((querySnapshot) => querySnapshot.docs
            .map((doc) => User.fromFirestore(doc))
            .toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by name',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<User>>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            User user = snapshot.data![index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              // Add more details or actions if needed
            );
          },
        );
      },
    );
  }
}
