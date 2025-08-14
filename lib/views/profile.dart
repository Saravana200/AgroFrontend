import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kang/repos/providers.dart';
import 'package:kang/repos/repository.dart';
import 'package:kang/router.dart';
import 'package:kang/services/api_service.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();

  // Logout function
  Future<void> logout() async {
    try {
      // Clear all stored data (access token, email, name, phone)
      await storage.deleteAll();
      await ref.refresh(dioProvider.future);

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
    ref.refresh(userServiceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final call = ref.watch(userServiceProvider);
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
        body: call.when(
          data: (data) => Container(
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
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/300?img=12', // Randomly generated human avatar
                      ),
                    ),
                  ),
              SizedBox(height: 20),
              Text(
                    data,
                    style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
          ),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to load user data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(newsServiceProvider.future),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading user data...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ));
  }
}
