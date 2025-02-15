import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  //send message

  Future<void> sendMessage(String recieverID,message) async{
    //get current user Info
    final String currentUserId =_auth.currentUser!.uid;
    final String currentUserEmail =_auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message

    Message newMessage= Message(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        recieverID: recieverID,
        message: message,
        timestamp: timestamp);

    //constructing a chatroom Id for the two users(stored to ensure uniqueness)
    List<String> ids =[currentUserId,recieverID];
    ids.sort();//sort the ids (ensure that the chat room is same for any 2 people
    String chatRoomID= ids.join('_');

    // add a new message to database
    await _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").add(newMessage.toMap());
  }
    //getMessages
    Stream<QuerySnapshot> getMessages(String userID,otherUserID){
      //construct a chatroom id for two users
      List<String> ids=[userID,otherUserID];
      ids.sort();
      String chatRoomID= ids.join('_');

      return _firestore.collection("chat_rooms").
      doc(chatRoomID).collection("messages").
      orderBy("timestamp",descending: false,).
      snapshots();
    }






}