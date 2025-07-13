import 'dart:developer'; // For debugging

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kang/router.dart';
import 'package:kang/services/api_service.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  // Function to fetch user info
  Future<void> fetchUserInfo() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken'); // Get token
      log('AccessToken: $accessToken', name: 'ProfilePageDebug');

      final response = await apiService.fetchData(
        '/user',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      setState(() {
        _userData = response['user']; // Extract user data
        _isLoading = false;
      });
    } catch (e) {
      log('Error: $e', name: 'ProfilePageDebug');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      // Clear all stored data (access token, email, name, phone)
      await storage.deleteAll();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged out successfully!")),
      );

      // Navigate back to login or onboarding screen
      context.router.replaceAll([LoginRoute()]);
      // Use your AutoRoute path
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during logout: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Fetch user data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout, // Call logout function
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userData == null
          ? Center(child: Text('Failed to load user data'))
          : Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: _userData!['profilePicture'] != null &&
                      _userData!['profilePicture']!.isNotEmpty
                      ? NetworkImage(_userData!['profilePicture'])
                      : AssetImage('assets/default_profile.png')
                  as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              Text(
                _userData!['name'] ?? 'Unknown',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _userData!['email'] ?? 'No email provided',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withAlpha(140),
                ),
              ),
              SizedBox(height: 8),
              Text(
                _userData!['phone'] ?? 'No phone number provided',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withAlpha(140),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
