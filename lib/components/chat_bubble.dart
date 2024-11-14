import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {

  final String message;
  final bool isCurrentUser;

  const ChatBubble({super.key,required this.message,required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser? Theme.of(context).colorScheme.inversePrimary
            :Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16)
      ),
      padding:EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2.5,horizontal: 25),
      child: Text(message),
    );
  }
}
