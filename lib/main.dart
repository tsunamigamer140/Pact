import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:caker/overlays/true_caller_overlay.dart';

import 'package:caker/home/about_us_page.dart';
import 'package:caker/home/home_page.dart';
import 'package:caker/home/login_page.dart';
import 'package:caker/home/settings_page.dart';
import 'package:caker/home/notification_page.dart';
import 'package:caker/home/data_privacy_page.dart';
import 'package:caker/home/summary_page.dart';
import 'package:caker/home/my_apps_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  Future<void> showOverlay(String packageName) async {
  try {
    if (await FlutterOverlayWindow.isPermissionGranted()) {
      await Future.delayed(const Duration(milliseconds: 500));
      await FlutterOverlayWindow.showOverlay(
        enableDrag: false,
        height: WindowSize.matchParent,
        width: WindowSize.matchParent,
        alignment: OverlayAlignment.center,
        flag: OverlayFlag.focusPointer,
        overlayTitle: "Overlay",
        overlayContent: packageName,
        startPosition: const OverlayPosition(-0.8, 19.2),
      );
    }
  } catch (e) {
    log("Error showing overlay: $e");
  }
}

  Future<void> _setUpMethodChannelListener() async {
    try {
      platform.setMethodCallHandler((call) async {
        if(!mounted) return null;

        String packageName = call.method; // Get package name from method name
        log("Received package name: $packageName");
        homePort ??=IsolateNameServer.lookupPortByName(_kPortNameOverlay);
        if (homePort != null){
          homePort?.send(packageName);
        }
        showOverlay(packageName);
        return null;
      });
    } catch (e) {
      log("Error setting up method channel listener: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        '/settings': (context) => SettingsScreen(),
        '/notification': (context) => NotificationPage(),
        '/data_privacy': (context) => DataPrivacyPage(),
        '/summary': (context) => SummaryPage(),
        '/about_us': (context) => AboutUsPage(),
      },
    );
  }
}