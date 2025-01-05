import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  @override
  void initState(){
    super.initState();

    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    log("$res: OVERLAY");
    _receivePort.listen((message) {
      log("message from OVERLAY: $message");
      setState(() {
        latestMessageFromOverlay = 'Latest Message From Overlay: $message';
      });
    });
    _setUpMethodChannelListener();
  }

  Future<void> _setUpMethodChannelListener() async {
    platform.setMethodCallHandler((call) async {
      String packageName = call.method; // Get package name from method name
      log("Received package name: $packageName");
      homePort ??=IsolateNameServer.lookupPortByName(_kPortNameOverlay);
      homePort?.send(packageName);
      if(await FlutterOverlayWindow.isPermissionGranted()){
        await Future.delayed(const Duration(milliseconds: 500));
        await FlutterOverlayWindow.showOverlay(
          enableDrag: false,
          height: WindowSize.matchParent,
          width: WindowSize.matchParent,
          alignment: OverlayAlignment.center,
          flag: OverlayFlag.defaultFlag,
          overlayTitle: "Overlay",
          overlayContent: packageName, // Pass package name to overlay
          startPosition: const OverlayPosition(-0.8, 19.2),
        );
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caker App')),
      body: const Center(
        child: Text('Welcome to Caker App'),
      ),
    );
  }
}