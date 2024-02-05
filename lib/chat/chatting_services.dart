import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mywall/chat/chat_model.dart';

class ChatService extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentuserEmail = _firebaseAuth.currentUser!.email.toString();
    final String currentuserID = _firebaseAuth.currentUser!.uid.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: currentuserID,
        senderEmail: currentuserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentuserID, receiverID];
    ids.sort();
    String chatRoomid = ids.join("_");

    await _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomid)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, String otheruserID) {
    List<String> ids = [userID, otheruserID];
    ids.sort();
    String chatRoomid = ids.join("_");

    return _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
