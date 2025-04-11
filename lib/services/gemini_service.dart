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

  Future<String> generateSummary(String content) async {
    try {
      String prompt = """
      Based on this data safety information:
      1. Compare this app's data collection with industry standards
      2. Suggest potential privacy improvements
      3. Rate the overall privacy risk (Low/Medium/High)
      Content to analyze:
      """;

      prompt = '$prompt\n$content' ;
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No response received';
      } catch (e) {
        return 'Error processing summary: $e';
    }
  }


}