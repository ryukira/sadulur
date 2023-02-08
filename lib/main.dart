import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sadulur/components/life_cycle_event_handler.dart';
import 'package:sadulur/landing/landing_page.dart';
import 'package:sadulur/screens/mainscreen.dart';
import 'package:sadulur/services/user_service.dart';
import 'package:sadulur/utils/config.dart';
import 'package:sadulur/utils/constants.dart';
import 'package:sadulur/utils/providers.dart';
import 'package:sadulur/view_models/theme/theme_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () => UserService().setUserStatus(false),
        resumeCallBack: () => UserService().setUserStatus(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  return TabScreen();
                } else
                  return Landing();
              }),
            ),
          );
        },
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(
        theme.textTheme,
      ),
    );
  }
}
