import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:caker/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:caker/boxes.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/gemini_service.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({super.key});

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  final GeminiService _geminiService = GeminiService();

  bool _showChat = false;
  bool _chatEnabled = false;

  String privacyPolicy = 'Loading Privacy Policy...';
  String geminiSummary = 'Loading Summary...';
  final String apiKey = 'AIzaSyBlLGFkIXLlWqTUHetyPKnLkePFeZ4THdE';

  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? messageFromOverlay;
  String iconurl = 'https://play-lh.googleusercontent.com/fgd_JMPhg5MIXlGYDv1hnsqYaP98Yf8-MtLhr7ol_sQm8ZdRkXKE9LgqdLoU6Y_Lguc=w240-h480-rw';

  /*
  Alternate Colours for the overlay background
  final _goldColors = const [
    Color.fromARGB(200, 162, 120, 13),
    Color.fromARGB(200, 235, 209, 151),
    Color.fromARGB(200, 162, 120, 13),
  ];

  final _silverColors = const [
    Color(0xFFAEB2B8),
    Color(0xFFC7C9CB),
    Color(0xFFD7D7D8),
    Color(0xFFAEB2B8),
  ];
  */

  Future<void> getGeminiSummary(String content) async {
    try {
      final summary = await _geminiService.generateSummary(content);
      setState(() {
        geminiSummary = summary;
        _chatEnabled = true;
      });
    } catch (e) {
      setState(() {
        geminiSummary = 'Error processing summary: $e';
      });
    }
  }

  Future<void> handleApp() async {
    if(messageFromOverlay != null){
      final policyText = await getPrivacyPolicy(messageFromOverlay!);
      setState(() {
        privacyPolicy = policyText;
      });

      await getGeminiSummary(policyText);
    }
  }

  Future<String> getPrivacyPolicy(String packageName) async {
    try {
      // Step 1: Get Play Store page
      final playStoreUrl = 'https://play.google.com/store/apps/datasafety?id=$packageName&hl=en_US';
      log('Fetching Play Store page: $playStoreUrl');
      final response = await http.get(
        Uri.parse(playStoreUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        },
        );
      
      if (response.statusCode != 200) {
        return 'Failed to fetch Play Store page';
      }
      log('Response body length: ${response.body.length}');

      // Step 2: Parse HTML and find privacy policy link
      final document = parser.parse(response.body);
      log('Document: $document');
      final privacyLinks = document.getElementsByClassName('GO2pB');
      final imgElement = document.getElementsByClassName('T75of hmeIpf').firstOrNull;
      iconurl = imgElement?.attributes['src'] ?? 'https://play-lh.googleusercontent.com/fgd_JMPhg5MIXlGYDv1hnsqYaP98Yf8-MtLhr7ol_sQm8ZdRkXKE9LgqdLoU6Y_Lguc=w240-h480-rw';

      log('Privacy Links: $privacyLinks');
      String? privacyUrl;
      
      for (var element in privacyLinks) {
        final link = element.attributes['href'];
        log('Link: $link');
        if (link != null && (link.contains('privacy') || link.contains('policy'))) {
          privacyUrl = link;
          break;
        }
      }

      log('Privacy URL: $privacyUrl');
      if (privacyUrl == null) {
        return 'Privacy policy link not found';
      }

      // Step 3: Fetch privacy policy content
      final policyResponse = await http.get(
        Uri.parse(privacyUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        },
      );
      if (policyResponse.statusCode != 200) {
        return 'Failed to fetch privacy policy';
      }

      // Step 4: Parse and clean privacy policy text
      final policyDocument = parser.parse(policyResponse.body);
      //final textContent = policyDocument.body?.text ?? 'No content found';

      // Find all paragraph elements
      final paragraphs = policyDocument.getElementsByTagName('p');
      log('Found ${paragraphs.length} paragraphs');

      if (paragraphs.isEmpty) {
        return 'No paragraph content found';
      }

      // Combine all paragraph texts
      final textContent = paragraphs
          .map((p) => p.text.trim())
          .where((text) => text.isNotEmpty)  // Filter out empty paragraphs
          .join('\n\n');  // Add double newline between paragraphs

      return textContent.isEmpty ? 'No content found in paragraphs' : textContent;
    } catch (e) {
      log('Error fetching privacy policy: $e');
      return 'Error: Failed to fetch privacy policy';
    }
  }

  void handleMessage(dynamic message) {
    log("message from UI: $message");
    setState(() {
      messageFromOverlay = '$message';
    });
    if (message is String && message.isNotEmpty) {
      handleApp();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homePort != null) return;
      final res = IsolateNameServer.registerPortWithName(
        _receivePort.sendPort,
        _kPortNameOverlay,
      );
      log("$res : HOME");
      _receivePort.listen(handleMessage);
    });
  }

  // Add dispose to clean up resources
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(_kPortNameOverlay);
    _receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: _showChat ? 7 : 10,
              child: SwipeableBoxes(
              boxContents: [
                BoxContent(
                  bodyText: privacyPolicy,
                  iconUrl: iconurl,
                  title: 'Privacy Policy',
                  subtitle: messageFromOverlay ?? ""
                ),
                BoxContent(
                  bodyText: geminiSummary,
                  iconUrl: 'https://play-lh.googleusercontent.com/fgd_JMPhg5MIXlGYDv1hnsqYaP98Yf8-MtLhr7ol_sQm8ZdRkXKE9LgqdLoU6Y_Lguc=w240-h480-rw',
                  title: 'Summary',
                  subtitle: 'From Gemini'
                ),
              ],
              showChat: _showChat,
            ),
          ),
          if (_showChat)
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: ChatScreen(
                  initialContext: geminiSummary,
                ),
              ),
            ),
            const Divider(color: Colors.black54),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pact Privacy",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _chatEnabled
                      ? () => setState(() => _showChat = !_showChat)
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[850],
                      disabledBackgroundColor: Colors.grey[800],
                    ),
                    child: Text(
                      _showChat ? "Hide Chat" : "Show Chat",
                      style: TextStyle(
                        color: _chatEnabled ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () async {
                      await FlutterOverlayWindow.closeOverlay();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
