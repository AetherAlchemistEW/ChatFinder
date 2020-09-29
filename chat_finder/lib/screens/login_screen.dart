import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/screens/home_screen.dart';
import 'package:chat_finder/widgets/topicSelectionCard.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:ggj2020/elements/social_button.dart';
//import 'package:ggj2020/pages/Setup/emailSignInCard.dart';
//import 'package:ggj2020/sidebar/sideBarLayout.dart';
//import 'package:ggj2020/ThemeHandler.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  FirebaseRepository _repository = FirebaseRepository();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //_repository = Provider.of<FirebaseRepository>(context);
    //checkSignedIn();
    //authenticateUser();
    //authenticateUser();
    //print(mounted);
  }

  Future<void> checkSignedIn() async {
    FirebaseAuth result = FirebaseAuth.instance;
    FirebaseUser user = await result.currentUser();
    if(user != null){
      isLoading = false;
      //go to home screen
      Navigator.pushReplacement(_scaffoldKey.currentContext, MaterialPageRoute(builder: (homeContext) => HomeScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Center(child: isLoading ? CircularProgressIndicator() : SizedBox(height: 0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                  //child: _buildHeader(),
                ),
                SizedBox(height: 48.0),
                FlatButton(
                  color: isLoading ? Colors.grey : Colors.blue,
                  child: Text(
                    "Log in with Facebook",
                    style: TextStyle(
                      //TODO: add button style
                    ),
                  ),
                  onPressed: isLoading ? null : () => _signInWithFacebook(context),
                ),
                FlatButton(
                  color: isLoading ? Colors.grey : Colors.redAccent,
                  child: Text(
                    "Log in with Google",
                    style: TextStyle(
                      //TODO: add button style
                    ),
                  ),
                  onPressed: isLoading ? null : () => _signInWithGoogle(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    /*PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);*/
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    print("Try to sign in");
    try {
      //print(mounted);
      setState(() {
        isLoading = true;
      });
      await _repository.signInWithGoogle();
      print("returned");
      setState(() {
        authenticateUser(context);
        isLoading = false;
      });
      //print(mounted);
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _repository.signInWithFacebook();
      setState(() {
        authenticateUser(context);
        isLoading = false;
      });
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void authenticateUser(BuildContext context) async {
    FirebaseAuth result = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await result.currentUser();
    if(firebaseUser != null) {
      //print("User found");
      _repository.authenticateUser(firebaseUser).then((isNewUser) async {
        if (isNewUser) {
          print("New User $isNewUser");
          //print(context.toString());
          //show card and wait for return info. Build 'USER' data
          //TODO: change to receiving 'USER'
          /*User user = await Navigator.push(_scaffoldKey.currentContext,
              MaterialPageRoute(builder: (context){
                return InitialProfileCard();
              })
          );*/
          User user = User(
            uid: firebaseUser.uid,
            username: "User-"+firebaseUser.uid,
            profilePhoto: "gs://chatfinder-f878a.appspot.com/generic-profile-picture.jpg",
          );
          //Navigator.push(_scaffoldKey.currentContext, route)
          _repository.registerUser(user).then((value) {
            //print("result $value");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                })
            );
          });
        } else {
          print("Not new");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return HomeScreen();
              })
          );
        }
      });
    }
  }
}

