import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? name;
  String? email;
  String? password;
  String? photoUrl;
  String? id;
  bool? isActive;
  UserData({
    this.name,
    this.email,
    this.password,
    this.isActive,
    this.photoUrl,
    this.id,
  });
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserData(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      isActive: data['isActive'] ?? '',
    );
  }
}