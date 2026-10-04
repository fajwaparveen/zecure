// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intrusion_detection/sendcomplaint.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewRequestStatus extends StatefulWidget {
//   const ViewRequestStatus({ Key? key, required this.title }) : super(key: key);
//
//   final String title;
//
//   @override
//   State<ViewRequestStatus> createState() => _ViewRequestStatusState();
// }
//
// class _ViewRequestStatusState extends State<ViewRequestStatus> {
//   List<Map<String, dynamic>> _requests = [];
//   bool _isLoading = false;
//   bool _hasError = false;
//
//   static const double _kPadding = 16.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRequests();
//   }
//
//   Future<void> _fetchRequests() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final urls = prefs.getString('url') ?? '';
//       final lid = prefs.getString('lid') ?? '';
//       final apiUrl = '$urls/user_ViewRequestStatus/';
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
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         body: { "lid": lid },
//       );
//       final jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         final List<Map<String, dynamic>> list = [];
//         for (var item in jsonData['data']) {
//           list.add({
//             'id': item['id'].toString(),
//             'date': item['date'].toString(),
//             'expertname': item['expertname'].toString(),
//             'expertemail': item['expertemail'].toString(),
//             'phonenumber': item['phonenumber'].toString(),
//             'status': item['status'].toString(),
//           });
//         }
//         setState(() {
//           _requests = list;
//           _isLoading = false;
//         });
//         await prefs.setString('requests_cache', json.encode(list));
//       } else {
//         Fluttertoast.showToast(msg: 'No requests found');
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error fetching data: $e');
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//       final prefs = await SharedPreferences.getInstance();
//       final cachedData = prefs.getString('requests_cache');
//       if (cachedData != null) {
//         final List<dynamic> cachedList = json.decode(cachedData);
//         setState(() {
//           _requests = cachedList.cast<Map<String, dynamic>>();
//         });
//       }
//     }
//   }
//
//   void _showDetailsDialog(Map<String, dynamic> item) {
//     final bool isReplied = item['status'] == 'Replied';
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Request Details'),
//         content: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(_kPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Date', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text(item['date']),
//                 const SizedBox(height: 16),
//
//                 Text('Expert Name', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text(item['expertname']),
//                 const SizedBox(height: 16),
//
//                 Text('Expert Email', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text(item['expertemail']),
//                 const SizedBox(height: 16),
//
//                 Text('Phone Number', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text(item['phonenumber']),
//                 const SizedBox(height: 16),
//
//                 Text('Status', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text(
//                   item['status'],
//                   style: TextStyle(
//                     color: isReplied ? Colors.green : Colors.orange,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
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
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     // Navigate to your login or home page
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Status",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
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
//
//       body: RefreshIndicator(
//         onRefresh: _fetchRequests,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _hasError
//             ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Failed to load requests'),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _fetchRequests,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         )
//             : _requests.isEmpty
//             ? const Center(child: Text('No requests found'))
//             : ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           itemCount: _requests.length,
//           itemBuilder: (context, index) {
//             final item = _requests[index];
//             final bool isReplied = item['status'] == 'Replied';
//             return Card(
//               margin: const EdgeInsets.symmetric(
//                   horizontal: _kPadding, vertical: 8),
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 onTap: () => _showDetailsDialog(item),
//                 leading: CircleAvatar(
//                   backgroundColor:
//                   isReplied ? Colors.green : Colors.orange,
//                   child: Icon(
//                     isReplied ? Icons.check_circle : Icons.hourglass_empty,
//                     color: Colors.white,
//                   ),
//                 ),
//                 title: Text(
//                   item['expertname'],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 subtitle: Text('Date: ${item['date']}'),
//                 trailing: Text(
//                   item['status'],
//                   style: TextStyle(
//                     color: isReplied ? Colors.green : Colors.orange,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intrusion_detection/chat.dart';
import 'package:intrusion_detection/sendcomplaint.dart'; // assuming this exists
import 'package:shared_preferences/shared_preferences.dart';

class ViewRequestStatus extends StatefulWidget {
  const ViewRequestStatus({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewRequestStatus> createState() => _ViewRequestStatusState();
}

class _ViewRequestStatusState extends State<ViewRequestStatus> {
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = false;
  bool _hasError = false;

  static const double _kPadding = 16.0;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final urls = prefs.getString('url') ?? '';
      final lid = prefs.getString('lid') ?? '';
      final apiUrl = '$urls/user_ViewRequestStatus/';

      if (urls.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Server configuration missing');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"lid": lid},
      );
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        final List<Map<String, dynamic>> list = [];
        for (var item in jsonData['data']) {
          list.add({
            'id': item['id'].toString(),
            'eid': item['eid'].toString(),
            'date': item['date'].toString(),
            'expertname': item['expertname'].toString(),
            'expertemail': item['expertemail'].toString(),
            'phonenumber': item['phonenumber'].toString(),
            'status': item['status'].toString(),
          });
        }
        setState(() {
          _requests = list;
          _isLoading = false;
        });
        await prefs.setString('requests_cache', json.encode(list));
      } else {
        Fluttertoast.showToast(msg: 'No requests found');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching data: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('requests_cache');
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        setState(() {
          _requests = cachedList.cast<Map<String, dynamic>>();
        });
      }
    }
  }

  void _showDetailsDialog(Map<String, dynamic> item) {
    final bool isReplied = item['status'].toString().toLowerCase() == 'replied';
    final bool isApproved = item['status'].toString().toLowerCase() == 'approved';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Details'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(_kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09818A).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item['date']),
                ),
                const SizedBox(height: 16),
                Text('Expert Name', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F98B8).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item['expertname']),
                ),
                const SizedBox(height: 16),
                Text('Expert Email', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09818A).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item['expertemail']),
                ),
                const SizedBox(height: 16),
                Text('Phone Number', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F98B8).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item['phonenumber']),
                ),
                const SizedBox(height: 16),
                Text('Status', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF09818A).withOpacity(0.1),
                        const Color(0xFF1F98B8).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      color: isApproved
                          ? Colors.blue
                          : isReplied
                          ? Colors.green
                          : const Color(0xFF09818A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (isApproved)
            TextButton.icon(
              icon: const Icon(Icons.chat, size: 20),
              label: const Text('Chat'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
                _openChat(item);
              },
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF09818A),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _openChat(Map<String, dynamic> item) async {

    SharedPreferences sh=await SharedPreferences.getInstance();
    sh.setString("aid", item['eid'].toString());
    sh.setString("agrname", item['expertname'].toString());
    // Replace this with your actual navigation to chat screen
    Fluttertoast.showToast(
      msg: "Opening chat with ${item['expertname']}",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    // Example navigation (uncomment and adjust when you have ChatScreen):
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyChatPage(title: '',
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigate to login screen - add your navigation code here
    // Example: Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request Status",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF09818A), Color(0xFF1F98B8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF09818A).withOpacity(0.05),
              const Color(0xFF1F98B8).withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchRequests,
          color: const Color(0xFF09818A),
          backgroundColor: Colors.white,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Color(0xFF09818A),
                ),
                const SizedBox(height: 16),
                const Text('Failed to load requests'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchRequests,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09818A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
              : _requests.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No requests found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(_kPadding),
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              final item = _requests[index];
              final statusLower = item['status'].toString().toLowerCase();
              final bool isReplied = statusLower == 'replied';
              final bool isApproved = statusLower == 'approved';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: () => _showDetailsDialog(item),
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: isApproved
                          ? const LinearGradient(
                        colors: [Colors.blue, Colors.lightBlue],
                      )
                          : isReplied
                          ? const LinearGradient(
                        colors: [Colors.green, Colors.lightGreen],
                      )
                          : const LinearGradient(
                        colors: [Color(0xFF09818A), Color(0xFF1F98B8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isApproved
                          ? Icons.chat
                          : isReplied
                          ? Icons.check_circle
                          : Icons.hourglass_empty,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    item['expertname'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${item['date']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isApproved
                              ? Colors.blue.withOpacity(0.1)
                              : isReplied
                              ? Colors.green.withOpacity(0.1)
                              : const Color(0xFF09818A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(
                            color: isApproved
                                ? Colors.blue
                                : isReplied
                                ? Colors.green
                                : const Color(0xFF09818A),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (isApproved) ...[
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.blue,
                          ),
                          tooltip: 'Chat with expert',
                          onPressed: () => _openChat(item),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}