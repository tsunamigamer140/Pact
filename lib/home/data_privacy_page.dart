import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';

class DataPrivacyPage extends StatefulWidget {
  static const routeName = '/data_privacy';

  @override
  _DataPrivacyPageState createState() => _DataPrivacyPageState();
}

class _DataPrivacyPageState extends State<DataPrivacyPage> {
  bool _shareDataWithPartners = false;
  bool _allowDataCollection = false;

  final Map<String, bool> _toggles = {
    'Data collections': false,
    'Data Analytics': false,
    'Overlay Access': false,
    'Storage Access': false,
  };

  int _selectedIndex = 1;  // Default to settings since it's a settings subpage

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
    } else if (index == 2) {
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DATA PRIVACY',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 20),
              Divider(color:Colors.white70),
              Expanded(
                child: ListView(
                  shrinkWrap: true, // Ensure the ListView does not take up infinite height
                  children: _toggles.keys.map((key) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300), // Adjust the duration as needed
                      child: SwitchListTile(
                        key: ValueKey<String>(key), // Ensure the widget is uniquely identified
                        title: Text(
                          key,
                          style: const TextStyle(color: Colors.white),
                        ),
                        value: _toggles[key]!,
                        activeColor: Colors.deepPurple,
                        onChanged: (bool value) {
                          setState(() {
                            _toggles[key] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
