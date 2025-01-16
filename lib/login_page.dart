import 'package:boint_12/search_page.dart';
import 'package:flutter/material.dart';
import 'package:boint_12/api_service.dart';
import 'package:boint_12/session_manager.dart';
// import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _serverController= TextEditingController(text: "https://demo.openemis.org/core");
  late String openemisid;
  bool _isPasswordVisible = false;
  Future<void> login() async {
    openemisid = usernameController.text;
    final response = await ApiService.login(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (response != null) {
      final token = response['data']['token'];
      // print('Login Successful. Token: $token');
      // print('username is: $openemisid');
      SessionManager.saveToken(token);
      // final keyResponse = await ApiService.getKey(token,int.parse(openemisid));
      // print('key  response is: $keyResponse');
      // final mainresponse = await ApiService.getUserInfo(token,keyResponse as int);
      // print(mainresponse)
      // SessionManager.saveToken(response['data']['token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            token: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wrong Credentials! Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo or Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/openemis.png', 
                    height: 40,
                    width: 40,
                  ),
                  Text(
                    " OpenEMIS Core",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 18, 112, 189),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Username Field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // const SizedBox(height: 15),

              const SizedBox(height: 15),

              // Server Field
              TextField(
                controller: _serverController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.broadcast_on_personal_rounded),
                  labelText: "Server",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 18, 112, 189),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Username and Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle forgot username
                    },
                    child: Text("Forgot username?"),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text("Forgot password?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
