import 'package:boint_12/api_service.dart';
import 'package:boint_12/drawer_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token; // Token passed from the login page
  int openemisId; // User's openemis ID passed from login

  HomePage({required this.token, required this.openemisId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? userKey; // Stores the key retrieved from getKey
  Map<String, dynamic>?
      userInfo; // Stores user information retrieved from getUserInfo
  bool isLoading = true; // Loading indicator
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); // Fetch details when the page loads
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void search() async {
    if (_formKey.currentState?.validate()??false) {
      String username = _controller.text;
      widget.openemisId = int.parse(username);
      // search(username);
      setState(() {
        fetchUserDetails();
      });
    } else {
      // If the form is invalid, show a messageF
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid User')),
      );
    }
  }

  Future<void> fetchUserDetails() async {
    isLoading = true;
    print("Fetch detail");
    try {
      // Call getKey API
      final key = await ApiService.getKey(widget.token, widget.openemisId);
      print("previsously checking the $key");

      if (key != null) {
        setState(() {
          userKey = key; // Store the retrieved key
        });

        // Call getUserInfo API using the retrieved key
        final userResponse = await ApiService.getUserInfo(widget.token, key);

        if (userResponse != null) {
          setState(() {
            userInfo = userResponse['data']; // Store user information
          });
        }
      } 
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        userInfo=null;
      });
      // Handle error appropriately (e.g., show a dialog or snack bar)
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  // Function to format user details in a readable format

// Function to display a nested object
  Widget displayNestedObject(Map<String, dynamic> nestedData, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),

              // Loop through the fields in the nested object and display them
              for (var entry in nestedData.entries)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${capitalizeFirstLetter(entry.key)}: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${capitalizeFirstLetter(entry.value.toString())}',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// Function to display a list of items
  Widget displayList(List<dynamic> listData, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
              // Loop through the list and display each item
              for (var item in listData)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${capitalizeFirstLetter(item.toString())}',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// Main function to dynamically display the user information
  Widget displayUserInfo(Map<String, dynamic> userInfo) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 6.0), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Iterate through the user information and display based on type
            for (var entry in userInfo.entries)
              if (entry.value is String ||
                  entry.value is int ||
                  entry.value == null) // Handle simple types (String, int)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Vertical padding between rows
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for each section
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Shadow effect
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Padding inside the container
                      child: Row(
                        children: [
                          // Key Section
                          Expanded(
                            flex: 2,
                            child: Text(
                              capitalizeFirstLetter('${entry.key}:'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Bold for keys
                                fontSize: 16, // Size of the key text
                                color:
                                    Colors.blueAccent, // Color for the key text
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Value Section
                          Expanded(
                            flex: 3,
                            child: Text(
                              capitalizeFirstLetter('${entry.value}'),
                              style: TextStyle(
                                fontSize: 16, // Size of the value text
                                color:
                                    Colors.black87, // Color for the value text
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handle long text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (entry.value is Map) // Handle nested objects (Map)
                displayNestedObject(
                    entry.value, capitalizeFirstLetter(entry.key))
              else if (entry.value is List) // Handle lists
                displayList(entry.value, capitalizeFirstLetter(entry.key)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/openemiswhite.png',
              height: 34,
              width: 40,
            ),
            Text(
              " OpenEMIS User",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        search();
                      },
                    ),
                    labelText: 'Enter 10-digit User Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length != 10) {
                      return 'Username must be exactly 10 digits';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Username must be numeric';
                    }
                    return null;
                  },
                ),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : userInfo != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5),
                        child: displayUserInfo(
                            userInfo!), // Display formatted user info
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('No user information available.'),
                        ],
                      ),
          ],
        ),
      ),
      endDrawer: DrawerMenu(
          username: widget.openemisId.toString()), // Drawer menu for navigation
    );
  }
}
