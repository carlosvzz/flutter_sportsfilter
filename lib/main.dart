// import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sportsfilter/providers/app_model.dart';
import 'package:sportsfilter/providers/user_model.dart';
import 'package:sportsfilter/screens/screen_filters.dart';
import 'package:sportsfilter/screens/screen_home.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Firestore firestore = Firestore();
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          builder: (context) => UserModel(),
        ),
        ChangeNotifierProvider<AppModel>(
          builder: (context) => AppModel(),
        )
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sports Filter Bet',
          theme: _myTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => ScreenHome(),
            '/filtros': (context) => ScreenFilters(),
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('es', 'MX'), // Spanish
          ],
        ),
      ),
    );
  }
}

ThemeData _myTheme() {
  //Tigres
  // const Color myPrimaryColor = Color(0xFF005DAB);
  // const Color myAccentColor = Color(0xFFFCB034);
  //Texans
  const Color myPrimaryColor = Color(0xFF001331);
  const Color myAccentColor = Color(0xFFB82633);

  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: myPrimaryColor,
      accentColor: myAccentColor,
      buttonColor: myPrimaryColor,
      textTheme: TextTheme(
        headline: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: myAccentColor),
        title: TextStyle(
            fontSize: 30.0, fontStyle: FontStyle.italic, color: Colors.green),
        body1: TextStyle(
          fontSize: 17.0,
          fontFamily: 'ShareTech',
        ),
        body2: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        caption: TextStyle(
            fontSize: 19.0, fontWeight: FontWeight.bold, color: myAccentColor),
        display1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white70),
        display2: TextStyle(fontSize: 16.0, color: myAccentColor),
        display3: TextStyle(fontSize: 14.0, color: myAccentColor),
        display4: TextStyle(
            fontSize: 15.0, color: Colors.white70, fontWeight: FontWeight.bold),
        button: TextStyle(
          fontSize: 17.0,
        ),
      ),
      accentTextTheme: TextTheme(
        body1: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCB034)),
        body2: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.green),
      ));
}
