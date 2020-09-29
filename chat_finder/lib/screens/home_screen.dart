import 'package:chat_finder/provider/user_provider.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/screens/contact_screen.dart';
import 'package:chat_finder/screens/pickup/pickup_layout.dart';
import 'package:chat_finder/screens/profile_screen.dart';
import 'package:chat_finder/screens/queue_screen.dart';
import 'package:chat_finder/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  PageController pageController;
  int _page = 0;

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of(context, listen: false);
      userProvider.refreshUser();
    });

    pageController = PageController();
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    //dispose profile page?
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {

    double _labelFontSize = 10;

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: PageView(
          children: <Widget>[
            //Text("Profile")),
            Container(child: ProfileScreen(),),
            Container(child: QueueScreen(),),
            Container(child: ContactScreen(),),
            //Container(child: SettingsScreen(),),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: _navigationBar(),
      ),
    );
  }

  Widget _navigationBar(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      verticalDirection: VerticalDirection.up,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => navigationTapped(0),
            child: Container(
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(10),
                color: _page == 0 ? Theme.of(context).buttonTheme.colorScheme.primary : Theme.of(context).buttonTheme.colorScheme.primaryVariant,
              ),
              height: 75,
              width: MediaQuery.of(context).size.width/4,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigationTapped(1),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 75,
                width: MediaQuery.of(context).size.width/3,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(50),
                  color: _page == 1 ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                ),
                width: MediaQuery.of(context).size.width/3,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => navigationTapped(2),
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(10),
                color: _page == 2 ? Theme.of(context).buttonTheme.colorScheme.primary : Theme.of(context).buttonTheme.colorScheme.primaryVariant,
              ),
              width: MediaQuery.of(context).size.width/4,
            ),
          ),
        ),
      ],
    );
  }
}