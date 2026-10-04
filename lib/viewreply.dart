// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intrusion_detection/sendcomplaint.dart';
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
//         primarySwatch: Colors.deepPurple,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         cardTheme: CardTheme(
//           elevation: 8,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//       home: const ViewReply(title: 'Complaint Replies'),
//     );
//   }
// }
//
// class ViewReply extends StatefulWidget {
//   const ViewReply({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewReply> createState() => _ViewReplyState();
// }
//
// class _ViewReplyState extends State<ViewReply> {
//   List<Map<String, dynamic>> users = [];
//   List<Map<String, dynamic>> filteredUsers = [];
//   bool _isLoading = false;
//   bool _hasError = false;
//   String _selectedStatus = 'All'; // For status filter
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchComplaints();
//     _searchController.addListener(_filterComplaints);
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // Fetch complaints from server
//   Future<void> _fetchComplaints() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String urls = prefs.getString('url') ?? '';
//       final String lid = prefs.getString('lid') ?? '';
//       final String apiUrl = '$urls/user_viewreply/';
//
//       if (urls.isEmpty || lid.isEmpty) {
//         Fluttertoast.showToast(msg: 'Server configuration missing');
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//         return;
//       }
//
//       final response = await http.post(Uri.parse(apiUrl), body: {"lid": lid});
//       final jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         final List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'date': item['date'].toString(),
//             'complaint': item['complaint'].toString(),
//             'status': item['status'].toString(),
//             'reply': item['reply'].toString(),
//           });
//         }
//         setState(() {
//           users = tempList;
//           filteredUsers = tempList;
//           _isLoading = false;
//         });
//         // Cache data
//         await prefs.setString('complaints_cache', json.encode(tempList));
//       } else {
//         Fluttertoast.showToast(msg: 'No complaints found');
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error fetching complaints: $e');
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//       // Load from cache if available
//       final prefs = await SharedPreferences.getInstance();
//       final cachedData = prefs.getString('complaints_cache');
//       if (cachedData != null) {
//         final List<dynamic> cachedList = json.decode(cachedData);
//         setState(() {
//           users = cachedList.cast<Map<String, dynamic>>();
//           filteredUsers = users;
//         });
//       }
//     }
//   }
//
//   // Filter complaints based on search and status
//   void _filterComplaints() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredUsers = users.where((user) {
//         final matchesSearch = user['complaint'].toLowerCase().contains(query) ||
//             user['reply'].toLowerCase().contains(query);
//         final matchesStatus = _selectedStatus == 'All' ||
//             user['status'] == _selectedStatus;
//         return matchesSearch && matchesStatus;
//       }).toList();
//     });
//   }
//
//   // Show detailed complaint dialog
//   void _showComplaintDetails(Map<String, dynamic> user) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Complaint Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Complaint:', style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 8),
//               Text(user['complaint']),
//               const SizedBox(height: 16),
//               Text('Reply:', style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 8),
//               Text(user['reply'].isEmpty ? 'No reply yet' : user['reply']),
//               const SizedBox(height: 16),
//               Text('Date: ${user['date']}'),
//               const SizedBox(height: 8),
//               Text('Status: ${user['status']}'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Logout user
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     // Navigator.pushReplacement(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => const LoginPage()),
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Reply",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
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
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SendComplaint()),
//           );
//         },
//         backgroundColor: Colors.deepPurple,
//         child: const Icon(Icons.add),
//         tooltip: 'New Complaint',
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchComplaints,
//         child: Column(
//           children: [
//             // Search and Filter
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search complaints...',
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   DropdownButton<String>(
//                     value: _selectedStatus,
//                     items: ['All', 'Pending', 'Replied']
//                         .map((status) => DropdownMenuItem(
//                       value: status,
//                       child: Text(status),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedStatus = value!;
//                         _filterComplaints();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // Complaint List
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _hasError
//                   ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Failed to load complaints'),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _fetchComplaints,
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               )
//                   : filteredUsers.isEmpty
//                   ? const Center(child: Text('No complaints found'))
//                   : ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: filteredUsers.length,
//                 itemBuilder: (context, index) {
//                   final user = filteredUsers[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 8),
//                     child: ListTile(
//                       onTap: () => _showComplaintDetails(user),
//                       leading: CircleAvatar(
//                         backgroundColor: user['status'] == 'Replied'
//                             ? Colors.green
//                             : Colors.orange,
//                         child: Text(
//                           user['status'],
//                           style: const TextStyle(
//                               color: Colors.white),
//                         ),
//                       ),
//                       title: Text(
//                         user['complaint'],
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       subtitle: Text('Date: ${user['date']}'),
//                       trailing: Icon(
//                         user['status'] == 'Replied'
//                             ? Icons.check_circle
//                             : Icons.hourglass_empty,
//                         color: user['status'] == 'Replied'
//                             ? Colors.green
//                             : Colors.orange,
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




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intrusion_detection/sendcomplaint.dart';
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
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const ViewReply(title: 'Complaint Replies'),
    );
  }
}

class ViewReply extends StatefulWidget {
  const ViewReply({super.key, required this.title});

  final String title;

  @override
  State<ViewReply> createState() => _ViewReplyState();
}

class _ViewReplyState extends State<ViewReply> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _selectedStatus = 'All'; // For status filter
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
    _searchController.addListener(_filterComplaints);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch complaints from server
  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final String urls = prefs.getString('url') ?? '';
      final String lid = prefs.getString('lid') ?? '';
      final String apiUrl = '$urls/user_viewreply/';

      if (urls.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Server configuration missing');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      final response = await http.post(Uri.parse(apiUrl), body: {"lid": lid});
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        final List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'date': item['date'].toString(),
            'complaint': item['complaint'].toString(),
            'status': item['status'].toString(),
            'reply': item['reply'].toString(),
          });
        }
        setState(() {
          users = tempList;
          filteredUsers = tempList;
          _isLoading = false;
        });
        // Cache data
        await prefs.setString('complaints_cache', json.encode(tempList));
      } else {
        Fluttertoast.showToast(msg: 'No complaints found');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching complaints: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      // Load from cache if available
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('complaints_cache');
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        setState(() {
          users = cachedList.cast<Map<String, dynamic>>();
          filteredUsers = users;
        });
      }
    }
  }

  // Filter complaints based on search and status
  void _filterComplaints() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        final matchesSearch = user['complaint'].toLowerCase().contains(query) ||
            user['reply'].toLowerCase().contains(query);
        final matchesStatus = _selectedStatus == 'All' ||
            user['status'] == _selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  // Show detailed complaint dialog
  void _showComplaintDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complaint Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Complaint:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(user['complaint']),
              const SizedBox(height: 16),
              Text('Reply:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(user['reply'].isEmpty ? 'No reply yet' : user['reply']),
              const SizedBox(height: 16),
              Text('Date: ${user['date']}'),
              const SizedBox(height: 8),
              Text('Status: ${user['status']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Logout user
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complaint Status",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SendComplaint()),
          );
        },
        backgroundColor: const Color(0xFF09818A), // Changed to #09818A
        child: const Icon(Icons.add),
        tooltip: 'New Complaint',
      ),
      body: RefreshIndicator(
        onRefresh: _fetchComplaints,
        color: const Color(0xFF09818A), // Changed to #09818A
        child: Column(
          children: [
            // Search and Filter
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search complaints...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedStatus,
                    items: ['All', 'Pending', 'Replied']
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                        _filterComplaints();
                      });
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Color(0xFF09818A)), // Changed to #09818A
                  ),
                ],
              ),
            ),
            // Complaint List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load complaints'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchComplaints,
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
                  ? const Center(child: Text('No complaints found'))
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      onTap: () => _showComplaintDetails(user),
                      leading: CircleAvatar(
                        backgroundColor: user['status'] == 'Replied'
                            ? Colors.green
                            : const Color(0xFF09818A).withOpacity(0.7), // Changed to related color
                        child: Text(
                          user['status'][0], // Show first letter of status
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user['complaint'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Date: ${user['date']}'),
                      trailing: Icon(
                        user['status'] == 'Replied'
                            ? Icons.check_circle
                            : Icons.hourglass_empty,
                        color: user['status'] == 'Replied'
                            ? Colors.green
                            : const Color(0xFF09818A).withOpacity(0.7), // Changed to related color
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