
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat_app/components/chat_bubble.dart';
import 'package:f_chat_app/components/my_textfield.dart';
import 'package:f_chat_app/services/auth/auth_service.dart';
import 'package:f_chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
   ChatPage({super.key,required this.recieverEmail,required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();

  final ChatService _chatService= ChatService();

  final AuthService _authService= AuthService();

  FocusNode myFocusNode=FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        //cause the delay so that keyboard has time toshow up
        //then the amount of remaining space will be calculated
        //then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
            ()=> scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
          ()=> scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }


  final ScrollController _scrollController= ScrollController();
  void scrollDown(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }





  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.recieverID, _messageController.text);

      _messageController.clear();

      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(context)
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverID, senderID),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return const Text("Error");
          }

          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text("Loading...");
          }

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc)=>_buildMessageItem(doc)).toList(),
          );


        }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic> data = doc.data() as Map<String,dynamic>;

    //is current user
    bool isCurrentUser = data['senderID']==_authService.getCurrentUser()!.uid;

    //aligning message to right if it's users
    var alignment= isCurrentUser?Alignment.centerRight:Alignment.centerLeft;


    return Container(
        alignment:alignment,
        child: ChatBubble(message: data["message"],
            isCurrentUser: isCurrentUser,));
  }

  Widget _buildUserInput(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        children: [
          Expanded(
              child:MyTextField(
                controller: _messageController,
                hinttext: "Type a message",
                obsecureText: false,
                focusNode: myFocusNode,
              ) ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: BoxShape.circle
            ),
            child: IconButton(onPressed: sendMessage,
                icon: Icon(Icons.send,)),
          )
        ],
      ),
    );
  }
}
