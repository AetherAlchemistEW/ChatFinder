import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor]),
        title: Text("Contacts",
          style: Theme.of(context).primaryTextTheme.headline4,),
      ),
      body: Container(
        child: Text("Contact Screen"),
      ),
    );
  }
}
