import 'dart:io';
import 'package:chat_app/feature/home/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/feature/home/presentation/widgets/chat_service.dart';
import 'package:chat_app/feature/home/presentation/widgets/text_filed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String receiverName;
  final bool isActive;
  final String photoUrl;
  final String senderName;

  const ChatPage({
    Key? key,
    required this.receiverID,
    required this.receiverName,
    required this.isActive,
    required this.photoUrl,
    required this.senderName,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  String imageUrl = '';
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(microseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.senderName,
        widget.receiverName,
        widget.receiverID,
        _messageController.text,
      );
      _messageController.clear();
    }
    scrollDown();
  }

  void sendImage() async {
    print("send message");
    await _chatService.sendImage(
        widget.senderName, widget.receiverName, widget.receiverID, imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.surface,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.photoUrl),
                  radius: 25,
                ),
                Column(
                  children: [
                    Text(widget.receiverName),
                    widget.isActive
                        ? Text(
                            'online',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 15,
                            ),
                          )
                        : Text(
                            'offline',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: 30,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.video_call),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 30,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.call),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 30,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            )),
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          reverse: true,
          controller: _scrollController,
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
        GestureDetector(
          onLongPress: () {
            if (isCurrentUser) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Manage Message"),
                  content: Column(
                    //mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Edit Message"),
                              content: TextField(
                                controller: TextEditingController(
                                    text: data['message']),
                                onChanged: (value) {
                                  data['message'] = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    List<String> ids = [
                                      _auth.currentUser!.uid,
                                      widget.receiverID
                                    ];
                                    ids.sort();
                                    String chatRoomID = ids.join('_');
                                    await _chatService.updateMessage(
                                      chatRoomID,
                                      doc.id,
                                      data['message'],
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Update"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Edit"),
                      ),
                      TextButton(
                        onPressed: () async {
                          List<String> ids = [
                            _auth.currentUser!.uid,
                            widget.receiverID
                          ];
                          ids.sort();
                          String chatRoomID = ids.join('_');
                          await _chatService.deleteMessage(chatRoomID, doc.id);
                          Navigator.of(context).pop();
                        },
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              );
            }
          },
          child: ChatBubble(
            message:
                data["imageUrl"] == null ? data["message"] : data["imageUrl"],
            isCurrentUser: isCurrentUser,
            sendingTime: formattedTime,
            type: data["imageUrl"] == null ? "message" : "image",
          ),
        ),
      ],
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? file =
                  await imagePicker.pickImage(source: ImageSource.gallery);

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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.keyboard_voice,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: CustomTextfield(
              controller: _messageController,
              hintText: 'Type a message',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
