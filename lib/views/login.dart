import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the storage package

import '../router.dart';
import '../services/api_service.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();

  Future<void> _checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    // Retrieve the access token (or any other data that signifies the user is logged in)
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null && accessToken.isNotEmpty) {
      // User is logged in, navigate to HomePage
      context.router.replace(ProfileRoute());  // user-profile
    }
  }

  Future<void> _login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {

      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      if (email == "test@gmail.com" && password == "12345678") {
        context.router.push(MyAppRoute());
      }

      try {
        // Send POST request to the login endpoint
        final response = await apiService.postData(
          '/auth/login',
          data,
        );
        print(response);

        // Handle the response
        if (response['status'] == 'success') {
          // Login successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login successful!")),
          );

          // Securely store the data
          final storage = FlutterSecureStorage();

          // Store sensitive data (access token)
          await storage.write(key: 'accessToken', value: response['accessToken']);

          // Store non-sensitive data (email, name, phone)
          await storage.write(key: 'email', value: response['credentials']['email']);
          await storage.write(key: 'name', value: response['credentials']['name']);
          await storage.write(key: 'phone', value: response['credentials']['phone']);

          // Navigate to HomePage after successful login
          context.router
              .push(MyAppRoute()); // Navigate to HomeRoute using AutoRoute
        } else {
          // Show error if login failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login failed: ${response['reason']}")),
          );
        }
      } catch (e) {
        // Handle any exceptions that may occur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both email and password")),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: _obscurePassword,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Logic to log in
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  // Call the _login function with the email and password
                  _login(email, password);
                },
                child: Text("Log In"),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to ForgotPasswordPage
                  // context.router.replace(HomeRoute());
                },
                child: Text("Forgot Password?"),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  // Navigate to SignupPage
                  // context.router.pushNamed('/signup');
                  context.router.replace(SignupRoute());
                },
                child: Text("Don’t have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
