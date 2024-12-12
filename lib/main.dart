import 'dart:developer';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caker/home_page.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:caker/overlays/true_caller_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrueCallerOverlay(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const platform = MethodChannel("com.example.caker/overlay");

  @override
  void initState(){
    super.initState();
    _setUpMethodChannelListener();
  }

  void _setUpMethodChannelListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "showOverlay") {
        _showOverlay();
      }
    });
  }

  Future<void> _showOverlay() async {
    try {
      final bool isGranted = await FlutterOverlayWindow.isPermissionGranted();
      if (!isGranted) {
        await FlutterOverlayWindow.requestPermission();
      }

      await FlutterOverlayWindow.showOverlay(
        /*
        enableDrag: false,
        overlayTitle: "Pact Overlay Active",
        overlayContent: 'showing summaries now',
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
        // ignore: use_build_context_synchronously
        height: (MediaQuery.of(context).size.height * 2.0).toInt(),
        width: WindowSize.matchParent,
        startPosition: const OverlayPosition(0, 0),
        */
      );

      log("Overlay shown successfully");
    } catch (e) {
      log("Error showing overlay: $e");
    }
  }

  /*
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caker App')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showOverlay,
          child: const Text("Show Overlay"),
        ),
      ),
    );
  }
}