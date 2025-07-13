import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kang/router.dart';
import 'package:kang/services/api_service.dart';

@RoutePage()
class OtpPage extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String password;

  const OtpPage({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  }) ;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isResendDisabled = false;
  int _remainingTime = 30;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isResendDisabled = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  // Updated _verifyOtp function
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length == 6) {
      final apiService = ApiService();

      final Map<String, dynamic> data = {
        'email': widget.email,
        'phone': widget.phone,
        'name': widget.name,
        'password': widget.password,
        'otp': otp,
      };

      try {
        // Send POST request to verify OTP and create account using postData
        final response = await apiService.postData(
            '/auth/verify-otp-create-account',
            data); // Update 'auth/verify-otp' with the actual endpoint
        print(response);
        // Handle response here
        if (response['status'] == 'success') {
          // OTP verified successfully, account created
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account created successfully!")),
          );
          // Securely store the data
          // final storage = FlutterSecureStorage();
          //
          // // Store sensitive data (access token)
          // await storage.write(key: 'accessToken', value: response['accessToken']);
          //
          // // Store non-sensitive data (email, name, phone)
          // await storage.write(key: 'email', value: response['credentials']['email']);
          // await storage.write(key: 'name', value: response['credentials']['name']);
          // await storage.write(key: 'phone', value: response['credentials']['phone']);

          // Navigate to HomePage after successful OTP verification
          context.router
              .push(MyAppRoute()); // Navigate to HomeRoute using AutoRoute
        } else {
          // Show error if OTP verification failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("OTP verification failed: ${response['reason']}")),
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
        SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
    }
  }

  void _resendOtp() {
    setState(() {
      _isResendDisabled = true;
      _remainingTime = 30; // Reset timer
    });
    _startTimer();
    // Logic to resend OTP
    print('OTP resent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "A 6-digit OTP has been sent to your registered email/phone.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _verifyOtp, // Call the updated _verifyOtp method
                child: Text("Verify OTP"),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: _isResendDisabled ? null : _resendOtp,
                child: Text(
                  _isResendDisabled
                      ? "Resend OTP in $_remainingTime seconds"
                      : "Resend OTP",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
