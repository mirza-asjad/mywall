import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywall/chat/bubble_chat.dart';
import 'package:mywall/chat/chatting_services.dart';

import 'package:mywall/views/auth/login_view.dart';
import 'package:mywall/widgets/reuse_textfield.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruseruid;
  const ChatPage(
      {super.key,
      required this.receiveruserEmail,
      required this.receiveruseruid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiveruseruid, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff000221),
        title: Text(widget.receiveruserEmail,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Get.to(() => const LoginView());
                });
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatList()),
          _buildMessagenput(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiveruseruid, _firebaseAuth.currentUser!.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages available.'),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessagenItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessagenItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null, you can return an empty container or handle it as appropriate
      return Container();
    }

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var crossAxisAlignment =
        (data['senderID'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;

    var mainAxisAlignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(data['senderEmail'] ??
                ''), // Use ?? to provide a default value if senderEmail is null
            ChatBubble(message: data['message'])
            // Use ?? to provide a default value if messsage is null
          ],
        ),
      ),
    );
  }

  Widget _buildMessagenput() {
    return Row(
      children: [
        Expanded(
            child: ReuseTextField(
                emailLogin: _messageController,
                prefixIcon: const Icon(Icons.message),
                emailLabel: 'Send Message',
                isObscure: false)),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
      ],
    );
  }
}
