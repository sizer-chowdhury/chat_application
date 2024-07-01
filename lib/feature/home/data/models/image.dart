import 'package:cloud_firestore/cloud_firestore.dart';

class Image {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String imageUrl;
  final Timestamp timestamp;

  Image({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}