import 'package:chat_finder/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> _themeButtons(BuildContext context, ThemeProvider themeProvider){
    List<Widget> buttons = new List<Widget>();

    for(var i = 0; i < themeProvider.themeCount; i++){
      ThemeData data = themeProvider.themes[i];
      buttons.add(Container(
        color: data.accentColor,
        child: RaisedButton(
          color: data.backgroundColor,
          elevation: data.buttonTheme.height,
          onPressed: () => themeProvider.setTheme(i),
          child: Text("Theme $i", style: data.textTheme.display1,),
        ),
      )
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(), /*GradientAppBar(
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor]),
        title: Text("Settings",
          style: Theme.of(context).primaryTextTheme.headline4,),
      ),*/
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Settings"),
            Text("Themes"),
            Column(
              children: _themeButtons(context, themeProvider),
            ),
          ],
        ),
      ),
    );
  }
}
