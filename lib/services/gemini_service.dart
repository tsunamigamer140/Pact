import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const apiKey = 'AIzaSyBlLGFkIXLlWqTUHetyPKnLkePFeZ4THdE';
  final GenerativeModel _model;
  late ChatSession _chat;

  GeminiService() : _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: apiKey,
  ) {
    _startNewChat();
  }

  void startNewChat() {
    _chat = _model.startChat();
  }

  void _startNewChat() {
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    final response = await _chat.sendMessage(Content.text(message));
    return response.text ?? 'No response';
  }

  Future<void> initializeWithContext(String context) async {
    _chat = _model.startChat();
    await _chat.sendMessage(Content.text(context));
  }


}