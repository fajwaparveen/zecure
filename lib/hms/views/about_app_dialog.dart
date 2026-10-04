import 'package:intrusion_detection/hms/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_theme_notifier.dart';

class AboutAppDialog extends StatefulWidget {
  const AboutAppDialog({super.key}); // Add key for best practice

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  late ThemeData themeData;

  final String appDescription =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
      "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
      "when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
      "It has survived not only five centuries, but also the leap into electronic typesetting, "
      "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets "
      "containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker.";

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            elevation: 0,
            child: SizedBox(
              width: MySize.safeWidth * 0.85,
              height: MySize.safeHeight * 0.75,
              child: Stack(
                children: [
                  // Close button
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        MdiIcons.close,
                        color: themeData.colorScheme.primary,
                      ),
                    ),
                  ),

                  // Content
                  Positioned.fill(
                    top: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "About App :",
                              // style: AppTheme.getTextStyle(
                              //   themeData.textTheme.headline6,
                              // ),
                            ),
                            SizedBox(height: MySize.size10),
                            Text(
                              "Your App Name",
                              // style: AppTheme.getTextStyle(
                              //   themeData.textTheme.headline6,
                              //   color: themeData.colorScheme.primary,
                              //   fontWeight: FontWeight.w700,
                              // ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                color: themeData.colorScheme.onPrimary,
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/logo.png',
                                  ),
                                ),
                              ),
                              height: MySize.size180,
                              width: MySize.size180,
                            ),
                            Text(
                              appDescription,
                              textAlign: TextAlign.justify,
                              // style: AppTheme.getTextStyle(
                              //   themeData.textTheme.bodyText2,
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
