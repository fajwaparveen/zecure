import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intrusion_detection/hms/app_theme.dart';
import 'package:intrusion_detection/hms/app_theme_notifier.dart';
import 'package:intrusion_detection/hms/utils/size_config.dart';
import 'package:intrusion_detection/hms/utils/validator.dart';
import 'package:intrusion_detection/hms/views/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  final TextEditingController nameTFController = TextEditingController();
  final TextEditingController emailTFController = TextEditingController();
  final TextEditingController passwordTFController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showPassword = false;
  bool isInProgress = false;

  late OutlineInputBorder allTFBorder;

  @override
  void initState() {
    super.initState();
    MySize().init(context);
  }

  void _initUI() {
    allTFBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    );
  }

  void _handleRegister() async {
    String username = nameTFController.text.trim();
    String email = emailTFController.text.trim();
    String password = passwordTFController.text;

    if (username.isEmpty) {
      showMessage("Please fill username");
    } else if (email.isEmpty) {
      showMessage("Please fill email");
    } else if (!Validator.isEmail(email)) {
      showMessage("Please enter a valid email");
    } else if (password.isEmpty) {
      showMessage("Please fill password");
    } else {
      setState(() {
        isInProgress = true;
      });

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        isInProgress = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    nameTFController.dispose();
    emailTFController.dispose();
    passwordTFController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeType = value.themeMode();
        // themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        _initUI();

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.red,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(top: 80),
              children: <Widget>[
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
                    margin: EdgeInsets.only(top: 24),
                    child: Text(
                      "Create New Account".toUpperCase(),
                      // style: AppTheme.getTextStyle(
                      //   themeData.textTheme.headline6,
                      //   color: themeData.colorScheme.onBackground,
                      //   fontWeight: 700,
                      //   letterSpacing: 0.5,
                      // ),
                    ),
                  ),
                ),
                _buildTextField(
                  controller: nameTFController,
                  icon: MdiIcons.accountOutline,
                  hintText: "Name",
                  keyboardType: TextInputType.text,
                ),
                _buildTextField(
                  controller: emailTFController,
                  icon: MdiIcons.emailOutline,
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller: passwordTFController,
                  icon: MdiIcons.lockOutline,
                  hintText: "Password",
                  obscureText: !showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(showPassword
                        ? MdiIcons.eyeOutline
                        : MdiIcons.eyeOffOutline),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(top: 16),
                      backgroundColor: themeData.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySize.size48),
                      ),
                      elevation: 3,
                    ),
                    onPressed: _handleRegister,
                    child: isInProgress
                        ? SizedBox(
                      width: MySize.size20,
                      height: MySize.size20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            themeData.colorScheme.onPrimary),
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Create".toUpperCase(),
                      // style: AppTheme.getTextStyle(
                      //   themeData.textTheme.button,
                      //   color: themeData.colorScheme.onPrimary,
                      //   fontWeight: 700,
                      //   letterSpacing: 0.8,
                      // ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "I have already an account",
                        // style: AppTheme.getTextStyle(
                        //   themeData.textTheme.bodyText2,
                        //   color: themeData.colorScheme.onBackground,
                        //   fontWeight: 500,
                        //   decoration: TextDecoration.underline,
                        // ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        // style: AppTheme.getTextStyle(
        //   themeData.textTheme.bodyText1,
        //   letterSpacing: 0.1,
        //   color: themeData.colorScheme.onBackground,
        //   fontWeight: 500,
        // ),
        decoration: InputDecoration(
          hintText: hintText,
          // hintStyle: AppTheme.getTextStyle(
          //   themeData.textTheme.subtitle2,
          //   color: themeData.colorScheme.onBackground.withAlpha(140),
          //   fontWeight: 500,
          // ),
          border: allTFBorder,
          enabledBorder: allTFBorder,
          focusedBorder: allTFBorder,
          prefixIcon: Icon(icon, size: MySize.size22),
          suffixIcon: suffixIcon,
          isDense: true,
          // contentPadding: Spacing.zero,
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          // style: AppTheme.getTextStyle(
          //   themeData.textTheme.subtitle2,
          //   letterSpacing: 0.4,
          //   color: themeData.colorScheme.onPrimary,
          // ),
        ),
        backgroundColor: themeData.colorScheme.primary,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
