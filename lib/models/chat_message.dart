class ChatMessage {
  final String content;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUserMessage,
    required this.timestamp,
  });
}