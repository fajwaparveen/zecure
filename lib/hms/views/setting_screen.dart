import 'package:intrusion_detection/hms/utils/size_config.dart';
import 'package:intrusion_detection/hms/views/select_theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../app_theme_notifier.dart';
import 'about_app_dialog.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //ThemeData
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Other Variables
  bool isInProgress = false;

  @override
  void initState() {
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeType = value.themeMode();
        // themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.green,
          appBar: AppBar(
            backgroundColor: themeData.colorScheme.primary,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Setting",
              // style: AppTheme.getTextStyle(
              //   themeData.appBarTheme.titleTextStyle ??
              //       themeData.textTheme.headline6,
              //   fontWeight: 600,
              //   color: themeData.colorScheme.onPrimary,
              // ),
            ),
          ),
          body: Column(
            children: [
              Container(
                height: MySize.size3,
                child: isInProgress
                    ? LinearProgressIndicator(
                  minHeight: MySize.size3,
                )
                    : SizedBox(height: MySize.size3),
              ),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.primary.withAlpha(20),
                    border: Border.all(width: 1),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/person.jpg", // Removed the "./" which is unnecessary in Flutter asset paths
                      ),
                    ),
                  ),
                  height: MySize.size68,
                  width: MySize.size68,
                ),
              ),
              SizedBox(width: MySize.size18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dimas Ibnu Malik",
                    // style: AppTheme.getTextStyle(
                    //   themeData.textTheme.headline6,
                    // ),
                  ),
                  Text(
                    "Flutter Developer",
                    // style: AppTheme.getTextStyle(
                    //   themeData.textTheme.caption,
                    //   fontWeight: 500,
                    // ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
        _menuItem(
          title: "Themes",
          icon: MdiIcons.lightbulb,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => SelectThemeDialog(),
            );
          },
        ),
        _menuItem(
          title: "Dashboard",
          icon: MdiIcons.home,
          onTap: () {},
        ),
        _menuItem(
          title: "Login",
          icon: MdiIcons.account,
          onTap: () {},
        ),
        _menuItem(
          title: "Register",
          icon: MdiIcons.accountPlus,
          onTap: () {},
        ),
        _menuItem(
          title: "About",
          icon: MdiIcons.frequentlyAskedQuestions,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AboutAppDialog(),
            );
          },
        ),
      ],
    );
  }

  Widget _menuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: themeData.colorScheme.secondary,
              size: MySize.size28,
            ),
            SizedBox(width: MySize.size24),
            Text(
              title,
              // style: AppTheme.getTextStyle(
              //   themeData.textTheme.subtitle1,
              //   fontWeight: 600,
              // ),
            )
          ],
        ),
      ),
    );
  }
}
