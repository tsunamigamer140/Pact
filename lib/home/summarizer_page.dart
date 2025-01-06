import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';

class SummarizerPage extends StatelessWidget {
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
            ],
          ),
        ),
        centerTitle: true,  // Ensure the title is centered in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter text to summarize:', style: TextStyle(color: Colors.white)),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type here...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 20),
            Text('Summary:', style: TextStyle(color: Colors.white)),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Summary will appear here...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              readOnly: true,
            ),
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
            Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
          } else if (index == 1) {
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
          } else if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, '/about_us', (route) => false);
          }
        },
      ),
    );
  }
}
