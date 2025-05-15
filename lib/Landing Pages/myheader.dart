// lib/widgets/app_header.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rideconnect/Authentication_Registration/login_page.dart';
import 'package:rideconnect/Authentication_Registration/passenger_signup_page.dart';
import 'package:rideconnect/Authentication_Registration/rider_signup_page.dart';
import 'package:rideconnect/Landing%20Pages/aboutus.dart';
import 'package:rideconnect/Landing%20Pages/contact.dart';
import 'package:rideconnect/Landing%20Pages/homepage.dart';
import 'package:rideconnect/Landing%20Pages/price.dart';
import 'package:rideconnect/Landing%20Pages/service_page.dart';

class AppHeader extends StatefulWidget {
  final String currentRoute;

  const AppHeader({super.key, required this.currentRoute});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  // ignore: unused_field
  final bool _showMobileMenu = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 768; // Threshold for mobile view
        final double logoWidth = isSmallScreen ? 60 : 100;
        final double logoHeight = isSmallScreen ? 25 : 40;

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 8 : 12,
            horizontal: isSmallScreen ? 16 : 24,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFCECEC),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/rideconnekt_logo.png",
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.contain,
              ),
              if (isSmallScreen)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu),
                  onSelected: (String route) {
                    _navigateToRoute(context, route);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: '/',
                      child: Text('Home'),
                    ),
                    const PopupMenuItem<String>(
                      value: '/services',
                      child: Text('Services'),
                    ),
                    const PopupMenuItem<String>(
                      value: '/pricing',
                      child: Text('Pricing'),
                    ),
                    const PopupMenuItem<String>(
                      value: '/about',
                      child: Text('About'),
                    ),
                    const PopupMenuItem<String>(
                      value: '/contacts',
                      child: Text('Contacts'),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: '/login',
                      child: const Text('Login'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem<String>(
                      value: '/signup',
                      child: const Text('Sign up'),
                      onTap: () => _navigateToSignup(context),
                          ),]
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(context, 'Home', '/', 16, 16),
                    _buildNavItem(context, 'Services', '/services', 16, 16),
                    _buildNavItem(context, 'Pricing', '/pricing', 16, 16),
                    _buildNavItem(context, 'About', '/about', 16, 16),
                    _buildNavItem(context, 'Contacts', '/contacts', 16, 16),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: ElevatedButton(
                        onPressed: _toggleDropdown,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          minimumSize: const Size(90, 35),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    String routeName,
    double fontSize,
    double padding,
  ) {
    final isActive = widget.currentRoute == routeName;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: InkWell(
        onTap: () => _navigateToRoute(context, routeName),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.blue : Colors.black,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 20,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) {
          return Positioned(
            left: offset.dx + size.width - 150,
            top: offset.dy + size.height + 5,
            width: 150,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 1),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: const Text('Driver'),
                      onTap: () {
                        _navigateToRiderSignup();
                        _toggleDropdown();
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Passenger'),
                      onTap: () {
                        _navigateToPassengerSignup();
                        _toggleDropdown();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToPassengerSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PassengerSignupPage()),
    );
  }

  void _navigateToRiderSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RiderSignupPage()),
    );
  }

  void _navigateToRoute(BuildContext context, String routeName) {
    if (widget.currentRoute == routeName) return;

    switch (routeName) {
      case '/':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
        break;
      case '/services':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ServicePage()),
        );
        break;
      case '/pricing':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PricingPage()),
        );
        break;
      case '/about':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
        break;
      case '/contacts':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactPage()),
        );
        break;
      case '/login':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        break;
      // '/signup' will be handled by the "Sign up" button's dropdown
    }
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
    _overlayEntry?.remove();
    super.dispose();
  }
}