import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String initialContext;
  
  const ChatScreen({
    super.key,
    required this.initialContext,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startNewChat();
    _initializeChat();
    // Request focus when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _initializeChat() async {
    await _geminiService.initializeWithContext(widget.initialContext);
  }  

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMessage = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(
        content: userMessage,
        isUserMessage: true,
        timestamp: DateTime.now(),
      ));
    });

    // Get AI response
    String response = await _geminiService.sendMessage(userMessage);
    
    setState(() {
      _messages.add(ChatMessage(
        content: response,
        isUserMessage: false,
        timestamp: DateTime.now(),
      ));
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
      _geminiService.startNewChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}