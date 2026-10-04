import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intrusion_detection/hms/app_theme.dart';
import 'package:intrusion_detection/hms/app_theme_notifier.dart';
import 'package:intrusion_detection/hms/utils/size_config.dart';
import 'package:intrusion_detection/hms/views/home_screen.dart';
import 'package:intrusion_detection/hms/views/setting_screen.dart';
import 'package:intrusion_detection/hms/views/auth/register_screen.dart';
import 'package:intrusion_detection/hms/views/auth/login_screen.dart';

class AppScreen extends StatefulWidget {
  final int selectedPage;

  const AppScreen({Key? key, this.selectedPage = 0}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late TabController _tabController;
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedPage;
    _tabController = TabController(length: 4, vsync: this, initialIndex: _currentIndex);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeMode = value.themeMode();
        // themeData = AppTheme.getThemeFromThemeMode(themeMode);
        // customAppTheme = AppTheme.getCustomAppTheme(themeMode);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            backgroundColor: Colors.yellow,
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: themeData.cardTheme.shadowColor?.withAlpha(40) ?? Colors.black.withAlpha(40),
                  //     blurRadius: 3,
                  //     offset: const Offset(0, -3),
                  //   ),
                  // ],
                ),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: TabBar(
                  controller: _tabController,
                  indicator: const BoxDecoration(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: themeData.colorScheme.primary,
                  tabs: [
                    _buildTabItem(icon: MdiIcons.home, index: 0),
                    _buildTabItem(icon: MdiIcons.chat, index: 1),
                    _buildTabItem(icon: MdiIcons.bell, index: 2),
                    _buildTabItem(icon: MdiIcons.cog, index: 3),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                const HomeScreen(),
                LoginScreen(),
                 RegisterScreen(),
                 SettingScreen(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem({required IconData icon, required int index}) {
    bool selected = _currentIndex == index;
    return Container(
      child: selected
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: themeData.colorScheme.primary),
          Container(
            margin: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(2.5)),
            ),
            height: 5,
            width: 10,
          ),
        ],
      )
          : Icon(icon, color: themeData.colorScheme.onBackground),
    );
  }
}
