import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kang/router.dart';
import 'package:kang/services/api_service.dart';
// The SignupPage widget
@RoutePage()
class SignupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  Future<void> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required BuildContext context, // Pass BuildContext for UI updates
  }) async {
    final ApiService apiService = ApiService();  // Create an instance of ApiService

    final Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    };

    try {
      // Send POST request
      final response = await apiService.postData('/auth/signup', data);

      print('Response: $response');
      if (response['status'] == 'failed') {
        // Show the reason from the backend if signup failed
        final String reason = response['reason'] ?? 'Signup failed, please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(reason)),
        );
      } else {
        print('Signup Response: $response');
        // Navigate to OTP page (if signup is successful) and pass all data
        context.router.replace(OtpRoute(
          name: name,
          phone: phone,
          email: email,
          password: password,
        ));
      }
    } catch (e) {
      print('Error during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create an Account",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String name = _nameController.text;
                final String phone = _phoneController.text;
                final String email = _emailController.text;
                final String password = _passwordController.text;

                try {
                  // Call signup function
                  await signup(
                    name: name,
                    phone: phone,
                    email: email,
                    password: password,
                    context: context, // Pass BuildContext for UI updates
                  );
                } catch (e) {
                  // Handle any unexpected errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Signup failed: $e")),
                  );
                }
              },
              child: Text("Sign Up"),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Navigate to login page
                // context.router.pushNamed('');
                context.router.replace(LoginRoute());
              },
              child: Text(
                "Already have an account? Login here",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
