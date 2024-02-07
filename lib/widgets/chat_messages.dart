import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          Center(
            child: Text(
              "no messages found",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          );
        }
        if (chatSnapshots.hasError) {
          Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }
        final loadedMessages = chatSnapshots.data!.docs;
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currentMessageUserID = chatMessage["userId"];
              final nextMessageUserID =
                  nextChatMessage != null ? nextChatMessage["userId"] : null;

              final nextUserIsSame = nextMessageUserID == currentMessageUserID;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage["text"],
                    isMe: authUser.uid == currentMessageUserID);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage["image_url"],
                    username: chatMessage["username"],
                    message: chatMessage["text"],
                    isMe: authUser.uid == currentMessageUserID);
              }
            },
          ),
        );
      },
    );
  }
}
