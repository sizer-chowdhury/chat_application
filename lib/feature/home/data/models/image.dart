import 'package:cloud_firestore/cloud_firestore.dart';

class Image {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String imageUrl;
  final Timestamp timestamp;
  final String receiverName;
  final String senderName;
  final String type;

  Image({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.imageUrl,
    required this.timestamp,
    required this.receiverName,
    required this.senderName,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'receiverName': receiverName,
      'senderName': senderName,
      'type': type,
    };
  }
}