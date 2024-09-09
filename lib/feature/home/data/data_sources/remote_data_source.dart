import 'dart:io';
import 'package:chat_app/core/utils/user_data.dart';
import 'package:chat_app/feature/home/data/models/drawer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_data_source.g.dart';

@riverpod
MyDrawerRemoteDataSource myDrawerRemoteDataSource(Ref ref) {
  return MyDrawerRemoteDataSource();
}

class MyDrawerRemoteDataSource {
  FutureOr<(MyDrawerModel?, String?)> myDrawer() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final data = await getUserData((auth.currentUser?.uid)!);
    if (data != null) {
      return (
        MyDrawerModel(
          userData: UserData(
            photoUrl: data['photoUrl'],
            isActive: data['isActive'],
          ),
        ),
        null
      );
    }
    return (null, 'no data found');
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection('users').doc(uid);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return snapshot.data();
    } else {
      print('No user data found for ID: $uid');
      return null;
    }
  }

  FutureOr<(MyDrawerModel?, String?)> updateImage({required image}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final uId = auth.currentUser?.uid;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child(uId!);
      Reference referenceImageToUpload =
          referenceDirImages.child('images/$uniqueFileName');
      final uploadTask = await referenceImageToUpload.putFile(File(image.path));
      final imageLink = await uploadTask.ref.getDownloadURL();

      final db = FirebaseFirestore.instance;
      final docRef = db.collection('users').doc(uId);
      await docRef.update({'photoUrl': imageLink});

      return (MyDrawerModel(userData: UserData(photoUrl: imageLink)), null);
    } catch (e) {
      return (null, e.toString());
    }
  }

  FutureOr<(MyDrawerModel?, String?)> updateStatus({required status}) async {
    final db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    final docRef = db.collection('users').doc(auth.currentUser?.uid);
    try {
      await docRef.update({'isActive': status});
      return (MyDrawerModel(userData: UserData(isActive: status)), null);
    } catch (e) {
      return (null, e.toString());
    }
  }
}
