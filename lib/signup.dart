import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Signup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MyAddUserPage(),
    );
  }
}

class MyAddUserPage extends StatefulWidget {
  const MyAddUserPage({super.key});

  @override
  State<MyAddUserPage> createState() => _MyAddUserPageState();
}

class _MyAddUserPageState extends State<MyAddUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String gender = 'male';
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fix the errors in the form");
      return;
    }

    setState(() => _isLoading = true);

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String? baseUrl = sh.getString('url');
      if (baseUrl == null) {
        Fluttertoast.showToast(msg: "Server URL not configured");
        setState(() => _isLoading = false);
        return;
      }

      final uri = Uri.parse('$baseUrl/user_singup/');
      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields.addAll({
        'name': _nameController.text.trim(),
        'emailid': _emailController.text.trim(),
        'password': _passwordController.text,
        'phonenumber': _phoneController.text.trim(),
        'place': _placeController.text.trim(),
        'post': _postController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'gender': gender,
      });

      // Add image if selected
      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', _selectedImage!.path),
        );
      }

      var response = await request.send().timeout(const Duration(seconds: 30));
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200 && jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Account created successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Optional: Navigate to login or home
        // Navigator.pushReplacement(context, MaterialPageRouteBuilder(pageBuilder: (_,__,___) => LoginPage()));
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? "Registration failed",
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    _postController.dispose();
    _pincodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Picker
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                      _selectedImage != null ? FileImage(_selectedImage!) : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, size: 70, color: Colors.grey[600])
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Name
              _buildTextField(_nameController, "Full Name", Icons.person),
              const SizedBox(height: 16),

              // Email
              _buildTextField(_emailController, "Email Address", Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter email";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  }),

              const SizedBox(height: 16),

              // Gender
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.transgender, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    const Text("Gender: ", style: TextStyle(fontSize: 16)),
                    Radio<String>(
                      value: 'male',
                      groupValue: gender,
                      onChanged: (val) => setState(() => gender = val!),
                    ),
                    const Text("Male"),
                    Radio<String>(
                      value: 'female',
                      groupValue: gender,
                      onChanged: (val) => setState(() => gender = val!),
                    ),
                    const Text("Female"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Phone
              _buildTextField(_phoneController, "Phone Number", Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value?.length == 10 ? null : "Enter valid 10-digit number"),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_placeController, "Place", Icons.location_on),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(_postController, "Post", Icons.home),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildTextField(_pincodeController, "Pincode", Icons.pin_drop,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.length == 6 ? null : "Enter 6-digit pincode"),

              const SizedBox(height: 16),

              // Password
              _buildTextField(_passwordController, "Password", Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter password";
                    if (value.length < 6) return "Password must be at least 6 characters";
                    return null;
                  }),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      keyboardType: keyboardType,
      validator: validator ??
              (value) => value == null || value.trim().isEmpty ? "This field is required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}