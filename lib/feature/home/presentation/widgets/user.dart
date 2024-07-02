import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? name;
  final String? email;
  final bool? isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isActive: data['isActive'] ?? '',
    );
  }
}
