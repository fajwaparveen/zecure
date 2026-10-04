// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intrusion_detection/hms/views/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'home.dart';
// import 'hms/views/home_screen.dart';
//
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
//       title: 'Submit Review',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
//         useMaterial3: true,
//       ),
//       home: const SendReviewPage(),
//     );
//   }
// }
//
// class SendReviewPage extends StatefulWidget {
//   const SendReviewPage({super.key});
//
//   @override
//   State<SendReviewPage> createState() => _SendReviewPageState();
// }
//
// class _SendReviewPageState extends State<SendReviewPage> {
//   final TextEditingController _reviewController = TextEditingController();
//   double _rating = 3.0; // Default rating
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _sendReview() async {
//     if (_rating < 1) {
//       Fluttertoast.showToast(msg: "Please provide a rating", backgroundColor: Colors.orange);
//       return;
//     }
//
//     if (_reviewController.text.trim().isEmpty) {
//       Fluttertoast.showToast(msg: "Please write a review", backgroundColor: Colors.orange);
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? url = prefs.getString('url');
//       String? lid = prefs.getString('lid');
//
//       if (url == null || lid == null) {
//         Fluttertoast.showToast(msg: "Session expired. Please login again.");
//         setState(() => _isLoading = false);
//         return;
//       }
//
//       var uri = Uri.parse('$url/user_sendreview/');
//       var request = http.MultipartRequest('POST', uri);
//
//       request.fields.addAll({
//         'rating': _rating.toStringAsFixed(1),
//         'review': _reviewController.text.trim(),
//         'lid': lid,
//       });
//
//       var response = await request.send().timeout(const Duration(seconds: 20));
//       var responseData = await response.stream.bytesToString();
//       var jsonResponse = jsonDecode(responseData);
//
//       if (response.statusCode == 200 && jsonResponse['status'] == 'ok') {
//         Fluttertoast.showToast(
//           msg: "Thank you! Review submitted successfully",
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             // transitionDuration(milliseconds: 600),
//             pageBuilder: (_, __, ___) => const HomeScreen(),
//             transitionsBuilder: (_, animation, __, child) {
//               return FadeTransition(opacity: animation, child: child);
//             },
//           ),
//         );
//         //
//
//         // Navigate to home
//         // Navigator.pushReplacement(
//         //   context,
//         //   PageRouteBuilder(
//         //     // transitionDuration(milliseconds: 600),
//         //     pageBuilder: (_, __, ___) => const  homepage(),
//         //     transitionsBuilder: (_, animation, __, child) {
//         //       return FadeTransition(opacity: animation, child: child);
//         //     },
//         //   ),
//         // );
//       } else {
//         Fluttertoast.showToast(
//           msg: jsonResponse['msg'] ?? "Failed to submit review",
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Network error: $e", backgroundColor: Colors.red);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text("Rate & Review", style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//
//               // Icon + Title
//               Icon(Icons.rate_review_outlined, size: 80, color: Colors.deepPurple[300]),
//               const SizedBox(height: 16),
//               const Text(
//                 "How was your experience?",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Your feedback helps us improve",
//                 style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Star Rating
//               const Text(
//                 "Rate Your Experience",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 16),
//               RatingBar.builder(
//                 initialRating: _rating,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 itemBuilder: (context, _) => const Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 glowColor: Colors.amber.withOpacity(0.3),
//                 unratedColor: Colors.grey[300],
//                 onRatingUpdate: (rating) {
//                   setState(() {
//                     _rating = rating;
//                   });
//                 },
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 _rating == 1 ? "Poor" :
//                 _rating == 2 ? "Fair" :
//                 _rating == 3 ? "Good" :
//                 _rating == 4 ? "Very Good" : "Excellent",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: _rating >= 4 ? Colors.green : _rating >= 3 ? Colors.blue : Colors.orange,
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Review Text Field
//               TextField(
//                 controller: _reviewController,
//                 maxLines: 5,
//                 textInputAction: TextInputAction.done,
//                 decoration: InputDecoration(
//                   labelText: "Write your review (optional but appreciated)",
//                   hintText: "Tell us what you liked or how we can improve...",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.all(16),
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _sendReview,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 4,
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                     "Submit Review",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intrusion_detection/hms/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'home.dart';
import 'hms/views/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submit Review',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF09818A), // Updated to #09818A
          primary: const Color(0xFF09818A), // Updated to #09818A
          secondary: const Color(0xFF1F98B8), // Updated to #1F98B8
        ),
        primaryColor: const Color(0xFF09818A), // Updated to #09818A
        hintColor: const Color(0xFF1F98B8), // Updated to #1F98B8
        useMaterial3: true,
      ),
      home: const SendReviewPage(),
    );
  }
}

class SendReviewPage extends StatefulWidget {
  const SendReviewPage({super.key});

  @override
  State<SendReviewPage> createState() => _SendReviewPageState();
}

class _SendReviewPageState extends State<SendReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0; // Default rating
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _sendReview() async {
    if (_rating < 1) {
      Fluttertoast.showToast(msg: "Please provide a rating", backgroundColor: Colors.orange);
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please write a review", backgroundColor: Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString('url');
      String? lid = prefs.getString('lid');

      if (url == null || lid == null) {
        Fluttertoast.showToast(msg: "Session expired. Please login again.");
        setState(() => _isLoading = false);
        return;
      }

      var uri = Uri.parse('$url/user_sendreview/');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'rating': _rating.toStringAsFixed(1),
        'review': _reviewController.text.trim(),
        'lid': lid,
      });

      var response = await request.send().timeout(const Duration(seconds: 20));
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200 && jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Thank you! Review submitted successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

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
        //

        // Navigate to home
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     // transitionDuration(milliseconds: 600),
        //     pageBuilder: (_, __, ___) => const  homepage(),
        //     transitionsBuilder: (_, animation, __, child) {
        //       return FadeTransition(opacity: animation, child: child);
        //     },
        //   ),
        // );
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? "Failed to submit review",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error: $e", backgroundColor: Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Rate & Review", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF09818A), // Updated to #09818A
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Icon + Title
              Icon(Icons.rate_review_outlined, size: 80, color: const Color(0xFF09818A).withOpacity(0.7)), // Updated to #09818A with opacity
              const SizedBox(height: 16),
              const Text(
                "How was your experience?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Your feedback helps us improve",
                style: TextStyle(fontSize: 16, color: const Color(0xFF1F98B8).withOpacity(0.7)), // Updated to #1F98B8 with opacity
              ),

              const SizedBox(height: 40),

              // Star Rating
              const Text(
                "Rate Your Experience",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                glowColor: Colors.amber.withOpacity(0.3),
                unratedColor: Colors.grey[300],
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 12),
              Text(
                _rating == 1 ? "Poor" :
                _rating == 2 ? "Fair" :
                _rating == 3 ? "Good" :
                _rating == 4 ? "Very Good" : "Excellent",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _rating >= 4 ? const Color(0xFF09818A) : _rating >= 3 ? const Color(0xFF1F98B8) : Colors.orange, // Updated colors
                ),
              ),

              const SizedBox(height: 40),

              // Review Text Field
              TextField(
                controller: _reviewController,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Write your review (optional but appreciated)",
                  hintText: "Tell us what you liked or how we can improve...",
                  labelStyle: const TextStyle(color: Color(0xFF09818A)), // Updated to #09818A
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF09818A), width: 2), // Updated to #09818A
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09818A), // Updated to #09818A
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Submit Review",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}