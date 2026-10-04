import 'package:flutter/material.dart';
import 'package:intrusion_detection/editprofile.dart';
import 'package:intrusion_detection/sendcomplaint.dart';
import 'package:intrusion_detection/sendreview.dart';
import 'package:intrusion_detection/viewexpert.dart';
import 'package:intrusion_detection/viewlogs.dart';
import 'package:intrusion_detection/viewprofile.dart';
import 'package:intrusion_detection/viewreply.dart';

import 'package:intrusion_detection/viewvideo.dart';
import 'changepassword.dart';
import 'viewprofile.dart';

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
      home: const homepage(title: 'IP Page'),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key, required this.title});

  final String title;

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  // ✅ Create a TextEditingController
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => changepassword()),
                  );
                },
                child: const Text(' change password'),
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => viewvideos(title: '',)),
                  );
                },
                child: const Text(' view video'),
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewProfile(title: '',)),
                  );
                },
                child: const Text('view profile'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
                child: const Text('edit profile'),
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendComplaint()),
                  );
                },
                child: const Text('send complaint'),
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                        builder: (context) => ViewReply(title: '',)),
                  );
                },
                child: const Text('view reply'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewExpert(title: '',)),
                  );
                },
                child: const Text('view expert'),
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendReviewPage()),
                  );
                },
                child: const Text('send review'),
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewLogs(title: '',)),
                  );
                },
                child: const Text('view logs'),
              ),


            ],
          ),
        ),
      ),
    );
  }


}
