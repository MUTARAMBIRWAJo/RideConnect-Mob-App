// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideconnect/Dashboards/rider_dashboard.dart';// Import the signup screen
import 'package:path/path.dart';
import 'package:rideconnect/Authentication_Registration/passenger_signup_page.dart';
import 'package:rideconnect/Authentication_Registration/rider_signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'rider@rideconnect.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _rememberMe = false;
  bool _showError = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _showError = false;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (credential.user != null) {
        print('User signed in: ${credential.user!.uid}');
        // Navigate to the Rider Dashboard upon successful login
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => const RiderDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showError = true;
      });
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Optionally show a more specific error message
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // Optionally show a more specific error message
      } else if (e.code == 'user-disabled') {
        print('The user account has been disabled.');
        // Optionally show a more specific error message
      }
      print('Firebase Auth Error: ${e.message}');
      // Optionally show a generic error message to the user
    } catch (e) {
      setState(() {
        _showError = true;
      });
      print('Generic Error: $e');
      // Optionally show a generic error message to the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to RideConnect'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error message
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Invalid email or password',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Email field
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Password field
            const Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                suffixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),

            // Reset to Demo Account
            TextButton(
              onPressed: () {
                setState(() {
                  _emailController.text = 'rider@rideconnect.com';
                  _passwordController.text = 'password123';
                  _showError = false;
                });
              },
              child: const Text('Reset to Demo Account'),
            ),
            const Divider(height: 40),

            // Remember Me and Quick Login (Quick Login now uses Firebase)
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Remember Me'),
                const Spacer(),
                TextButton(
                  onPressed: _login,
                  child: const Text('Login'), // Changed "Quick Login" to "Login"
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Login Button (Now uses Firebase)
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Log In'),
            ),
            const SizedBox(height: 20),

            // Sign Up Button (Navigates to a Sign Up Screen)
            TextButton(
              onPressed: () {
                _navigateToSignup(context);
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
            const SizedBox(height: 20),

            // Or divider
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),

            // Social login buttons (You'll need to implement these separately)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () {},
              icon: Image.asset(
                'assets/images/google_logo.png',
                height: 24,
                width: 24,
              ),
              label: const Text('Log in with google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () {},
              icon: Image.asset(
                'assets/images/apple_logo.png',
                height: 24,
                width: 24,
              ),
              label: const Text('Log in with apple'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 30),

            // Demo credentials
            const Column(
              children: [
                Text(
                  'Demo Account Credentials:',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 4),
                Text('Email: rider@rideconnect.com'),
                Text('Password: password123'),
              ],
            ),
          ],
        ),
      ),
    );
  }
void _navigateToSignup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.drive_eta),
              title: const Text('Sign up as Driver'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiderSignupPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Sign up as Passenger'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PassengerSignupPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}