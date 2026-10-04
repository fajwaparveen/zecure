import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:intrusion_detection/hms/app_theme.dart';
import 'package:intrusion_detection/hms/app_theme_notifier.dart';
import 'package:intrusion_detection/hms/utils/size_config.dart';
import 'package:intrusion_detection/hms/utils/validator.dart';
import 'package:intrusion_detection/hms/views/auth/register_screen.dart';
import '../app_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  // Controllers
  final TextEditingController emailTFController = TextEditingController();
  final TextEditingController passwordTFController = TextEditingController();

  // State
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInProgress = false;
  bool showPassword = false;

  // UI
  late OutlineInputBorder allTFBorder;

  @override
  void dispose() {
    emailTFController.dispose();
    passwordTFController.dispose();
    super.dispose();
  }

  void _initUI() {
    allTFBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    );
  }

  Future<void> _handleLogin() async {
    String email = emailTFController.text.trim();
    String password = passwordTFController.text;

    if (email.isEmpty) {
      showMessage("Please fill in your email");
    } else if (!Validator.isEmail(email)) {
      showMessage("Invalid email format");
    } else if (password.isEmpty) {
      showMessage("Please fill in your password");
    } else {
      setState(() => isInProgress = true);

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => isInProgress = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AppScreen()),
        );
      }
    }
  }

  void showMessage(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: themeData.textTheme.bodyMedium?.copyWith(
          color: themeData.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: themeData.colorScheme.primary,
      duration: duration,
    ));
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Consumer<AppThemeNotifier>(
      builder: (_, appThemeNotifier, __) {
        // themeData = AppTheme.getThemeFromThemeMode(appThemeNotifier.themeMode());
        customAppTheme = AppTheme.getCustomAppTheme(appThemeNotifier.themeMode());
        _initUI();

        return Scaffold(
          key: _scaffoldKey,
          // backgroundColor: customAppTheme.bgLayer1,
          resizeToAvoidBottomInset: true,
          body: ListView(
            padding: EdgeInsets.only(top: MySize().scaleHeight(150)),
            children: [
              Center(
                child: Image.asset(
                  './assets/images/logo.png',
                  color: themeData.colorScheme.primary,
                  width: 54,
                  height: 54,
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: MySize().scaleHeight(24)),
                  child: Text(
                    "WELCOME",
                    style: themeData.textTheme.titleLarge?.copyWith(
                      color: themeData.colorScheme.onBackground,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              _buildTextField(
                label: "Email Address",
                icon: MdiIcons.emailOutline,
                controller: emailTFController,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                label: "Password",
                icon: MdiIcons.lockOutline,
                controller: passwordTFController,
                obscureText: !showPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? MdiIcons.eyeOffOutline : MdiIcons.eyeOutline,
                  ),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(
                  horizontal: MySize().scaleHeight(24),
                  vertical: MySize().scaleHeight(8),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Forgot Password",
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              _buildLoginButton(),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: MySize().scaleHeight(16)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      "I don't have an account",
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        color: themeData.colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MySize().scaleHeight(24),
        MySize().scaleHeight(16),
        MySize().scaleHeight(24),
        0,
      ),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        style: themeData.textTheme.bodyMedium?.copyWith(
          color: themeData.colorScheme.onBackground,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: themeData.textTheme.bodySmall?.copyWith(
            color: themeData.colorScheme.onBackground.withAlpha(150),
          ),
          border: allTFBorder,
          enabledBorder: allTFBorder,
          focusedBorder: allTFBorder,
          prefixIcon: Icon(icon, size: MySize().scaleHeight(22)),
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MySize().scaleHeight(24),
        MySize().scaleHeight(24),
        MySize().scaleHeight(24),
        0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySize().scaleHeight(48)),
        boxShadow: [
          BoxShadow(
            color: themeData.colorScheme.primary.withAlpha(100),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: MySize().scaleHeight(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySize().scaleHeight(48)),
          ),
          backgroundColor: themeData.colorScheme.primary,
        ),
        onPressed: isInProgress ? null : _handleLogin,
        child: isInProgress
            ? SizedBox(
          width: MySize().scaleHeight(20),
          height: MySize().scaleHeight(20),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              themeData.colorScheme.onPrimary,
            ),
            strokeWidth: 2,
          ),
        )
            : Text(
          "LOGIN",
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.colorScheme.onPrimary,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
