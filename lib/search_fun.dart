import 'package:flutter/material.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  bool _isLoading = false;

  // Mock list of possible user numbers (for demonstration purposes)
  List<String> allUserNumbers = [
    "1522271965",
    "1522271966",
    "1522271967",
    "1522271968",
    "1522271969",
    "1522271970"
  ];

  // Function to fetch user suggestions based on typed input
  void _getSuggestions(String query) {
    setState(() {
      _suggestions = allUserNumbers
          .where((number) => number.startsWith(query))
          .toList();
    });
  }

  // Function to handle the search action
  void _searchUser() {
    if (_controller.text.length == 10) {
      setState(() {
        _isLoading = true;
      });
      // You can call an API or any logic to fetch user data based on the entered number
      // For now, we'll simulate the loading process
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // Perform the action to fetch data for the selected user
        // For example: fetchUserData(_controller.text);
        // We'll just print the user number for now
        print("Fetching data for user: ${_controller.text}");
      });
    } else {
      // Show an error message if the number is not 10 digits long
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a 10-digit number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search box with suggestions
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Enter 10-digit number",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.length >= 3) {
                        _getSuggestions(value); // Show suggestions after typing 3 digits
                      } else {
                        setState(() {
                          _suggestions = []; // Clear suggestions if less than 3 digits
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUser,
                ),
              ],
            ),
            SizedBox(height: 16),
            // Show suggestions if any
            if (_suggestions.isNotEmpty)
              Container(
                height: 150,
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () {
                        _controller.text = _suggestions[index];
                        setState(() {
                          _suggestions = []; // Clear suggestions after selection
                        });
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            // Loading indicator and data display
            if (_isLoading)
              Center(child: CircularProgressIndicator()),
            // Add your data display here
            // For example, after the data is loaded, show user details in a list or cards
            // For now, just show a placeholder text
            if (!_isLoading && _controller.text.isNotEmpty)
              Center(child: Text("Showing data for user: ${_controller.text}")),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserSearchPage(),
  ));
}
