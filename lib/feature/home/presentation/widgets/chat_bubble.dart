import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String sendingTime;
  final String type;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.sendingTime,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          type == "message"
              ? Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              : Image.network(message),
          SizedBox(height: 5),
          Text(
            sendingTime,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
    );
  }
}
