import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isValidEmail(String email) {
    // Basic email regex for validation
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 200,
        title: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Pact-Logo.jpeg',height: 100,),
                SizedBox(height: 20),
                Text('Pact.', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username', style: TextStyle(color: Colors.white)),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Email', style: TextStyle(color: Colors.white)),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Password', style: TextStyle(color: Colors.white)),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement your sign-up logic here
                    String username = _usernameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                      if (isValidEmail(email)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid email address')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
