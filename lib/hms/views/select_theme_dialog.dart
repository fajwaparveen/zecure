import 'package:intrusion_detection/hms/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_theme_notifier.dart';

class SelectThemeDialog extends StatefulWidget {
  @override
  _SelectThemeDialogState createState() => _SelectThemeDialogState();
}

class _SelectThemeDialogState extends State<SelectThemeDialog> {
  late ThemeData themeData;

  void _handleRadioValueChange(int value) {
    // Update theme first then pop dialog to avoid potential rebuild issues
    Provider.of<AppThemeNotifier>(context, listen: false).updateTheme(value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier themeNotifier, Widget? child) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _handleRadioValueChange(AppTheme.themeLight);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 0, left: 16),
                    child: Row(
                      children: <Widget>[
                        Radio<int>(
                          value: AppTheme.themeLight,
                          groupValue: themeNotifier.themeMode(),
                          activeColor: themeData.colorScheme.primary,
                          onChanged: (int? value) {
                            if (value != null) {
                              _handleRadioValueChange(value);
                            }
                          },
                        ),
                        Text(
                          "Light",
                          // style: AppTheme.getTextStyle(
                          //   themeData.textTheme.subtitle2,
                          //   fontWeight: 600,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _handleRadioValueChange(AppTheme.themeDark);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                    child: Row(
                      children: <Widget>[
                        Radio<int>(
                          value: AppTheme.themeDark,
                          groupValue: themeNotifier.themeMode(),
                          activeColor: themeData.colorScheme.secondary,
                          onChanged: (int? value) {
                            if (value != null) {
                              _handleRadioValueChange(value);
                            }
                          },
                        ),
                        Text(
                          "Dark",
                          // r
                        ),
                      ],
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
}
