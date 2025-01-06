import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUserMessage 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUserMessage 
              ? Colors.blue[100] 
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message.content),
      ),
    );
  }
}