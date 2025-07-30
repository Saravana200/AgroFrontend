import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the storage package
import 'package:kang/models/models.dart';
import 'package:kang/repos/auth_repo.dart';

import '../router.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> _checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    // Retrieve the access token (or any other data that signifies the user is logged in)
    String? accessToken = await storage.read(key: 'token');
    if (accessToken != null && accessToken.isNotEmpty) {
      // User is logged in, navigate to HomePage
      context.router.replace(MyAppRoute()); // user-profile
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool state = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(genericNotifierProvider);

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
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: "User Name",
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
                onPressed: () async {
                  // Logic to log in
                  String name = _userNameController.text.trim();
                  String password = _passwordController.text.trim();
                  final loginReq = LoginRequest(name: name, password: password);
                  try {
                    final notifier = ref.read(genericNotifierProvider.notifier);
                    await notifier.login(loginReq);
                    context.router.replace(MyAppRoute());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Login failed: $e"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                },
                child: loginState.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Log In"),
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
