import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 150, // Adjust as needed
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
              Image.asset(
                'assets/Pact-Logo.jpeg', // Image to replace the eye icon
                height: 50, // Adjust the size of the image as needed
              ),
              SizedBox(height: 5),
              Text('Pact.', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        centerTitle: true, // Ensure the title is centered in the AppBar
      ),
      body: Container(
        color: Colors.black, // Set the background color to black
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'An app made by engineering students, to spread awareness among people about privacy policies of different apps.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              'If you have any concerns, contact us at: pactprivacy@gmail.com',
              textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            // Placeholder for images
            // Image.asset('assets/image1.png', height: 200, fit: BoxFit.cover), // Add your image path
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
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
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsPage()),
            );
          }
        },
      ),
    );
  }
}
