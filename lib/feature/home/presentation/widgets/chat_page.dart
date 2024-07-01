import 'dart:io';
import 'package:chat_app/feature/home/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/feature/home/presentation/widgets/chat_service.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String receiverName;

  const ChatPage(
      {Key? key, required this.receiverID, required this.receiverName})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  String imageUrl = '';

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  void sendImage() async {
    print("send message");
    await _chatService.sendImage(widget.receiverID, imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiverName),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildUserInput(),
          ],
        ));
  }

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(senderID, widget.receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        return ListView(
          children:
          snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _auth.currentUser!.uid;
    Timestamp timestamp = data["timestamp"];
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.Hm().format(dateTime);
    return Column(
      crossAxisAlignment:
      isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          message:
          data["imageUrl"] == null ? data["message"] : data["imageUrl"],
          isCurrentUser: isCurrentUser,
          abc: formattedTime,
          type: data["imageUrl"] == null ? "message":"image",
        ),
      ],
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, right: 10, left: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);
                print('here: ${file?.path}');

                if (file == null) return;

                String fileName =
                DateTime.now().microsecondsSinceEpoch.toString();

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');
                Reference referenceImageToUpload =
                referenceDirImages.child(fileName);

                try {
                  await referenceImageToUpload.putFile(File(file.path));
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (error) {}
                sendImage();
              },
              icon: Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: 'Type a message',
              obscureText: false,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}