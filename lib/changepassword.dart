// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'login.dart';
// void main(){
//   runApp(myapp());
// }
//
// class myapp extends StatelessWidget {
//   const myapp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home:changepassword(),);
//   }
// }
//
// class changepassword extends StatefulWidget {
//   const changepassword({super.key});
//
//   @override
//   State<changepassword> createState() => _changepasswordState();
// }
//
// class _changepasswordState extends State<changepassword> {
//
//   TextEditingController currentpasscon = new TextEditingController();
//   TextEditingController newpasscon = new TextEditingController();
//   TextEditingController confirmpasscon = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("changepassword"),backgroundColor: Colors.deepOrange),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Center(
//             child: Padding(padding: EdgeInsets.all(10),
//               child: Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//                 color: Colors.yellow[100],
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(children: [
//                     Text("singup"),
//                     TextFormField(controller: currentpasscon,obscureText:true,decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),label: Text('Current Password')),),
//                     SizedBox(height: 30,),
//                     TextFormField(controller: newpasscon,obscureText:true,decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),label: Text('New Password')),),
//                     SizedBox(height: 30,),
//                     TextFormField(controller: confirmpasscon, obscureText:true,decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),label: Text('Confirm Password')),),
//                     SizedBox(height: 30,),
//                     ElevatedButton(onPressed: (){
//                       _sendData();
//                     }, child: Text("Submit"))
//
//                   ],),
//                 ),
//               ),),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//   Future<void> _sendData() async {
//     String currentpass = currentpasscon.text;
//     String newpass = newpasscon.text;
//     String confirmpass = confirmpasscon.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//
//     if (url == null) {
//       Fluttertoast.showToast(msg: "Server URL not found.");
//       return;
//     }
//
//     final uri = Uri.parse('$url/user_changepassword_post/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['currentpassword'] = currentpass;
//     request.fields['newpassword'] = newpass;
//     request.fields['confirmpassword'] = confirmpass;
//     request.fields['lid'] = lid!;
//
//
//     try {
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: "Submitted successfully.");
//
//         Navigator.push(
//           context,
//
//           MaterialPageRoute(builder: (context) => MyLoginPage(title: '',)),
//         );
//
//       } else {
//         Fluttertoast.showToast(msg: "Submission failed.");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//
//
//
// }



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

void main() {
  runApp(myapp());
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal, // Changed to match #09818A
      ),
      home: const changepassword(),
    );
  }
}

class changepassword extends StatefulWidget {
  const changepassword({super.key});

  @override
  State<changepassword> createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  TextEditingController currentpasscon = TextEditingController();
  TextEditingController newpasscon = TextEditingController();
  TextEditingController confirmpasscon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF09818A), // Changed to #09818A
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF09818A).withOpacity(0.1),
              const Color(0xFF1F98B8).withOpacity(0.1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Header
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF09818A), Color(0xFF1F98B8)],
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF09818A), // Changed to #09818A
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Current Password
                      TextFormField(
                        controller: currentpasscon,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A), width: 2),
                          ),
                          labelText: 'Current Password',
                          labelStyle: const TextStyle(color: Color(0xFF09818A)),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF09818A)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // New Password
                      TextFormField(
                        controller: newpasscon,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A), width: 2),
                          ),
                          labelText: 'New Password',
                          labelStyle: const TextStyle(color: Color(0xFF09818A)),
                          prefixIcon: const Icon(Icons.lock_open, color: Color(0xFF09818A)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      TextFormField(
                        controller: confirmpasscon,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF09818A), width: 2),
                          ),
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Color(0xFF09818A)),
                          prefixIcon: const Icon(Icons.lock_clock, color: Color(0xFF09818A)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _sendData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09818A), // Changed to #09818A
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendData() async {
    String currentpass = currentpasscon.text;
    String newpass = newpasscon.text;
    String confirmpass = confirmpasscon.text;

    // Validation
    if (currentpass.isEmpty || newpass.isEmpty || confirmpass.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required");
      return;
    }

    if (newpass != confirmpass) {
      Fluttertoast.showToast(msg: "New password and confirm password do not match");
      return;
    }

    if (newpass.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/user_changepassword_post/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['currentpassword'] = currentpass;
    request.fields['newpassword'] = newpass;
    request.fields['confirmpassword'] = confirmpass;
    request.fields['lid'] = lid!;

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Password changed successfully.");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyLoginPage(
              title: '',
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "Submission failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
