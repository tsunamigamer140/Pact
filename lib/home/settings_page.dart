import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'data_privacy_page.dart';
import 'summary_page.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 150,  // Adjust as needed
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the content vertically
            children: [
              Image.asset(
                'assets/Pact-Logo.jpeg', // Image to replace the eye icon
                height: 75,  // Adjust the size of the image as needed
              ),
              SizedBox(height: 5),
              Text('Pact.', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        centerTitle: true,  // Ensure the title is centered in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'SETTINGS',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            SizedBox(height: 20),
            SettingsButton(title: 'Notifications', route: NotificationPage()),
            SettingsButton(title: 'Data Privacy', route: DataPrivacyPage()),
            SettingsButton(title: 'Summary', route: SummaryPage()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline, color: Colors.white),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index ==1){
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
          } else if (index ==2){
            Navigator.pushNamedAndRemoveUntil(context, '/about_us', (route) => false);

          }
        },
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String title;
  final Widget route;

  SettingsButton({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
