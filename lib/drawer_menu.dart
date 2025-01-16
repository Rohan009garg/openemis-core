import 'package:boint_12/login_page.dart';
import 'package:boint_12/search_page.dart';
import 'package:boint_12/session_manager.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final String? username;

  const DrawerMenu({Key? key, this.username}) : super(key: key);

  void logout(BuildContext context) {
    // Clear the token from TokenManager
    SessionManager.clearToken();

    // Navigate to the Login Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.white, fontSize: 26,
                  fontWeight: FontWeight.bold),
                ),
                if (username != null)
                  Text(
                    username!,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              String? token = SessionManager.getToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(token: token)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
