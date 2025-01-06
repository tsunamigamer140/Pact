import 'package:flutter/services.dart'; // Import for SystemNavigator
import 'package:flutter/material.dart';
import 'summarizer_page.dart';
import 'settings_page.dart';
import 'my_apps_page.dart';
import 'dictionary_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
    } else if (index ==2) {
      Navigator.pushNamedAndRemoveUntil(context, '/about_us', (route) => false);

    }
  }

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    height: 100,  // Adjust the size of the image as needed
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            centerTitle: true,  // Ensure the title is centered in the AppBar
          ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Pact.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(color: Colors.white70),
                SizedBox(height: 20),
                _buildToolItem(
                  context,
                  'My Apps',
                  Icons.apps,
                  'View your apps and their key terms in simple summaries.',
                  MyAppsPage(),
                ),
                SizedBox(height: 20),
                _buildToolItem(
                  context,
                  'Summarizer',
                  Icons.text_snippet,
                  'Quickly generate concise summaries of complex legal documents.',
                  SummarizerPage(),
                ),
                SizedBox(height: 20),
                _buildToolItem(
                  context,
                  'Dictionary',
                  Icons.book,
                  'Understand legal and technical terms with simplified explanations.',
                  DictionaryPage(),
                ),
              ],
            ),
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildToolItem(BuildContext context, String title, IconData icon, String description, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
