import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
      title: 'Log Viewer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const ViewLogs(title: 'Log Viewer'),
    );
  }
}

class ViewLogs extends StatefulWidget {
  const ViewLogs({super.key, required this.title});

  final String title;

  @override
  State<ViewLogs> createState() => _ViewLogsState();
}

class _ViewLogsState extends State<ViewLogs> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _selectedResult = 'All'; // For result filter
  bool _sortAscending = true; // For date sorting
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLogs();
    _searchController.addListener(_filterLogs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch logs from server
  Future<void> _fetchLogs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final String urls = prefs.getString('url') ?? '';
      final String lid = prefs.getString('lid') ?? '';
      final String apiUrl = '$urls/user_viewlogs/';

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
            'time': item['time'].toString(),
            'ipaddress': item['ipaddress'].toString(),
            'result': item['result'].toString(),
          });
        }
        setState(() {
          users = tempList;
          _filterLogs();
          _isLoading = false;
        });
        // Cache data
        await prefs.setString('logs_cache', json.encode(tempList));
      } else {
        Fluttertoast.showToast(msg: 'No logs found');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching logs: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      // Load from cache if available
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('logs_cache');
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        setState(() {
          users = cachedList.cast<Map<String, dynamic>>();
          _filterLogs();
        });
      }
    }
  }

  // Filter and sort logs
  void _filterLogs() {
    final query = _searchController.text.toLowerCase();
    var tempList = users.where((user) {
      final matchesSearch = user['ipaddress'].toLowerCase().contains(query) ||
          user['result'].toLowerCase().contains(query);
      final matchesResult =
          _selectedResult == 'All' || user['result'] == _selectedResult;
      return matchesSearch && matchesResult;
    }).toList();

    // Sort by date
    tempList.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return _sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    setState(() {
      filteredUsers = tempList;
    });
  }

  // Show detailed log dialog
  void _showLogDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('IP Address:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(user['ipaddress']),
              const SizedBox(height: 16),
              Text('Result:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(user['result']),
              const SizedBox(height: 16),
              Text('Date: ${user['date']}'),
              const SizedBox(height: 8),
              Text('Time: ${user['time']}'),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyLoginPage(title: '',)),
    );
  }

  // Export logs to JSON
  Future<void> _exportLogs() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/logs_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File(path);
      await file.writeAsString(json.encode(users));
      Fluttertoast.showToast(msg: 'Logs exported to $path');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error exporting logs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logs",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLogs,
            tooltip: 'Export Logs',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLogs,
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
                        hintText: 'Search by IP or result...',
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
                    value: _selectedResult,
                    items: ['All', 'Success', 'Failure']
                        .map((result) => DropdownMenuItem(
                      value: result,
                      child: Text(result),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedResult = value!;
                        _filterLogs();
                      });
                    },
                  ),
                ],
              ),
            ),
            // Sort Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Sort by Date:'),
                  IconButton(
                    icon: Icon(
                      _sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                    onPressed: () {
                      setState(() {
                        _sortAscending = !_sortAscending;
                        _filterLogs();
                      });
                    },
                  ),
                ],
              ),
            ),
            // Log List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load logs'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchLogs,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
                  : filteredUsers.isEmpty
                  ? const Center(child: Text('No logs found'))
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      onTap: () => _showLogDetails(user),
                      leading: CircleAvatar(
                        backgroundColor: user['result'] == 'Success'
                            ? Colors.green
                            : Colors.red,
                        child: Text(
                          user['result'][0],
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user['ipaddress'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Date: ${user['date']} • Time: ${user['time']}',
                      ),
                      trailing: Icon(
                        user['result'] == 'Success'
                            ? Icons.check_circle
                            : Icons.error,
                        color: user['result'] == 'Success'
                            ? Colors.green
                            : Colors.red,
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
