// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animate_do/animate_do.dart';
// import 'editprofile.dart';
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
//       title: 'Profile Premium',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const ViewProfile(title: 'My Profile'),
//     );
//   }
// }
//
// class ViewProfile extends StatefulWidget {
//   const ViewProfile({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewProfile> createState() => _ViewProfileState();
// }
//
// class _ViewProfileState extends State<ViewProfile> {
//   String name = "";
//   String emailid = "";
//   String phonenumber = "";
//   String place = "";
//   String post = "";
//   String pincode = "";
//   String photo = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _sendData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//               child: FadeInUp(
//                 duration: const Duration(milliseconds: 800),
//                 child: Card(
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   color: Colors.white.withOpacity(0.95),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Profile Image
//                         CircleAvatar(
//                           radius: 80,
//                           backgroundColor: Colors.grey.shade200,
//                           child: ClipOval(
//                             child: photo.isNotEmpty
//                                 ? Image.network(
//                               photo,
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                               const Icon(Icons.error, size: 50),
//                             )
//                                 : const Icon(Icons.person, size: 80),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // Name
//                         Text(
//                           name.isNotEmpty ? name : 'Loading...',
//                           style: GoogleFonts.poppins(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 10),
//                         // Email
//                         _buildProfileField(Icons.email, emailid, 'Email'),
//                         // Phone
//                         _buildProfileField(Icons.phone, phonenumber, 'Phone'),
//                         // Place
//                         _buildProfileField(Icons.location_on, place, 'Place'),
//                         // Post
//                         _buildProfileField(Icons.local_post_office, post, 'Post'),
//                         // Pincode
//                         _buildProfileField(Icons.pin_drop, pincode, 'Pincode'),
//                         const SizedBox(height: 20),
//                         // Edit Button
//                         ZoomIn(
//                           duration: const Duration(milliseconds: 1000),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const EditProfile(),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 40,
//                                 vertical: 15,
//                               ),
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ).copyWith(
//                               backgroundColor: WidgetStateProperty.all(Colors.transparent),
//                               elevation: WidgetStateProperty.all(0),
//                             ),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [Color(0xFF8E24AA), Color(0xFFCE93D8)],
//                                 ),
//                                 borderRadius: BorderRadius.circular(30),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 10,
//                                     offset: Offset(0, 5),
//                                   ),
//                                 ],
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               child: Text(
//                                 'Edit Profile',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white,
//                                 ),
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
//   Widget _buildProfileField(IconData icon, String value, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.deepPurple, size: 24),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               value.isNotEmpty ? value : 'N/A',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _sendData() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//     String imgUrl = sh.getString('img_url') ?? '';
//
//     final urls = Uri.parse('$url/user_view_profile/');
//     try {
//       final response = await http.post(urls, body: {'lid': lid});
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         String status = data['status'];
//         if (status == 'ok') {
//           setState(() {
//             name = data['name']?.toString() ?? '';
//             emailid = data['emailid']?.toString() ?? '';
//             phonenumber = data['phonenumber']?.toString() ?? '';
//             place = data['place']?.toString() ?? '';
//             post = data['post']?.toString() ?? '';
//             pincode = data['pincode']?.toString() ?? '';
//             photo = '$imgUrl${data['photo']?.toString() ?? ''}';
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'Data not found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
// }








import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'editprofile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Premium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF09818A)), // Changed to #09818A
        useMaterial3: true,
      ),
      home: const ViewProfile(title: 'My Profile'),
    );
  }
}

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, required this.title});

  final String title;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String name = "";
  String emailid = "";
  String phonenumber = "";
  String place = "";
  String post = "";
  String pincode = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    _sendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF09818A), Color(0xFF1F98B8)], // Changed to #09818A and #1F98B8
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: photo.isNotEmpty
                                ? Image.network(
                              photo,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 50),
                            )
                                : const Icon(Icons.person, size: 80),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Name
                        Text(
                          name.isNotEmpty ? name : 'Loading...',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Email
                        _buildProfileField(Icons.email, emailid, 'Email'),
                        // Phone
                        _buildProfileField(Icons.phone, phonenumber, 'Phone'),
                        // Place
                        _buildProfileField(Icons.location_on, place, 'Place'),
                        // Post
                        _buildProfileField(Icons.local_post_office, post, 'Post'),
                        // Pincode
                        _buildProfileField(Icons.pin_drop, pincode, 'Pincode'),
                        const SizedBox(height: 20),
                        // Edit Button
                        ZoomIn(
                          duration: const Duration(milliseconds: 1000),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfile(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ).copyWith(
                              backgroundColor: WidgetStateProperty.all(Colors.transparent),
                              elevation: WidgetStateProperty.all(0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF09818A), Color(0xFF1F98B8)], // Changed to #09818A and #1F98B8
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
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

  Widget _buildProfileField(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF09818A), size: 24), // Changed to #09818A
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';
    String imgUrl = sh.getString('img_url') ?? '';

    final urls = Uri.parse('$url/user_view_profile/');
    try {
      final response = await http.post(urls, body: {'lid': lid});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String status = data['status'];
        if (status == 'ok') {
          setState(() {
            name = data['name']?.toString() ?? '';
            emailid = data['emailid']?.toString() ?? '';
            phonenumber = data['phonenumber']?.toString() ?? '';
            place = data['place']?.toString() ?? '';
            post = data['post']?.toString() ?? '';
            pincode = data['pincode']?.toString() ?? '';
            photo = '$imgUrl${data['photo']?.toString() ?? ''}';
          });
        } else {
          Fluttertoast.showToast(msg: 'Data not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}