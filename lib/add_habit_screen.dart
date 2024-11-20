import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isFieldEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Rich dark background color
      appBar: AppBar(
        title: Text(
          'Add New Habit',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto', // Changed to 'Roboto' for a formal look
            fontWeight: FontWeight.w500, // Slightly lighter weight for elegance
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF1A1A1A), // Darker shade for AppBar
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter a Habit Name",
              style: TextStyle(
                color: Colors.white70, // Softer white for the title
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto', // Changed to 'Roboto' for consistency
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[850], // Dark gray background for input
                labelText: 'Habit Name',
                labelStyle: TextStyle(
                    color: Color(0xFFFFD700)), // Soft yellow label text
                errorText: _isFieldEmpty ? 'This field cannot be empty' : null,
                errorStyle: TextStyle(
                  color: Color(0xFFFF6F61), // Soft Coral Red for error text
                  fontFamily: 'Roboto', // Formal font for error text
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFFFFD700)), // Yellow border on focus
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) {
                    // Check for empty or whitespace-only text
                    setState(() {
                      _isFieldEmpty = true;
                    });

                    // Show SnackBar for invalid input
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter a valid habit name',
                          style: TextStyle(
                              color: Colors
                                  .black87), // Dark gray text color for readability
                        ),
                        backgroundColor: Color(
                            0xFFFFD700), // Soft yellow background for SnackBar
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.of(context)
                        .pop(_controller.text.trim()); // Return trimmed text
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 230, 195, 1), // Soft yellow button background
                  foregroundColor:
                      Colors.black, // Black text color for the button
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation:
                      8, // Increased elevation for a more prominent effect
                ),
                child: Text(
                  'Add Habit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight
                        .w500, // Lighter weight for a more elegant feel
                    fontFamily: 'Roboto', // Consistent formal font
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
