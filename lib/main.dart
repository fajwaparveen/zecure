// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'login.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//         fontFamily: 'Poppins',
//       ),
//       home: const MyHomePage(title: 'IP Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   final TextEditingController _textController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFF1A0033),
//                 Color(0xFF2D1B69),
//                 Color(0xFF000000),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Center(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Premium Icon or Logo Area
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.deepPurpleAccent, width: 2),
//                           ),
//                           child: const Icon(
//                             Icons.cloud_queue,
//                             size: 80,
//                             color: Colors.deepPurpleAccent,
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//
//                         const Text(
//                           "Connect to Your Server",
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 1.1,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           "Enter the IP address of your local server"
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 50),
//
//                         PremiumTextField(controller: _textController),
//
//                         const SizedBox(height: 40),
//
//                         // Premium Submit Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 60,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               _send_data();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepPurpleAccent,
//                               foregroundColor: Colors.white,
//                               elevation: 10,
//                               shadowColor: Colors.deepPurple.withOpacity(0.6),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: const Text(
//                               'Connect Now',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _send_data() async {
//     if (_textController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please enter an IP address"),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     sh.setString('url', 'http://${_textController.text}:8000/MyApp');
//     sh.setString('img_url', 'http://${_textController.text}:8000');
//
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         transitionDuration: const Duration(milliseconds: 600),
//         pageBuilder: (_, __, ___) => MyLoginPage(title: ''),
//         transitionsBuilder: (_, animation, __, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//       ),
//     );
//   }
// }
//
// // Custom Premium TextField Widget
// class PremiumTextField extends StatelessWidget {
//   final TextEditingController controller;
//
//   const PremiumTextField({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(color: Colors.white, fontSize: 18),
//       decoration: InputDecoration(
//         labelText: 'Server IP Address',
//         hintText: 'e.g., 192.168.1.100',
//         hintStyle: TextStyle(color: Colors.white38),
//         labelStyle: const TextStyle(color: Colors.deepPurpleAccent),
//         prefixIcon: const Icon(Icons.storage, color: Colors.deepPurpleAccent),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.1),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.deepPurpleAccent.withOpacity(0.5), width: 2),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 3),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF09818A), // Updated to #09818A
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const MyHomePage(title: 'IP Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A4B52), // Dark version of #09818A
                Color(0xFF1F98B8), // #1F98B8
                Color(0xFF000000),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Premium Icon or Logo Area
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF09818A), width: 2), // Updated to #09818A
                          ),
                          child: const Icon(
                            Icons.cloud_queue,
                            size: 80,
                            color: Color(0xFF09818A), // Updated to #09818A
                          ),
                        ),
                        const SizedBox(height: 40),

                        const Text(
                          "Connect to Your Server",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Enter the IP address of your local server",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFFFFFFFF).withOpacity(0.8), // Updated to #1F98B8 with opacity
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),

                        PremiumTextField(controller: _textController),

                        const SizedBox(height: 40),

                        // Premium Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              _send_data();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF09818A), // Updated to #09818A
                              foregroundColor: Colors.white,
                              elevation: 10,
                              shadowColor: const Color(0xFF09818A).withOpacity(0.6), // Updated to #09818A with opacity
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Connect Now',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _send_data() async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter an IP address"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString('url', 'http://${_textController.text}:8000/MyApp');
    sh.setString('img_url', 'http://${_textController.text}:8000');

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => MyLoginPage(title: ''),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

// Custom Premium TextField Widget
class PremiumTextField extends StatelessWidget {
  final TextEditingController controller;

  const PremiumTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Server IP Address',
        hintText: 'e.g., 192.168.1.100',
        hintStyle: TextStyle(color: Colors.white38),
        labelStyle: const TextStyle(color: Color(0xFF09818A)), // Updated to #09818A
        prefixIcon: const Icon(Icons.storage, color: Color(0xFF09818A)), // Updated to #09818A
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFF09818A).withOpacity(0.5), width: 2), // Updated to #09818A with opacity
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF09818A), width: 3), // Updated to #09818A
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }
}