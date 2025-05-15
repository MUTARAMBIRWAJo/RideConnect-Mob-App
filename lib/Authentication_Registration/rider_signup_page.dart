// rider_signup_page.dart
// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_element

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideconnect/Authentication_Registration/login_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:form_validator/form_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;  // For getting file name
import 'package:mime/mime.dart'; //for content type// Import form_validator package

class RiderSignupPage extends StatefulWidget {
  const RiderSignupPage({super.key});

  @override
  State<RiderSignupPage> createState() => _RiderSignupPageState();
}

class _RiderSignupPageState extends State<RiderSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _insuranceDateController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedDate;

  // Common fields
  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  bool _termsAccepted = false;
  bool _obscurePassword = true;
  File? _profileImage;

  // Driver-specific fields
  String _vehicleModel = '';
  String _manufactureYear = '';
  String _licensePlate = '';
  String _vehicleType = '';
  String _insuranceProvider = '';
  File? _vehiclePhoto;
  File? _driverLicense;

  // Define validators using form_validator
  final _fullNameValidator = ValidationBuilder().required().maxLength(50).build();
  final _emailValidator = ValidationBuilder().required().email().build();
  final _phoneNumberValidator =
      ValidationBuilder().required().minLength(10).maxLength(10).regExp(RegExp(r'^\d+$'), 'Must be a valid number').build();
  final _passwordValidator = ValidationBuilder()
      .required()
      .minLength(8)
      .regExp(
          RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
          'Password must contain uppercase, lowercase, number, and symbol')
      .build();
  final _vehicleModelValidator = ValidationBuilder().required().maxLength(50).build();
  final _manufactureYearValidator =
      ValidationBuilder()
          .required()
          .regExp(RegExp(r'^\d+$'), 'Must be a valid number')
          .minLength(4)
          .maxLength(4)
          .build();
  final _licensePlateValidator = ValidationBuilder().required().maxLength(20).build();
  final _vehicleTypeValidator = ValidationBuilder().required().maxLength(50).build();
  final _insuranceProviderValidator =
      ValidationBuilder().required().maxLength(50).build();
    final _insuranceDateValidator = ValidationBuilder().required().build();

  @override
  void dispose() {
    _insuranceDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _insuranceDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickImage({
    required BuildContext context,
    required ImageSource source,
    bool isProfile = false,
    bool isVehicle = false,
    bool isLicense = false,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (isProfile) {
            _profileImage = File(image.path);
          } else if (isVehicle) {
            _vehiclePhoto = File(image.path);
          } else if (isLicense) {
            _driverLicense = File(image.path);
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

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'rideconnekt.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userType TEXT,
            fullName TEXT,
            email TEXT UNIQUE,
            phoneNumber TEXT,
            password TEXT,
            profileImagePath TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE drivers (
            id INTEGER PRIMARY KEY,
            vehicleModel TEXT,
            manufactureYear TEXT,
            licensePlate TEXT,
            vehicleType TEXT,
            insuranceProvider TEXT,
            insuranceExpiry TEXT,
            vehiclePhotoPath TEXT,
            driverLicensePath TEXT,
            FOREIGN KEY (id) REFERENCES users (id)
          )
        ''');
      },
    );
  }

Future<void> _saveUserToDatabase(BuildContext context) async {
    //const url = 'http://your_laravel_api_url/api/register'; // Replace with your Laravel API URL
    var url = Uri.parse('http://your_laravel_api_url/api/register'); //convert to Uri

    try {
        // 1.  Prepare the request
        var request = http.MultipartRequest('POST', url);

        // 2. Add the form fields
        request.fields['name'] = _fullName;
        request.fields['email'] = _email;
        request.fields['phoneNumber'] = _phoneNumber;
        request.fields['password'] = _password;
        request.fields['vehicleModel'] = _vehicleModel;
        request.fields['manufactureYear'] = _manufactureYear;
        request.fields['licensePlate'] = _licensePlate;
        request.fields['vehicleType'] = _vehicleType;
        request.fields['insuranceProvider'] = _insuranceProvider;
        request.fields['insuranceExpiry'] = _insuranceDateController.text; // Send the date string

        // 3.  Attach the images (if selected)
if (_profileImage != null) {
    var stream = http.ByteStream(_profileImage!.openRead());
    var length = await _profileImage!.length();
    var mimeType = lookupMimeType(_profileImage!.path); // Use lookupMimeType
    var multipartFile = http.MultipartFile(
        'profileImage',
        stream,
        length,
        filename: path.basename(_profileImage!.path),
        contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('image', 'jpeg'), //use MediaType.parse
    );
    request.files.add(multipartFile);
}
if (_vehiclePhoto != null) {
    var stream = http.ByteStream(_vehiclePhoto!.openRead());
    var length = await _vehiclePhoto!.length();
    var mimeType = lookupMimeType(_vehiclePhoto!.path);
    var multipartFile = http.MultipartFile('vehiclePhoto', stream, length,
        filename: path.basename(_vehiclePhoto!.path),
        contentType:  mimeType != null ? MediaType.parse(mimeType) : MediaType('image', 'jpeg'));
    request.files.add(multipartFile);
}
if (_driverLicense != null) {
    var stream = http.ByteStream(_driverLicense!.openRead());
    var length = await _driverLicense!.length();
    var mimeType = lookupMimeType(_driverLicense!.path);
    var multipartFile = http.MultipartFile('driverLicense', stream, length,
        filename: path.basename(_driverLicense!.path),
        contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('image', 'jpeg'));
    request.files.add(multipartFile);
}

        // 4. Send the request
        var response = await request.send();

        // 5.  Handle the response
        if (response.statusCode == 201) {
            // Registration successful
            var responseBody = await response.stream.bytesToString();
            var decodedResponse = jsonDecode(responseBody);

            //if (kDebugMode) {
            //  print("Response Data: $decodedResponse");
            //}

            if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration successful!')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ), // Navigate to LoginPage
                );
            }


        } else {
            // Registration failed
            var responseBody = await response.stream.bytesToString();
            var decodedResponse = jsonDecode(responseBody);
            //if (kDebugMode) {
            //  print("Response Data: $decodedResponse");
            //}
            if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed: ${decodedResponse['error'] ?? 'Unknown error'}')),
                );
            }
        }
    } catch (e) {
        // Error occurred during the request
        //if (kDebugMode) {
        //  print("Error during registration: $e");
        //}
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to connect to server: $e')),
            );
        }
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      _formKey.currentState!.save();
      _saveUserToDatabase(context);
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms & conditions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rider Registration')),
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
                    icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                onSaved: (value) => _password = value ?? '',
                obscureText: _obscurePassword,
                validator: _passwordValidator,
              ),
              _buildDriverFields(context),
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

  Widget _buildDriverFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Vehicle Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Vehicle Model',
            prefixIcon: Icon(Icons.directions_car),
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => _vehicleModel = value ?? '',
          validator: _vehicleModelValidator,
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Year of Manufacture',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => _manufactureYear = value ?? '',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: _manufactureYearValidator,
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'License Plate Number',
            prefixIcon: Icon(Icons.confirmation_number),
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => _licensePlate = value ?? '',
          validator: _licensePlateValidator,
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Vehicle Type',
            prefixIcon: Icon(Icons.category),
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => _vehicleType = value ?? '',
          validator: _vehicleTypeValidator,
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Insurance Provider',
            prefixIcon: Icon(Icons.security),
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => _insuranceProvider = value ?? '',
          validator: _insuranceProviderValidator,
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _insuranceDateController,
          decoration: InputDecoration(
            labelText: 'Insurance Expiry Date',
            prefixIcon: const Icon(Icons.date_range),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          readOnly: true,
          validator: _insuranceDateValidator,
        ),
        _buildFileUploadSection(
          title: 'Upload Vehicle Photo',
          file: _vehiclePhoto,
          onPressed: () => _showImageSourceDialog(context, isVehicle: true),
        ),
        _buildFileUploadSection(
          title: "Upload Driver's License",
          file: _driverLicense,
          onPressed: () => _showImageSourceDialog(context, isLicense: true),
        ),
      ],
    );
  }



  Widget _buildFileUploadSection({
    required String title,
    File? file,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(title),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.upload),
          label: const Text('Browse...'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.blue),
          ),
        ),
        Text(
          file != null ? file.path.split('/').last : 'No file selected',
          style: TextStyle(color: file != null ? Colors.black : Colors.grey),
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.file(file, height: 100, width: 100, fit: BoxFit.cover),
          ),
      ],
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
                _handleAppleSignIn(); // Implement Apple login logic
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
    bool isVehicle = false,
    bool isLicense = false,
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
                  isVehicle: isVehicle,
                  isLicense: isLicense,
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
                  isVehicle: isVehicle,
                  isLicense: isLicense,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

Future<void> _handleGoogleSignIn() async {
  try {
    // Trigger the Google Sign In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    if (googleUser == null) {
      // User canceled the sign-in
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential = 
        await FirebaseAuth.instance.signInWithCredential(credential);

    // If sign-in was successful, you can now get the user details
    final User? user = userCredential.user;
    
    if (user != null) {
      // Update the form fields with the user's Google account info
      setState(() {
        _fullName = user.displayName ?? '';
        _email = user.email ?? '';
        // You might want to handle phone number separately as Google doesn't provide it
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Google sign-in successful!')),
        );
      }
    }
  } catch (e) {
    debugPrint('Google sign-in error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
      );
    }
  }
}

Future<void> _handleAppleSignIn() async {
  try {
    // For Apple Sign-In, we need to handle different platforms
    if (Platform.isIOS || Platform.isMacOS) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuth credential from the Apple credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // If sign-in was successful, you can now get the user details
      final User? user = userCredential.user;
      
      if (user != null) {
        // Apple might not return the full name after the first login
        // So we use the data from the credential if available
        final fullName = credential.givenName != null && credential.familyName != null
            ? '${credential.givenName} ${credential.familyName}'
            : user.displayName ?? '';
            
        setState(() {
          _fullName = fullName;
          _email = user.email ?? '';
        });

        if (mounted) {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text('Apple sign-in successful!')),
          );
        }
      }
    } else {
      // Android or other platforms
      final UserCredential userCredential = 
          await FirebaseAuth.instance.signInWithProvider(AppleAuthProvider());
          
      final User? user = userCredential.user;
      
      if (user != null) {
        setState(() {
          _fullName = user.displayName ?? '';
          _email = user.email ?? '';
        });

        if (mounted) {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text('Apple sign-in successful!')),
          );
        }
      }
    }
  } catch (e) {
    debugPrint('Apple sign-in error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Apple sign-in failed: ${e.toString()}')),
      );
    }
  }
}
}


