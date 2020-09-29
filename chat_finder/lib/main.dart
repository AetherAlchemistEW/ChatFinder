import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/provider/image_upload_provider.dart';
import 'package:chat_finder/provider/theme_provider.dart';
import 'package:chat_finder/provider/user_provider.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/screens/home_screen.dart';
import 'package:chat_finder/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //initialise anything I'm going to provide here
  final FirebaseRepository _repository = FirebaseRepository();
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    _themeProvider.init();

    return StreamBuilder<ThemeData>(
        stream: _themeProvider.themeStream,
        initialData: ThemeData.fallback(),
        builder: (context, themeSnapshot) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
                ChangeNotifierProvider(create: (_) => UserProvider()),
                Provider(create: (_) => _themeProvider),
                //Provider(create: (_) => _repository,)
              ],
              child: MaterialApp(
                //initial route
                //routes
                title: "Chat Finder",
                debugShowCheckedModeBanner: false,
                theme: themeSnapshot.data,
                home: FutureBuilder(
                  future: _repository.getCurrentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
                    if (userSnapshot.hasData &&
                        userSnapshot.data.displayName != null) {
                      return HomeScreen();
                    } else {
                      return SplashScreen('lib/assets/SplashTutorial.flr', (_) => LoginScreen(), startAnimation: 'intro', until: () => Future.delayed(Duration(seconds: 3)),);
                    }
                  },
                ),
              )
          );
        }
    );
  }
}