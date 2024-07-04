import 'package:chat_app/feature/home/data/models/image.dart';
import 'package:chat_app/feature/home/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String chatRoomID ='';

  Future<void> sendMessage(String senderName, String receiverName,
      String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
      receiverName: receiverName,
      senderName: senderName,
      type: "text",
      docId: '',
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    DocumentReference messageRef = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());

    newMessage.docId = messageRef.id;

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .set(newMessage.toMap());

    await messageRef.update({'docId': messageRef.id});
  }

  Stream<QuerySnapshot> getMessage(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> sendImage(String senderName, String receiverName,
      String receiverID, imageUrl) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Image newImage = Image(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      imageUrl: imageUrl,
      timestamp: timestamp,
      receiverName: receiverName,
      senderName: senderName,
      type: "img",
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .add(newImage.toMap());
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .set(newImage.toMap());
  }

  //today
  Future<void> updateMessage(String chatRoomID, String messageId, String newMessage) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('message')
          .doc(messageId)
          .update({'message': newMessage});
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  Future<void> deleteMessage(String chatRoomID, String messageId) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('message')
          .doc(messageId)
          .delete();
      print('Message deleted successfully');
    } catch (e) {
      print('Error deleting message: $e');
    }
  }


}
