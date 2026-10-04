//
//
//
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:intrusion_detection/changepassword.dart';
// import 'package:intrusion_detection/sendreview.dart';
// import 'package:intrusion_detection/viewexpert.dart';
// import 'package:intrusion_detection/viewlogs.dart';
// import 'package:intrusion_detection/viewprofile.dart';
// import 'package:intrusion_detection/viewrequeststatus.dart';
// import '../../editprofile.dart';
// import '../../login.dart';
// import '../../viewreply.dart';
// import '../utils/size_config.dart'; // Adjust import if needed
// import '../views/loading_screens.dart'; // Adjust import if needed
//
// import 'package:flutter/material.dart';
// import 'home_screen.dart'; // Assuming it's in the same folder
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
//       title: 'Intrusion Detection',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.teal, // Changed to match #09818A
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF09818A),
//           brightness: Brightness.light,
//         ),
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
//
//   bool isInProgress = false;
//   int _current = 0;
//
//   final List<String> imgCategoryList = [
//     'assets/images/categories/profile icon.png',
//     'assets/images/categories/expert icon.png',
//     'assets/images/categories/complaint icon.png',
//     'assets/images/categories/rating icon.png',
//   ];
//
//   final List<String> nameCategoryList = [
//     'Profile',
//     'Expert',
//     'Complaint',
//     'Rating',
//   ];
//
//   final List<String> imgNews = [
//     './assets/images/placeholder/changepassword.jpg',
//     './assets/images/placeholder/logs.png',
//   ];
//   final List<String> imgtitle = [
//     'Request Status',
//     'Logs',
//   ];
//
//   // ✅ Logout confirmation dialog function
//   Future<void> _showLogoutDialog() async {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout Confirmation'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Perform logout action here
//                 Navigator.of(context).pop(); // Close the dialog
//
//                 // Navigate to login page
//                 Navigator.pushReplacement(
//                   context,
//                   PageRouteBuilder(
//                     transitionDuration: const Duration(milliseconds: 600),
//                     pageBuilder: (_, __, ___) => MyLoginPage(title: ''),
//                     transitionsBuilder: (_, animation, __, child) {
//                       return FadeTransition(opacity: animation, child: child);
//                     },
//                   ),
//                 );
//
//                 // Show logout message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Logged out successfully')),
//                 );
//               },
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadHomeData();
//   }
//
//   Future<void> _loadHomeData() async {
//     setState(() => isInProgress = true);
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() => isInProgress = false);
//   }
//
//   Future<void> _refresh() async {
//     await _loadHomeData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: Colors.white,
//         body: RefreshIndicator(
//           onRefresh: _refresh,
//           backgroundColor: Colors.white,
//           color: const Color(0xFF09818A), // Changed to #09818A
//           key: _refreshIndicatorKey,
//           child: Column(
//             children: [
//               isInProgress
//                   ? SizedBox(
//                 height: 3,
//                 child: LinearProgressIndicator(
//                   minHeight: 3,
//                   valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF09818A)), // Changed to #09818A
//                 ),
//               )
//                   : const SizedBox(height: 3),
//               Expanded(child: _buildBody()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: ListView(
//         children: [
//           _userProfile(),
//           _sliderBanner(),
//           _categoriesWidget(),
//           _newsWidget(),
//         ],
//       ),
//     );
//   }
//
//   Widget _userProfile() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
//           Text("Welcome back", style: TextStyle(fontSize: 16,color: Colors.black)),
//           Text(
//             "IDPS",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
//           ),
//         ]),
//
//         // ✅ Profile icon with popup menu
//         PopupMenuButton<String>(
//           onSelected: (value) {
//             if (value == 'logout') {
//               _showLogoutDialog();
//             } else if (value == 'change_password') {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => changepassword()),
//               );
//             } else if (value == 'edit_profile') {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => EditProfile()),
//               );
//             } else if (value == 'view_profile') {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ViewProfile(title: '')),
//               );
//             }
//           },
//           icon: ClipOval(
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: const Color(0xFF09818A)), // Changed to #09818A
//                 image: const DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage("./assets/images/categories/profile icon.png"),
//                 ),
//               ),
//               height: 54,
//               width: 54,
//             ),
//           ),
//           itemBuilder: (BuildContext context) {
//             return [
//               PopupMenuItem<String>(
//                 value: 'view_profile',
//                 child: Row(
//                   children: [
//                     const Icon(Icons.person_outline, color: Color(0xFF09818A)), // Changed to #09818A
//                     const SizedBox(width: 8),
//                     Text('View Profile'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<String>(
//                 value: 'edit_profile',
//                 child: Row(
//                   children: [
//                     const Icon(Icons.edit_outlined, color: Color(0xFF09818A)), // Changed to #09818A
//                     const SizedBox(width: 8),
//                     Text('Edit Profile'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<String>(
//                 value: 'change_password',
//                 child: Row(
//                   children: [
//                     const Icon(Icons.lock_outline, color: Color(0xFF09818A)), // Changed to #09818A
//                     const SizedBox(width: 8),
//                     Text('Change Password'),
//                   ],
//                 ),
//               ),
//               const PopupMenuDivider(),
//               const PopupMenuItem<String>(
//                 value: 'logout',
//                 child: Row(
//                   children: [
//                     Icon(Icons.logout, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text('Logout', style: TextStyle(color: Colors.red)),
//                   ],
//                 ),
//               ),
//             ];
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _sliderBanner() {
//     return Column(
//       children: [
//         CarouselSlider(
//           options: CarouselOptions(
//             viewportFraction: 1,
//             enlargeCenterPage: true,
//             onPageChanged: (index, reason) {
//               setState(() => _current = index);
//             },
//           ),
//           items: List.generate(4, (index) {
//             return Container(
//               margin: const EdgeInsets.only(top: 10),
//               child: const Image(image: AssetImage('assets/images/categories/virus.png')),
//             );
//           }),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(4, (index) {
//             return Container(
//               width: 8,
//               height: 8,
//               margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _current == index ? const Color(0xFF09818A) : Colors.grey[400], // Changed to #09818A
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   Widget _categoriesWidget() {
//     return Container(
//       padding: const EdgeInsets.only(top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: List.generate(imgCategoryList.length, (i) {
//           return InkWell(
//               onTap: () {
//                 if(nameCategoryList[i]=="Profile"){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile(title: '')));
//                 }
//                 else if(nameCategoryList[i]=="Expert"){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ViewExpert(title: '')));
//                 }
//                 else if(nameCategoryList[i]=="Complaint"){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReply(title: '')));
//                 }
//                 else if(nameCategoryList[i]=="Rating"){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => SendReviewPage()));
//                 }
//               },
//               child: _singleCategory(i)
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _singleCategory(int index) {
//     return Column(
//       children: [
//         Container(
//           width: 55,
//           height: 55,
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1F98B8).withOpacity(0.2), // Changed to #1F98B8 with opacity
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Image.asset(imgCategoryList[index], fit: BoxFit.cover),
//         ),
//         Container(
//           width: 76,
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(
//             nameCategoryList[index],
//             maxLines: 2,
//             overflow: TextOverflow.clip,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _newsWidget() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Other", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.black)),
//               InkWell(
//                 onTap: () {},
//                 child: Text(
//                   "",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF09818A)), // Changed to #09818A
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: List.generate(imgNews.length, (i) {
//               return InkWell(
//                   onTap: () {
//                     if(imgtitle[i]=='Request Status'){
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRequestStatus(title: '')));
//                     }
//                     else if(imgtitle[i]=='Logs'){
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => ViewLogs(title: '')));
//                     }
//                   },
//                   child: _singleNews(i)
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _singleNews(int index) {
//     return Stack(
//       children: [
//         Container(
//           height: 150,
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             image: DecorationImage(
//               fit: BoxFit.cover,
//               image: AssetImage(imgNews[index]),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 20,
//           left: 10,
//           child: SizedBox(
//             width: 200,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children:  [
//                 Text(
//                   imgtitle[index],
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const Positioned(
//           top: 20,
//           right: 10,
//           child: SizedBox(
//             width: 150,
//             child: Text(
//               "",
//               textAlign: TextAlign.right,
//               maxLines: 1,
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intrusion_detection/changepassword.dart';
import 'package:intrusion_detection/sendreview.dart';
import 'package:intrusion_detection/viewexpert.dart';
import 'package:intrusion_detection/viewlogs.dart';
import 'package:intrusion_detection/viewprofile.dart';
import 'package:intrusion_detection/viewrequeststatus.dart';
import '../../editprofile.dart';
import '../../login.dart';
import '../../viewreply.dart';
import '../utils/size_config.dart';
import '../views/loading_screens.dart';

import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intrusion Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF09818A),
          brightness: Brightness.light,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  bool isInProgress = false;
  int _current = 0;

  final List<String> imgCategoryList = [
    'assets/images/categories/profile icon.png',
    'assets/images/categories/expert icon.png',
    'assets/images/categories/complaint icon.png',
    'assets/images/categories/rating icon.png',
  ];

  final List<String> nameCategoryList = [
    'Profile',
    'Expert',
    'Complaint',
    'Rating',
  ];

  final List<String> imgNews = [
    './assets/images/placeholder/changepassword.jpg',
    './assets/images/placeholder/logs.png',
  ];
  final List<String> imgtitle = [
    'Request Status',
    'Logs',
  ];

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 600),
                    pageBuilder: (_, __, ___) => MyLoginPage(title: ''),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logged out successfully'),
                    backgroundColor: const Color(0xFF09818A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() => isInProgress = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isInProgress = false);
  }

  Future<void> _refresh() async {
    await _loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[50],
        body: RefreshIndicator(
          onRefresh: _refresh,
          backgroundColor: Colors.white,
          color: const Color(0xFF09818A),
          key: _refreshIndicatorKey,
          child: Column(
            children: [
              isInProgress
                  ? const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF09818A)),
              )
                  : const SizedBox(height: 2),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          _userProfile(),
          const SizedBox(height: 20),
          _sliderBanner(),
          const SizedBox(height: 25),
          _sectionHeader('Quick Actions'),
          const SizedBox(height: 15),
          _categoriesWidget(),
          const SizedBox(height: 25),
          _sectionHeader('Explore More'),
          const SizedBox(height: 15),
          _newsWidget(),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF09818A),
          ),
        ),
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF09818A), Color(0xFF1F98B8)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _userProfile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF09818A), Color(0xFF1F98B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF09818A).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Welcome back,",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "IDPS User",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog();
              } else if (value == 'change_password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => changepassword()),
                );
              } else if (value == 'edit_profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              } else if (value == 'view_profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewProfile(title: '')),
                );
              }
            },
            icon: Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("./assets/images/categories/profile icon.png"),
                ),
              ),
            ),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'view_profile',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF09818A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.person_outline, color: Color(0xFF09818A), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('View Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF09818A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_outlined, color: Color(0xFF09818A), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Edit Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'change_password',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF09818A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.lock_outline, color: Color(0xFF09818A), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Change Password'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.logout, color: Colors.red, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget _sliderBanner() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, reason) {
                setState(() => _current = index);
              },
            ),
            items: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF09818A).withOpacity(0.1),
                      const Color(0xFF1F98B8).withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/categories/virus.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _current == index ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: _current == index
                    ? const LinearGradient(
                  colors: [Color(0xFF09818A), Color(0xFF1F98B8)],
                )
                    : null,
                color: _current == index ? null : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _categoriesWidget() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: imgCategoryList.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            if (nameCategoryList[i] == "Profile") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewProfile(title: '')),
              );
            } else if (nameCategoryList[i] == "Expert") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewExpert(title: '')),
              );
            } else if (nameCategoryList[i] == "Complaint") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewReply(title: '')),
              );
            } else if (nameCategoryList[i] == "Rating") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendReviewPage()),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09818A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    imgCategoryList[i],
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nameCategoryList[i],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _newsWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imgNews.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            if (imgtitle[i] == 'Request Status') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewRequestStatus(title: '')),
              );
            } else if (imgtitle[i] == 'Logs') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewLogs(title: '')),
              );
            }
          },
          child: Container(
            height: 140,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imgNews[i]),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  imgtitle[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}