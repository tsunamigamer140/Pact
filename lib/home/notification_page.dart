import 'package:flutter/material.dart';
import 'home_page.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/notification';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _notifyPolicyUpdates = false;
  bool _notifyAllUpdates = false;
  bool _notifyMajorUpdates = false;

  int _selectedIndex = 1;  // Default to settings since it's a settings subpage

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
      body: SingleChildScrollView( // Added SingleChildScrollView to make content scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Notify me of Policy Updates', style: TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: _notifyPolicyUpdates,
                  onChanged: (value) {
                    setState(() {
                      _notifyPolicyUpdates = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Notify me of All Updates', style: TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: _notifyAllUpdates,
                  onChanged: (value) {
                    setState(() {
                      _notifyAllUpdates = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Notify me of Major Updates', style: TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: _notifyMajorUpdates,
                  onChanged: (value) {
                    setState(() {
                      _notifyMajorUpdates = value;
                    });
                  },
                ),
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
    );
  }
}
