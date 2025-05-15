// passenger_signup_page.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideconnect/Authentication_Registration/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_validator/form_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:path/path.dart' as path;
import 'package:rideconnect/Dashboards/rider_dashboard.dart'; // Import path for filename extraction

// Ensure Firebase is initialized

class PassengerSignupPage extends StatefulWidget {
  const PassengerSignupPage({super.key});

  @override
  State<PassengerSignupPage> createState() => _PassengerSignupPageState();
}

class _PassengerSignupPageState extends State<PassengerSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Common fields
  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  bool _termsAccepted = false;
  bool _obscurePassword = true;
  File? _profileImage;

  // Define validators using form_validator
  final _fullNameValidator = ValidationBuilder().required().maxLength(50).build();
  final _emailValidator = ValidationBuilder().required().email().build();
  final _phoneNumberValidator = ValidationBuilder()
      .required()
      .minLength(10)
      .maxLength(10)
      .regExp(RegExp(r'^[0-9]+$'), 'Must contain only digits')
      .build();
  final _passwordValidator = ValidationBuilder()
      .required()
      .minLength(8)
      .regExp(
          RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
          'Password must contain uppercase, lowercase, number, and symbol')
      .build();

  Future<void> _pickImage({
    required BuildContext context,
    required ImageSource source,
    bool isProfile = false,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (isProfile) {
            _profileImage = File(image.path);
          }
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
      }
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      _formKey.currentState!.save();
      try {
        // 1. Create user in Firebase
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // User registration successful in Firebase
        final String? firebaseUid = userCredential.user?.uid;
        if (firebaseUid != null) {
          debugPrint('Firebase user created: $firebaseUid');

          // 2. Send additional user data to Laravel backend
          final bool laravelSuccess = await _sendUserDataToLaravel(
            firebaseUid,
            _fullName,
            _email,
            _phoneNumber,
            _profileImage,
          );
          if (laravelSuccess) {
            _showRegistrationSuccessDialog(context);
          } else {
            // If Laravel registration fails, you might want to delete the Firebase user
            await userCredential.user?.delete();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration failed on the server.')),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to get Firebase user UID.')),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registration failed';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else {
          errorMessage = e.message ?? errorMessage;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms & conditions')),
      );
    }
  }

  // Helper function to show a success dialog
  void _showRegistrationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Registration Successful"),
          content: const Text("Your registration was successful."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiderDashboard(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Function to send user data to Laravel backend
  Future<bool> _sendUserDataToLaravel(String uid, String fullName,String email, String phoneNumber,
      File? profileImage) async {
    //  const String apiUrl =
    //    'http://your_laravel_api_url/api/passenger/register'; // Replace with your Laravel API endpoint
    const String apiUrl =
        'http://10.0.2.2:8000/api/passenger/register'; // For local testing with emulator

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['uid'] = uid;
      request.fields['full_name'] = fullName;
      request.fields['email'] = email;
      request.fields['phone_number'] = phoneNumber;
      request.fields['terms_accepted'] = '1'; // Assuming terms are accepted here

      if (profileImage != null) {
        var stream = http.ByteStream(profileImage.openRead());
        var length = await profileImage.length();
        var multipartFile = http.MultipartFile(
          'profile_image', // This should match the Laravel backend's expected field name
          stream,
          length,
          filename: path.basename(profileImage.path),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString(); //get response

      if (response.statusCode == 201) {
        // Successful registration in Laravel
        debugPrint('User data sent to Laravel successfully. Response: $responseBody');
        return true; // Show success message
      } else {
        // Handle errors from Laravel backend
        debugPrint(
            'Failed to send user data to Laravel: ${response.statusCode}, Response: $responseBody');
        Map<String, dynamic> errorResponse =
            json.decode(responseBody); //decode the response
        String errorMessage =
            errorResponse['error'] ?? 'An unknown error occurred on server'; //get the error message.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server Error: $errorMessage')),
          );
        }
        return false;
      }
    } catch (e) {
      // Handle network errors or other exceptions
      debugPrint('Error sending data to Laravel: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to connect to server. Please check your internet connection.')),
        );
      }
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passenger Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.blue),
                        onPressed: () => _showImageSourceDialog(
                          context,
                          isProfile: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _fullName = value ?? '',
                validator: _fullNameValidator,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _email = value ?? '',
                validator: _emailValidator,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _phoneNumber = value ?? '',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _phoneNumberValidator,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                onSaved: (value) => _password = value ?? '',
                obscureText: _obscurePassword,
                validator: _passwordValidator,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) =>
                        setState(() => _termsAccepted = value ?? false),
                  ),
                  const Text('I agree to the Terms & Conditions'),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Already have an account? Login here'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('REGISTER'),
                ),
              ),
              _buildSocialLoginSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                _handleGoogleSignIn();
                // Implement Google login logic
              },
              icon: Image.asset('assets/google_logo.png', height: 20),
              label: const Text('Sign Up with google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // _handleAppleSignIn(); // Implement Apple login logic
              },
              icon: Image.asset('assets/apple_logo.png', height: 20),
              label: const Text('Log In with apple'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showImageSourceDialog(
    BuildContext context, {
    bool isProfile = false,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(
                  context: context,
                  source: ImageSource.camera,
                  isProfile: isProfile,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(
                  context: context,
                  source: ImageSource.gallery,
                  isProfile: isProfile,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final String? firebaseUid = userCredential.user?.uid;
      if (firebaseUid != null) {
        debugPrint('Google Sign-in successful! User UID: $firebaseUid');
        final bool laravelSuccess = await _sendSocialUserDataToLaravel(
          firebaseUid,
          'google',
          googleUser.displayName,
          googleUser.email,
          googleUser.photoUrl,
        );

if (laravelSuccess) {
          _showSocialSignInSuccessDialog(context, 'Google');
        } else {
          // Potentially sign out from Firebase if Laravel fails
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Social registration failed on the server.')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to get Firebase user UID.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Google: $e')),
        );
      }
    }
  }

void _showSocialSignInSuccessDialog(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$provider Sign-in Successful'),
          content: Text('You have successfully signed in with $provider.'),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const RiderDashboard(), // Or your home page
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _sendSocialUserDataToLaravel(String uid, String provider,
      String? displayName, String? email, String? photoUrl) async {
    const String apiUrl = 'http://10.0.2.2:8000/api/social/register';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['uid'] = uid;
      request.fields['provider'] = provider;
      request.fields['name'] = displayName ?? '';
      request.fields['email'] = email ?? '';
      if (photoUrl != null) {
        request.fields['photo_url'] = photoUrl;
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        debugPrint('Social user data sent successfully: $responseBody');
        return true;
      } else {
        debugPrint(
            'Failed to send social user data: ${response.statusCode}, Response: $responseBody');
        Map<String, dynamic> errorResponse = json.decode(responseBody);
        String errorMessage =
            errorResponse['error'] ?? 'Failed to register with $provider on the server.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error sending social user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to connect to server. Please check your internet connection.')),
        );
      }
      return false;
    }
  }
}