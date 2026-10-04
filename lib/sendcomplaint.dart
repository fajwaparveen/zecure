// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intrusion_detection/viewreply.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.9),
//         ),
//       ),
//       home: const SendComplaint(),
//     );
//   }
// }
//
// class SendComplaint extends StatefulWidget {
//   const SendComplaint({super.key});
//
//   @override
//   State<SendComplaint> createState() => _SendComplaintState();
// }
//
// class _SendComplaintState extends State<SendComplaint> {
//   final _complaintController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   File? _attachedFile;
//   bool _isLoading = false;
//   int _charCount = 0;
//   final int _maxChars = 500; // Max characters for complaint
//
//   @override
//   void initState() {
//     super.initState();
//     _complaintController.addListener(() {
//       setState(() {
//         _charCount = _complaintController.text.length;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _complaintController.dispose();
//     super.dispose();
//   }
//
//   // Show confirmation dialog before submission
//   Future<bool> _showConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Submission'),
//         content: const Text('Are you sure you want to submit this complaint?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     ) ??
//         false;
//   }
//
//   // Submit complaint data
//   Future<void> _sendData() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final confirmed = await _showConfirmationDialog();
//     if (!confirmed) return;
//
//     setState(() => _isLoading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final url = prefs.getString('url') ?? '';
//       final lid = prefs.getString('lid') ?? '';
//
//       if (url.isEmpty || lid.isEmpty) {
//         Fluttertoast.showToast(msg: 'Server configuration missing');
//         return;
//       }
//
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$url/user_sendcomplaint/'),
//       );
//       request.fields.addAll({
//         'complaint': _complaintController.text,
//         'lid': lid,
//       });
//
//       if (_attachedFile != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath('file', _attachedFile!.path),
//         );
//       }
//
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//       final data = jsonDecode(respStr);
//
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Complaint submitted successfully');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ViewReply(title: '')),
//         );
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to submit complaint');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Submit Complaint'),
//         centerTitle: true,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.deepOrange, Colors.orangeAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orange.shade100, Colors.red.shade100],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Complaint input
//                     TextFormField(
//                       controller: _complaintController,
//                       maxLines: 5,
//                       maxLength: _maxChars,
//                       decoration: InputDecoration(
//                         labelText: 'Your Complaint',
//                         hintText: 'Describe your issue here...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your complaint';
//                         }
//                         if (value.length < 10) {
//                           return 'Complaint must be at least 10 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Characters: $_charCount/$_maxChars',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     // File attachment
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             _attachedFile != null
//                                 ? 'Attached: ${_attachedFile!.path.split('/').last}'
//                                 : 'No file attached',
//                             style: TextStyle(
//                               color: _attachedFile != null
//                                   ? Colors.green
//                                   : Colors.grey,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Submit button
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _sendData,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Text(
//                           'Submit Complaint',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }








import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intrusion_detection/viewreply.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal, // Changed to match #09818A
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
      home: const SendComplaint(),
    );
  }
}

class SendComplaint extends StatefulWidget {
  const SendComplaint({super.key});

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  final _complaintController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _attachedFile;
  bool _isLoading = false;
  int _charCount = 0;
  final int _maxChars = 500; // Max characters for complaint

  @override
  void initState() {
    super.initState();
    _complaintController.addListener(() {
      setState(() {
        _charCount = _complaintController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  // Show confirmation dialog before submission
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit this complaint?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    ) ??
        false;
  }

  // Submit complaint data
  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString('url') ?? '';
      final lid = prefs.getString('lid') ?? '';

      if (url.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Server configuration missing');
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/user_sendcomplaint/'),
      );
      request.fields.addAll({
        'complaint': _complaintController.text,
        'lid': lid,
      });

      if (_attachedFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', _attachedFile!.path),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Complaint submitted successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewReply(title: '')),
        );
      } else {
        Fluttertoast.showToast(msg: 'Failed to submit complaint');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF09818A), Color(0xFF1F98B8)], // Changed to #09818A and #1F98B8
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF09818A).withOpacity(0.1), const Color(0xFF1F98B8).withOpacity(0.1)], // Changed to related colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Complaint input
                    TextFormField(
                      controller: _complaintController,
                      maxLines: 5,
                      maxLength: _maxChars,
                      decoration: InputDecoration(
                        labelText: 'Your Complaint',
                        hintText: 'Describe your issue here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your complaint';
                        }
                        if (value.length < 10) {
                          return 'Complaint must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Characters: $_charCount/$_maxChars',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // File attachment
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _attachedFile != null
                                ? 'Attached: ${_attachedFile!.path.split('/').last}'
                                : 'No file attached',
                            style: TextStyle(
                              color: _attachedFile != null
                                  ? const Color(0xFF09818A) // Changed to #09818A
                                  : Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09818A), // Changed to #09818A
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Submit Complaint',
                          style: TextStyle(fontSize: 16),
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
    );
  }
}