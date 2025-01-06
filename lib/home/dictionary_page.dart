import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 150,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Pact-Logo.jpeg',
                height: 75,
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dictionary', style: TextStyle(color: Colors.white, fontSize: 22)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter word to look up',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.collection('Dictionary').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    return doc['Term'].toString().toLowerCase().contains(searchTerm) ||
                        doc['Meaning'].toString().toLowerCase().contains(searchTerm);
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = filteredDocs[index];
                      return ListTile(
                        title: Text(
                          doc['Term'],
                          style: TextStyle(
                            color: Colors.white, // Brighter color for terms
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          doc['Meaning'],
                          style: TextStyle(
                            color: Colors.white60, // Brighter color for meanings
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    },
                  );
                },
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
