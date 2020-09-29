import 'dart:io';

import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/provider/image_upload_provider.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  FirebaseRepository _repository = FirebaseRepository();
  List <String> topics;
//Text controllers
  TextEditingController usernameController = TextEditingController();
  bool isLoading = true;

  String imagePath = "";
  ImagePicker picker = ImagePicker();
  ImageUploadProvider _imageUploadProvider = ImageUploadProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    topics = new List<String>();
    user = await _repository.getUserDetails();
    imagePath = user.profilePhoto;
    //usernameController.text = user.username;
    await _getTopics();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor]),
        title: Text("Profile",
          style: Theme.of(context).primaryTextTheme.headline4,),
      ),
      body: Container(
        alignment: Alignment.center,
        child: isLoading ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Container(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(user.username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  //IMAGE UPLOAD WIDGET
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Icon(Icons.image),
                    imageUploadButton(),
                    ],
                  ),
                  //TOPIC WIDGET
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.announcement),
                      topicSelectorOne(),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.announcement),
                      topicSelectorTwo(),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.announcement),
                      topicSelectorThree(),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.announcement),
                      topicSelectorFour(),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.announcement),
                      topicSelectorFive(),
                    ],
                  ),

                  RaisedButton(
                    child: Text("Sign out", style: Theme.of(context).primaryTextTheme.button,),
                    onPressed: () => _repository.signOut(),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget entry({String leading, IconData icon, @required Function onChanged, TextEditingController controller,}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: leading,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget topicSelectorOne(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text(user.topicOne),
        value: user.topicOne,
        onChanged: (string) => setState(() {user.topicOne = string; updateFirebase();}),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorTwo(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text(user.topicTwo),
        value: user.topicTwo,
        onChanged: (string) => setState(() {user.topicTwo = string; updateFirebase();}),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorThree(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text(user.topicThree),
        value: user.topicThree,
        onChanged: (string) => setState(() {user.topicThree = string; updateFirebase();}),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorFour(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text(user.topicFour),
        value: user.topicFour,
        onChanged: (string) => setState(() {user.topicFour = string; updateFirebase();}),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorFive(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text(user.topicFive),
        value: user.topicFive,
        onChanged: (string) => setState(() {user.topicFive = string; updateFirebase();}),
        items: _topicItems(),
      ),
    );
  }

  List<DropdownMenuItem> _topicItems (){
    List<DropdownMenuItem> items = List();
    for(String e in topics){
      items.add(
        new DropdownMenuItem(value: e, child: Text(e)),
      );
    }
    return items;
  }

  _getTopics() async {
    topics = await _repository.getTopics();
    setState(() {
    });
  }

  Widget imageUploadButton() {
    return FlatButton(
      child: Container(
        width: 120,
        height: 150,
        child: imagePath == ""
            ? Icon(Icons.person)
            : Image(image: NetworkImage(imagePath)),
      ),
      onPressed: () {
        pickImage(source: ImageSource.gallery);
      },
    );
  }

  pickImage({@required ImageSource source}) async {
    File chosenImage = await picker.getImage(source: source).then((file) => File(file.path));
    File compressedImage = await Utils.compressImage(chosenImage);
    String url = await _repository.uploadProfileImage(
      image: compressedImage,
      imageUploadProvider: _imageUploadProvider,
    );
    setState(() {
      imagePath = url;
      user.profilePhoto = url;
      updateFirebase();
    });
  }

  updateFirebase(){
    _repository.registerUser(user);
  }
}


