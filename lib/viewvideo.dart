import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const viewvideos(title: 'IP Page'),
    );
  }
}

class viewvideos extends StatefulWidget {
  const viewvideos({super.key, required this.title});

  final String title;

  @override
  State<viewvideos> createState() => _viewvideosState();
}

class _viewvideosState extends State<viewvideos> {


  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<String> nameSuggestions = [];

  @override
  void initState() {
    super.initState();
    viewUsers("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Video",style: TextStyle(color: Colors.white),textAlign: TextAlign.left),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(

              // title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("title: ${user['title']}"),
                  Text("date: ${user['date']}"),
                  Text("EXPERT: ${user['EXPERT']}"),
                  Text("video: ${user['video']}"),
                 
                  

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> viewUsers(String searchValue) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String img = sh.getString('img_url') ?? '';
      String apiUrl = '$urls/user_viewvideo/';

      var response = await http.post(Uri.parse(apiUrl), body: {});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'title': item['title'].toString(),
            'date': item['date'].toString(),
            'EXPERT': item['EXPERT'].toString(),
            'video': item['video'].toString(),


            // 'photo': img + item['photo'],
          });
        }
        setState(() {
          users = tempList;
          filteredUsers = tempList
             ;
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }


}
