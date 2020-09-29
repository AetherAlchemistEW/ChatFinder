import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ThemeProvider{

  Stream<ThemeData> themeStream;
  StreamSink<ThemeData> themeSink;
  StreamController<ThemeData> themeController;

  void init(){
    themeController = PublishSubject<ThemeData>();
    themeStream = themeController.stream;
    themeSink = themeController.sink;

    themes = List<ThemeData>();
    themes.add(lightTheme());
    themes.add(darkTheme());
    themes.add(accessibleTheme());

    loadThemePreference().then(setTheme);
  }

  void dispose(){
    themeSink.close();
    themeController.close();
  }

  int themeCount = 3;
  List<ThemeData> themes;

  Future<void> saveThemePreference(int themeIndex) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setInt("theme", themeIndex);
  }

  Future<int> loadThemePreference() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //int themePref = prefs.getInt("theme");
    return 0;
  }

  void setTheme(int themeIndex){
    themeSink.add(themes[themeIndex]);
    //saveThemePreference(themeIndex);
  }

  //----THEMES-----
  ThemeData lightTheme(){
    ThemeData theme = ThemeData.light().copyWith(
      primaryColor: Colors.purple,
    );
    return theme;
  }

  ThemeData darkTheme(){
    return ThemeData.dark();
  }

  ThemeData accessibleTheme(){
    return ThemeData.fallback();
  }
}