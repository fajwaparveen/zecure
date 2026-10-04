import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'viewprofile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
      home: const EditProfile(),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _placeController = TextEditingController();
  final _postController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String _photoUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    _postController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  // Fetch profile data from server
  Future<void> _fetchProfileData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString('url') ?? '';
      final lid = prefs.getString('lid').toString();
      final imgUrl = prefs.getString('img_url') ?? '';

      if (url.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Configuration missing');
        return;
      }

      final response = await http.post(
        Uri.parse('$url/user_view_profile/'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _emailController.text = data['emailid'] ?? '';
            _phoneController.text = data['phonenumber'] ?? '';
            _placeController.text = data['place'] ?? '';
            _postController.text = data['post'] ?? '';
            _pincodeController.text = data['pincode'].toString();
            _photoUrl = '$imgUrl${data['photo'] ?? ''}';
          });
        } else {
          Fluttertoast.showToast(msg: 'Profile not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Pick and crop image
  Future<void> _pickAndCropImage() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile =pickedFile;
        if (croppedFile != null) {
          setState(() {
            _selectedImage = File(croppedFile.path);
          });
        } else {
          Fluttertoast.showToast(msg: 'No image selected');
        }
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  // Show permission denied dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Please grant photo access in settings to select an image.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Submit profile data
  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString('url') ?? '';
      final lid = prefs.getString('lid').toString();

      if (url.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: 'Server configuration missing');
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/user_editprofile/'),
      );
      request.fields.addAll({
        'name': _nameController.text,
        'emailid': _emailController.text,
        'phonenumber': _phoneController.text,
        'place': _placeController.text,
        'post': _postController.text,
        'pincode': _pincodeController.text,
        'lid': lid,
      });

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', _selectedImage!.path),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Profile updated successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewProfile(title: '')),
        );
      } else {
        Fluttertoast.showToast(msg: 'Failed to update profile');
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
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1F98B8), const Color(0xFF09818A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade100, Colors.blue.shade100],
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
                  children: [
                    // Profile picture
                    GestureDetector(
                      onTap: _pickAndCropImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.cyan.shade100,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : _photoUrl.isNotEmpty
                            ? NetworkImage(_photoUrl)
                            : null,
                        child: _selectedImage == null && _photoUrl.isEmpty
                            ? const Icon(Icons.add_a_photo, size: 40, color: Colors.cyan)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to change profile picture',
                      style: TextStyle(color: Colors.cyan.shade700, fontSize: 12),
                    ),
                    const SizedBox(height: 20),

                    // Form fields
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                      value!.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) return 'Phone number is required';
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(labelText: 'Place'),
                      validator: (value) =>
                      value!.isEmpty ? 'Place is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _postController,
                      decoration: const InputDecoration(labelText: 'Post'),
                      validator: (value) =>
                      value!.isEmpty ? 'Post is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pincodeController,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Pincode is required';
                        if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                          return 'Enter a valid 6-digit pincode';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitProfile,
                      style: ElevatedButton.styleFrom(
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
                        'Update Profile',
                        style: TextStyle(fontSize: 16),
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

// Placeholder for EdProfiles (replace with actual implementation)
class EdProfiles extends StatelessWidget {
  final String title;
  const EdProfiles({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('View Profile Page')),
    );
  }
}