// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intrusion_detection/signup.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'forgotpassword.dart';
// import 'hms/views/home_screen.dart';
// import 'main.dart'; // For MyHomePage (back button)
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MyLoginPage(title: 'Login'),
//   ));
// }
//
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> with TickerProviderStateMixin {
//   final TextEditingController _usernametextController = TextEditingController();
//   final TextEditingController _passwordtextController = TextEditingController();
//
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   bool _isPasswordVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7)),
//     );
//
//     _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _usernametextController.dispose();
//     _passwordtextController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             transitionDuration: const Duration(milliseconds: 400),
//             pageBuilder: (_, __, ___) => const MyLoginPage(title: ''),
//             transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
//           ),
//         );
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFF),
//         body: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 28),
//             child: Column(
//               children: [
//                 const SizedBox(height: 80),
//
//                 // Logo & Title
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.deepPurple.shade50,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.deepPurple.shade200, width: 4),
//                         ),
//                         child: Icon(
//                           Icons.security_rounded,
//                           size: 70,
//                           color: Colors.deepPurple.shade800,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         "Welcome Back",
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A1A2E),
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Sign in to access your account",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 50),
//
//                 // Email Field
//                 _buildTextField(
//                   controller: _usernametextController,
//                   label: "Email Address",
//                   hint: "Enter your email",
//                   icon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Password Field
//                 _buildTextField(
//                   controller: _passwordtextController,
//                   label: "Password",
//                   hint: "Enter your password",
//                   icon: Icons.lock_outline,
//                   isPassword: true,
//                   isVisible: _isPasswordVisible,
//                   onToggle: () {
//                     setState(() => _isPasswordVisible = !_isPasswordVisible);
//                   },
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Forgot Password
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => forgot_password()),
//                       );
//
//                     },
//                     child: Text(
//                       "Forgot Password?",
//                       style: TextStyle(
//                         color: Colors.deepPurple.shade700,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // Login Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 56,
//                   child: ElevatedButton(
//                     onPressed: _send_data,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple.shade600,
//                       foregroundColor: Colors.white,
//                       elevation: 8,
//                       shadowColor: Colors.deepPurple.withOpacity(0.4),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: const Text(
//                       "Sign In",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // Register Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account? ",
//                       style: TextStyle(color: Colors.grey.shade700),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MyAddUserPage()),
//                         );
//                         // Navigate to signup if you have it
//                       },
//                       child: Text(
//                         "Register Now",
//                         style: TextStyle(
//                           color: Colors.deepPurple.shade700,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     bool isPassword = false,
//     bool isVisible = false,
//     VoidCallback? onToggle,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: isPassword && !isVisible,
//           keyboardType: keyboardType,
//           style: const TextStyle(fontSize: 16,color: Colors.black),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(color: Colors.grey.shade400),
//             prefixIcon: Icon(icon, color: Colors.deepPurple.shade400),
//             suffixIcon: isPassword
//                 ? IconButton(
//               icon: Icon(
//                 isVisible ? Icons.visibility : Icons.visibility_off,
//                 color: Colors.grey.shade600,
//               ),
//               onPressed: onToggle,
//             )
//                 : null,
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _send_data() async {
//     String uname = _usernametextController.text.trim();
//     String password = _passwordtextController.text;
//
//     if (uname.isEmpty || password.isEmpty) {
//       Fluttertoast.showToast(
//         msg: "Please fill all fields",
//         backgroundColor: Colors.red.shade600,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? baseUrl = sh.getString('url');
//
//     if (baseUrl == null) {
//       Fluttertoast.showToast(msg: "Server URL not configured");
//       return;
//     }
//
//     final urls = Uri.parse('$baseUrl/user_login/');
//
//     try {
//       final response = await http.post(urls, body: {
//         'username': uname,
//         'password': password,
//       });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           String lid = data['lid'].toString();
//           await sh.setString("lid", lid);
//
//           if (!mounted) return;
//           Navigator.pushReplacement(
//             context,
//             PageRouteBuilder(
//               // transitionDuration(milliseconds: 600),
//               pageBuilder: (_, __, ___) => const HomeScreen(),
//               transitionsBuilder: (_, animation, __, child) {
//                 return FadeTransition(opacity: animation, child: child);
//               },
//             ),
//           );
//         } else {
//           Fluttertoast.showToast(msg: "Invalid credentials");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Connection failed: Check server IP");
//     }
//   }
// }






import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intrusion_detection/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'forgotpassword.dart';
import 'hms/views/home_screen.dart';
import 'main.dart'; // For MyHomePage (back button)

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLoginPage(title: 'Login'),
  ));
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernametextController = TextEditingController();
  final TextEditingController _passwordtextController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernametextController.dispose();
    _passwordtextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => const MyLoginPage(title: ''),
            transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE0F2F5), // Light version of #09818A
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // Logo & Title
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F9), // Light version of #1F98B8
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF09818A), width: 4), // #09818A
                        ),
                        child: Icon(
                          Icons.security_rounded,
                          size: 70,
                          color: const Color(0xFF09818A), // #09818A
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign in to access your account",
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF1F98B8).withOpacity(0.7), // #1F98B8 with opacity
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Email Field
                _buildTextField(
                  controller: _usernametextController,
                  label: "Email Address",
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // Password Field
                _buildTextField(
                  controller: _passwordtextController,
                  label: "Password",
                  hint: "Enter your password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  onToggle: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                ),

                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => forgot_password()),
                      );

                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: const Color(0xFF1F98B8), // #1F98B8
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _send_data,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF09818A), // #09818A
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color(0xFF09818A).withOpacity(0.4), // #09818A with opacity
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: const Color(0xFF1F98B8).withOpacity(0.7)), // #1F98B8 with opacity
                    ),
                    GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAddUserPage()),
                        );
                        // Navigate to signup if you have it
                      },
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: const Color(0xFF09818A), // #09818A
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !isVisible,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16,color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: const Color(0xFF09818A)), // #09818A
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade600,
              ),
              onPressed: onToggle,
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: const Color(0xFF09818A), width: 2), // #09818A
            ),
          ),
        ),
      ],
    );
  }

  void _send_data() async {
    String uname = _usernametextController.text.trim();
    String password = _passwordtextController.text;

    if (uname.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
      );
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? baseUrl = sh.getString('url');

    if (baseUrl == null) {
      Fluttertoast.showToast(msg: "Server URL not configured");
      return;
    }

    final urls = Uri.parse('$baseUrl/user_login/');

    try {
      final response = await http.post(urls, body: {
        'username': uname,
        'password': password,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          String lid = data['lid'].toString();
          await sh.setString("lid", lid);

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              // transitionDuration(milliseconds: 600),
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Invalid credentials");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Connection failed: Check server IP");
    }
  }
}