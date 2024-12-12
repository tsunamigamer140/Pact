import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:caker/boxes.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({super.key});

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  bool isGold = true;

  final _goldColors = const [
    Color(0xFFa2790d),
    Color(0xFFebd197),
    Color(0xFFa2790d),
  ];

  final _silverColors = const [
    Color(0xFFAEB2B8),
    Color(0xFFC7C9CB),
    Color(0xFFD7D7D8),
    Color(0xFFAEB2B8),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isGold ? _goldColors : _silverColors,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isGold = !isGold;
              });
              FlutterOverlayWindow.getOverlayPosition().then((value) {
                log("Overlay Position: $value");
              });
            },
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx16VdHh2dDEZKu6KDUCXcTmMfqWuPygi-0w&s"),
                          ),
                        ),
                      ),
                      title: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("com.android.instagram"),
                    ),
                    const OrangeBoxWithText(text: """I. What kinds of information do we collect?
To provide the Meta Products, we must process information about you. The type of information that we collect depends on how you use our Products. You can learn how to access and delete information that we collect by visiting the Facebook settings and Instagram settings.
Things that you and others do and provide.
Information and content you provide. We collect the content, communications and other information you provide when you use our Products, including when you sign up for an account, create or share content and message or communicate with others. This can include information in or about the content that you provide (e.g. metadata), such as the location of a photo or the date a file was created. It can also include what you see through features that we provide, such as our camera, so we can do things such as suggest masks and filters that you might like, or give you tips on using camera formats. Our systems automatically process content and communications that you and others provide to analyse context and what's in them for the purposes described below. Learn more about how you can control who can see the things you share.
Data with special protections: You can choose to provide information in your Facebook profile fields or life events about your religious views, political views, who you are "interested in" or your health. This and other information (such as racial or ethnic origin, philosophical beliefs or trade union membership) could be subject to special protections under the laws of your country.
Networks and connections. We collect information about the people, accounts, hashtags, Facebook groups and Pages that you are connected to and how you interact with them across our Products, such as people you communicate with the most or groups that you are part of. We also collect contact information if you choose to upload, sync or import it from a device (such as an address book or call log or SMS log history), which we use for things such as helping you and others find people you may know and for the other purposes listed below.
Your usage. We collect information about how you use our Products, such as the types of content that you view or engage with, the features you use, the actions you take, the people or accounts you interact with and the time, frequency and duration of your activities. For example, we log when you're using and have last used our Products, and what posts, videos and other content you view on our Products. We also collect information about how you use features such as our camera.
Information about transactions made on our Products. If you use our Products for purchases or other financial transactions (such as when you make a purchase in a game or make a donation), we collect information about the purchase or transaction. This includes payment information, such as your credit or debit card number and other card information, other account and authentication information, and billing, delivery and contact details.
Things others do and information they provide about you. We also receive and analyse content, communications and information that other people provide when they use our Products. This can include information about you, such as when others share or comment on a photo of you, send a message to you or upload, sync or import your contact information.
"""),
                    ListTile(
                      leading: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://cdn.discordapp.com/attachments/1167492825366138921/1316403808582242334/pacter.jpg?ex=675aec15&is=67599a95&hm=8014a8cb16c61fc53cd915a3792faf5dd75864806597bb3885072abd4e8880b3&"),
                          ),
                        ),
                      ),
                      title: const Text(
                        "Summary Policy",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("from Gemini"),
                    ),
                    const OrangeBoxWithText(text: """Your Info: Meta collects content, communications, and sensitive data you share.

Connections: Tracks your interactions with people, groups, and synced contacts.

Usage: Logs how you use features, view content, and interact with Products.

Transactions: Collects purchase details and data others share about you."""),
                    const TextRectangleGrid(texts: ["+ Tell me more", "+ Simpler", "+ What data?", "+ "]),
                    const Spacer(),
                    const Divider(color: Colors.black54),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Package Name: com.deez.nuts"),
                              Text("John Ligma"),
                            ],
                          ),
                          Text(
                            "Pact Privacy",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await FlutterOverlayWindow.closeOverlay();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
