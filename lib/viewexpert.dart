// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
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
//       title: 'Expert Viewer',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         cardTheme: CardTheme(
//           elevation: 8,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//       home: const ViewExpert(title: 'View Experts'),
//     );
//   }
// }
//
// class ViewExpert extends StatefulWidget {
//   const ViewExpert({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewExpert> createState() => _ViewExpertState();
// }
//
// class _ViewExpertState extends State<ViewExpert> {
//   List<Map<String, dynamic>> users = [];
//   List<Map<String, dynamic>> filteredUsers = [];
//   List<String> nameSuggestions = [];
//   bool _isLoading = false;
//   bool _hasError = false;
//   String _selectedQualification = 'All'; // For qualification filter
//   String _sortBy = 'Name'; // For sorting
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchExperts();
//     _searchController.addListener(_filterExperts);
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // Fetch experts from server
//   Future<void> _fetchExperts() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String urls = prefs.getString('url') ?? '';
//       final String img = prefs.getString('img_url') ?? '';
//       final String apiUrl = '$urls/user_viewexpert/';
//
//       if (urls.isEmpty) {
//         Fluttertoast.showToast(msg: 'Server configuration missing');
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//         return;
//       }
//
//       final response = await http.post(Uri.parse(apiUrl), body: {
//         'lid':prefs.getString('lid').toString()
//       });
//       final jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         final List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'].toString(),
//             'name': item['name'].toString(),
//             'emailid': item['emailid'].toString(),
//             'phonenumber': item['phonenumber'].toString(),
//             'place': item['place'].toString(),
//             'post': item['post'].toString(),
//             'pincode': item['pincode'].toString(),
//             'qualification': item['qualification'].toString(),
//             'experience': item['experience'].toString(),
//             'photo': '$img${item['photo']}',
//             'rsts':item['rsts'].toString(),
//           });
//         }
//         setState(() {
//           users = tempList;
//           nameSuggestions = tempList.map((e) => e['name'].toString()).toSet().toList();
//           _filterExperts();
//           _isLoading = false;
//         });
//         // Cache data
//         await prefs.setString('experts_cache', json.encode(tempList));
//       } else {
//         Fluttertoast.showToast(msg: 'No experts found');
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error fetching experts: $e');
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//       // Load from cache if available
//       final prefs = await SharedPreferences.getInstance();
//       final cachedData = prefs.getString('experts_cache');
//       if (cachedData != null) {
//         final List<dynamic> cachedList = json.decode(cachedData);
//         setState(() {
//           users = cachedList.cast<Map<String, dynamic>>();
//           nameSuggestions = users.map((e) => e['name'].toString()).toSet().toList();
//           _filterExperts();
//         });
//       }
//     }
//   }
//
//   // Filter and sort experts
//   void _filterExperts() {
//     final query = _searchController.text.toLowerCase();
//     var tempList = users.where((user) {
//       final matchesSearch = user['name'].toLowerCase().contains(query);
//       final matchesQualification =
//           _selectedQualification == 'All' || user['qualification'] == _selectedQualification;
//       return matchesSearch && matchesQualification;
//     }).toList();
//
//     // Sort by name or experience
//     tempList.sort((a, b) {
//       if (_sortBy == 'Name') {
//         return a['name'].compareTo(b['name']);
//       } else {
//         return int.parse(a['experience']).compareTo(int.parse(b['experience']));
//       }
//     });
//
//     setState(() {
//       filteredUsers = tempList;
//     });
//   }
//
//   // Show detailed expert dialog
//   void _showExpertDetails(Map<String, dynamic> user) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(user['name']),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: NetworkImage(user['photo']),
//                   onBackgroundImageError: (_, __) => const Icon(Icons.error),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text('Email:', style: Theme.of(context).textTheme.titleMedium),
//               Text(user['emailid']),
//               const SizedBox(height: 8),
//               Text('Phone:', style: Theme.of(context).textTheme.titleMedium),
//               Text(user['phonenumber']),
//               const SizedBox(height: 8),
//               Text('Place:', style: Theme.of(context).textTheme.titleMedium),
//               Text(user['place']),
//               const SizedBox(height: 8),
//               Text('Post:', style: Theme.of(context).textTheme.titleMedium),
//               Text(user['post']),
//               const SizedBox(height: 8),
//               Text('Pincode:', style: Theme.of(context).textTheme.titleMedium),
//               Text(user['pincode']),
//               const SizedBox(height: 8),
//               Text('Qualification:', style: Theme.of(context).textTheme.titleMedium),
//               Text(user['qualification']),
//               const SizedBox(height: 8),
//               Text('Experience:', style: Theme.of(context).textTheme.titleMedium),
//               Text('${user['experience']} years'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // _sendRequest(user['name']);
//             },
//             child: const Text('Requesthhh'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Send request to expert
//   Future<void> _sendRequest(String expertName, String eid) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Request'),
//         content: Text('Send a request to $expertName?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     setState(() => _isLoading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String urls = prefs.getString('url') ?? '';
//       final String lid = prefs.getString('lid') ?? '';
//
//       final String apiUrl = '$urls/send_request/'; // Adjust endpoint as needed
//
//       if (urls.isEmpty || lid.isEmpty) {
//         Fluttertoast.showToast(msg: 'Server configuration missing');
//         return;
//       }
//
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         body: {
//           'eid': eid,
//           'lid': lid,
//
//         },
//       );
//       final jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Request sent successfully');
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to send request');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error sending request: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   // Logout user
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Experts",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.deepPurple, Colors.purpleAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchExperts,
//         child: Column(
//           children: [
//             // Search and Filter
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Autocomplete<String>(
//                       optionsBuilder: (TextEditingValue value) {
//                         if (value.text.isEmpty) {
//                           return nameSuggestions;
//                         }
//                         return nameSuggestions.where((suggestion) =>
//                             suggestion.toLowerCase().contains(value.text.toLowerCase()));
//                       },
//                       onSelected: (value) {
//                         _searchController.text = value;
//                         _filterExperts();
//                       },
//                       fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//                         _searchController.text = controller.text;
//                         return TextField(
//                           controller: controller,
//                           focusNode: focusNode,
//                           decoration: InputDecoration(
//                             hintText: 'Search by name...',
//                             prefixIcon: const Icon(Icons.search),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   DropdownButton<String>(
//                     value: _selectedQualification,
//                     items: ['All', 'PhD', 'Master', 'Bachelor', 'Other']
//                         .map((qual) => DropdownMenuItem(
//                       value: qual,
//                       child: Text(qual),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedQualification = value!;
//                         _filterExperts();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // Sort Options
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   const Text('Sort by:'),
//                   const SizedBox(width: 8),
//                   DropdownButton<String>(
//                     value: _sortBy,
//                     items: ['Name', 'Experience']
//                         .map((sort) => DropdownMenuItem(
//                       value: sort,
//                       child: Text(sort),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _sortBy = value!;
//                         _filterExperts();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // Expert List
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _hasError
//                   ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Failed to load experts'),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _fetchExperts,
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               )
//                   : filteredUsers.isEmpty
//                   ? const Center(child: Text('No experts found'))
//                   : ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: filteredUsers.length,
//                 itemBuilder: (context, index) {
//                   final user = filteredUsers[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 8),
//                     child: ListTile(
//                       onTap: () => _showExpertDetails(user),
//                       leading: CircleAvatar(
//                         radius: 30,
//                         backgroundImage: NetworkImage(user['photo']),
//                         onBackgroundImageError: (_, __) =>
//                         const Icon(Icons.person),
//                       ),
//                       title: Text(
//                         user['name'],
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Qualification: ${user['qualification']}'),
//                           Text('Experience: ${user['experience']} years'),
//                           const SizedBox(height: 8),
//
//                           if(user['rsts'] == "no")...{
//                             ElevatedButton(
//                               onPressed: () =>
//                                   _sendRequest(
//                                       user['name'], user['id'].toString()),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.deepPurple,
//                                 foregroundColor: Colors.white,
//                               ),
//                               child: const Text('Request'),
//                             ),
//                           }
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Placeholder for LoginPage (replace with actual implementation)
// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: const Center(child: Text('Login Page')),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expert Viewer',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Changed to match #09818A
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const ViewExpert(title: 'View Experts'),
    );
  }
}

class ViewExpert extends StatefulWidget {
  const ViewExpert({super.key, required this.title});

  final String title;

  @override
  State<ViewExpert> createState() => _ViewExpertState();
}

class _ViewExpertState extends State<ViewExpert> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<String> nameSuggestions = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _selectedQualification = 'All'; // For qualification filter
  String _sortBy = 'Name'; // For sorting
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExperts();
    _searchController.addListener(_filterExperts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch experts from server
  Future<void> _fetchExperts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final String urls = prefs.getString('url') ?? '';
      final String img = prefs.getString('img_url') ?? '';
      final String apiUrl = '$urls/user_viewexpert/';

      if (urls.isEmpty) {
        Fluttertoast.showToast(msg: 'Server configuration missing');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      final response = await http.post(Uri.parse(apiUrl), body: {
        'lid':prefs.getString('lid').toString()
      });
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        final List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'name': item['name'].toString(),
            'emailid': item['emailid'].toString(),
            'phonenumber': item['phonenumber'].toString(),
            'place': item['place'].toString(),
            'post': item['post'].toString(),
            'pincode': item['pincode'].toString(),
            'qualification': item['qualification'].toString(),
            'experience': item['experience'].toString(),
            'photo': '$img${item['photo']}',
            'rsts':item['rsts'].toString(),
          });
        }
        setState(() {
          users = tempList;
          nameSuggestions = tempList.map((e) => e['name'].toString()).toSet().toList();
          _filterExperts();
          _isLoading = false;
        });
        // Cache data
        await prefs.setString('experts_cache', json.encode(tempList));
      } else {
        Fluttertoast.showToast(msg: 'No experts found');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching experts: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      // Load from cache if available
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('experts_cache');
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        setState(() {
          users = cachedList.cast<Map<String, dynamic>>();
          nameSuggestions = users.map((e) => e['name'].toString()).toSet().toList();
          _filterExperts();
        });
      }
    }
  }

  // Filter and sort experts
  void _filterExperts() {
    final query = _searchController.text.toLowerCase();
    var tempList = users.where((user) {
      final matchesSearch = user['name'].toLowerCase().contains(query);
      final matchesQualification =
          _selectedQualification == 'All' || user['qualification'] == _selectedQualification;
      return matchesSearch && matchesQualification;
    }).toList();

    // Sort by name or experience
    tempList.sort((a, b) {
      if (_sortBy == 'Name') {
        return a['name'].compareTo(b['name']);
      } else {
        return int.parse(a['experience']).compareTo(int.parse(b['experience']));
      }
    });

    setState(() {
      filteredUsers = tempList;
    });
  }

  // Show detailed expert dialog
  void _showExpertDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user['photo']),
                  onBackgroundImageError: (_, __) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 16),
              Text('Email:', style: Theme.of(context).textTheme.titleMedium),
              Text(user['emailid']),
              const SizedBox(height: 8),
              Text('Phone:', style: Theme.of(context).textTheme.titleMedium),
              Text(user['phonenumber']),
              const SizedBox(height: 8),
              Text('Place:', style: Theme.of(context).textTheme.titleMedium),
              Text(user['place']),
              const SizedBox(height: 8),
              Text('Post:', style: Theme.of(context).textTheme.titleMedium),
              Text(user['post']),
              const SizedBox(height: 8),
              Text('Pincode:', style: Theme.of(context).textTheme.titleMedium),
              Text(user['pincode']),
              const SizedBox(height: 8),
              Text('Qualification:', style: Theme.of(context).textTheme.titleMedium),
              Text(user['qualification']),
              const SizedBox(height: 8),
              Text('Experience:', style: Theme.of(context).textTheme.titleMedium),
              Text('${user['experience']} years'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // _sendRequest(user['name']);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF09818A), // Changed to #09818A
            ),
            child: const Text('Requesthhh'),
          ),
        ],
      ),
    );
  }

  // Send request to expert
  Future<void> _sendRequest(String expertName, String eid) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Request'),
        content: Text('Send a request to $expertName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF09818A), // Changed to #09818A
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String urls = prefs.getString('url') ?? '';
      final String lid = prefs.getString('lid') ?? '';

      final String apiUrl = '$urls/send_request/'; // Adjust endpoint as needed

      if (urls.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Server configuration missing');
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'eid': eid,
          'lid': lid,

        },
      );
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Request sent successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to send request');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error sending request: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Logout user
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Experts",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF09818A), Color(0xFF1F98B8)], // Changed to #09818A and #1F98B8
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: _logout,
          //   tooltip: 'Logout',
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchExperts,
        color: const Color(0xFF09818A), // Changed to #09818A
        child: Column(
          children: [
            // Search and Filter
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue value) {
                        if (value.text.isEmpty) {
                          return nameSuggestions;
                        }
                        return nameSuggestions.where((suggestion) =>
                            suggestion.toLowerCase().contains(value.text.toLowerCase()));
                      },
                      onSelected: (value) {
                        _searchController.text = value;
                        _filterExperts();
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        _searchController.text = controller.text;
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Search by name...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedQualification,
                    items: ['All', 'PhD', 'Master', 'Bachelor', 'Other']
                        .map((qual) => DropdownMenuItem(
                      value: qual,
                      child: Text(qual),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedQualification = value!;
                        _filterExperts();
                      });
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Color(0xFF09818A)), // Changed to #09818A
                  ),
                ],
              ),
            ),
            // Sort Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Sort by:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: ['Name', 'Experience']
                        .map((sort) => DropdownMenuItem(
                      value: sort,
                      child: Text(sort),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                        _filterExperts();
                      });
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Color(0xFF09818A)), // Changed to #09818A
                  ),
                ],
              ),
            ),
            // Expert List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load experts'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchExperts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF09818A), // Changed to #09818A
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
                  : filteredUsers.isEmpty
                  ? const Center(child: Text('No experts found'))
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      onTap: () => _showExpertDetails(user),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user['photo']),
                        onBackgroundImageError: (_, __) =>
                        const Icon(Icons.person),
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Qualification: ${user['qualification']}'),
                          Text('Experience: ${user['experience']} years'),
                          const SizedBox(height: 8),

                          if(user['rsts'] == "no")...{
                            ElevatedButton(
                              onPressed: () =>
                                  _sendRequest(
                                      user['name'], user['id'].toString()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF09818A), // Changed to #09818A
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Request'),
                            ),
                          }
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for LoginPage (replace with actual implementation)
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
      body: const Center(child: Text('Login Page')),
    );
  }
}